//
//  ChatMessagingViewController.swift
//  DailyTraining
//
//  Created by William Reña on 7/13/20.
//  Copyright © 2020 Andrew Daugdaug. All rights reserved.
//

import UIKit
import SafariServices
import SendBirdSDK
import CRRefresh
import MobileCoreServices
import WebKit
import AVFoundation
import Photos
import DKImagePickerController


protocol ChatMessagingProtocol: AnyObject {
	func leavedConversation(channelUrl: String?)
	func channelMessagesMarkedAsRead(channelUrl: String)
}

extension ChatMessagingViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
		
	func compressVideo(
		inputURL: URL,
		outputURL: URL,
		handler:@escaping (_ exportSession: AVAssetExportSession?)-> Void) {
		
        let urlAsset = AVURLAsset(url: inputURL, options: nil)
        guard let exportSession = AVAssetExportSession(
				asset: urlAsset,
				presetName: AVAssetExportPresetHighestQuality) else {
            handler(nil)
            return
        }

        exportSession.outputURL = outputURL
		exportSession.outputFileType = AVFileType.mp4
        exportSession.shouldOptimizeForNetworkUse = true
        exportSession.exportAsynchronously { () -> Void in
            handler(exportSession)
        }
    }
	
	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		picker.dismiss(animated: true) {
			self.keyboardHeight = 0.0
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
				self.autoScrollMessages(allowScrolling: false)
			}
		}
		self.txtvMessage.resignFirstResponder()
	}
	
	func imagePickerController(
		_ picker: UIImagePickerController,
		didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		
		picker.dismiss(animated: true) {
			if let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String {
				if mediaType  == "public.image" {
					guard self.sendingMessageLock == false else { return }
					if let image = info[.originalImage] as? UIImage {
						self.sendImage(image: image)
					}
				}
				else if mediaType == "public.movie" {
					guard self.sendingMessageLock == false else { return }
					guard let videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? NSURL else { return }
					
					let compressedURL = NSURL.fileURL(withPath: NSTemporaryDirectory() + NSUUID().uuidString + ".mp4")
					self.compressVideo(
						inputURL: videoURL as URL,
						outputURL: compressedURL) { (exportSession) in

						 guard let session = exportSession else {
							 return
						 }

						 switch session.status {
						 case .unknown,
							  .waiting,
							  .exporting,
							  .failed,
							  .cancelled:
							 break
						
						 case .completed:
							 guard let compressedData = NSData(contentsOf: compressedURL) else {
								 return
							 }
							self.sendVideo(videoData: compressedData,
										   lastPathComponent: compressedURL.lastPathComponent)
							
						 }

					 }
					
				}
			}

		}
		
	}
}

extension ChatMessagingViewController: UIDocumentPickerDelegate, UIDocumentInteractionControllerDelegate {
	func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
		self.keyboardHeight = 0.0
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
			self.autoScrollMessages(allowScrolling: false)
		}
		self.txtvMessage.resignFirstResponder()
	}
	func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let selectedFileURL = urls.first else {
            return
        }
		guard let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
			return
		}
		
		let sandboxFileURL = dir.appendingPathComponent(selectedFileURL.lastPathComponent)
		if FileManager.default.fileExists(atPath: sandboxFileURL.path) {
			do {
				let data =  NSData.init(contentsOf: sandboxFileURL)
				guard let documentData = data else { return }
				self.sendDocument(documentData: documentData, lastPathComponent: selectedFileURL.lastPathComponent)
			}
		}
		else {
			do {
				//Copying File to be able to use it.
			   try FileManager.default.copyItem(at: selectedFileURL, to: sandboxFileURL)
			   do {
				let data =  NSData.init(contentsOf: sandboxFileURL)
					guard let documentData = data else { return }
				   self.sendDocument(documentData: documentData, lastPathComponent: selectedFileURL.lastPathComponent)
			   }
			}
			catch {
				DebugInfo.log(info: "\(DebugInfoKey.messaging.rawValue) document-picker error \(error.localizedDescription)")
			}
				   
		}
		
    }
    
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
		 UINavigationBar.appearance().tintColor = UIColor.black
        return self
    }
    
}

class ChatMessagingViewController: TITViewController, UITextViewDelegate, UITableViewDataSource, UITableViewDelegate, SBDChannelDelegate, ChatOwnedOtherFileMessageTableViewCellDelegate, ChatOtherFileMessageTableViewCellDelegate {
	
	@IBOutlet weak var toolbarBarline: UIView!
	var isEditingMessage = false
	var isCurrentlyUploadingFiles = false
	var imagePicker = UIImagePickerController()
	var webView : WKWebView!
	var selectedUrl: String = ""
	let documentTypes = [kUTTypePlainText as String,
						 kUTTypePDF as String,
						"com.microsoft.word.doc",
						"com.microsoft.powerpoint.ppt",
						"org.openxmlformats.wordprocessingml.document",
						"org.openxmlformats.spreadsheetml.sheet",
						"org.openxmlformats.presentationml.presentation"]
	
	@IBOutlet weak var btnSend: UIButton!
	@IBOutlet weak var btnCamera: UIButton!
	@IBOutlet weak var btnDocument: UIButton!
	@IBOutlet weak var tblMessages: UITableView!
	@IBOutlet weak var txtvMessage: UITextView!
	@IBOutlet weak var viewFooterBg: UIView!
	@IBOutlet weak var viewMessageBg: UIView!
	
	@IBOutlet weak var cameraWidthConstraint: NSLayoutConstraint!
	@IBOutlet weak var cameraToDocumentConstraint: NSLayoutConstraint!
	@IBOutlet weak var documentWidthConstraint: NSLayoutConstraint!
	@IBOutlet weak var documentToTextboxWidthConstraint: NSLayoutConstraint!
	
	@IBOutlet weak var viewFooterBottomConstraint: NSLayoutConstraint!
	@IBOutlet weak var messageHeightConstraint: NSLayoutConstraint!
	
	// scrolling message reference object
	var viewableMessagesView: UIView = UIView()
	
	let SEND_MESSAGE_PLACEHOLDER_TEXTCOLOR: UIColor = Shortcut.appDelegate.themeManager?.getMainChatFieldText() ?? .lightGray
	let SEND_MESSAGE_TEXTCOLOR: UIColor = Shortcut.appDelegate.themeManager?.getMainChatFieldText() ?? .black
	let SEND_MESSAGE_MIN_HEIGHT: CGFloat = CGFloat(40.0)
	let SEND_MESSAGE_MAX_HEIGHT: CGFloat = CGFloat(160.0)
	
	lazy var DELEGATE_IDENTIFIER = UUID().uuidString
	
	// indicator that a keyboard has shown
	private var keyboardHeight: CGFloat = CGFloat(0.0)
	
	private let cameraWidth: CGFloat = CGFloat(31.0)
	private let documentWidth: CGFloat = CGFloat(22.0)
	private let cameraToDocumentWidth: CGFloat = CGFloat(15.0)
	
	public lazy var controller = ChatMessagingController()
	private var messages: [ChatMessageVM] = [ChatMessageVM]() {
		didSet {
			self.updateMessageGroupings()
		}
	}
	
	private var footerBarHeight: CGFloat {
		get {
			let footerBarRect = self.viewFooterBg.frame
			return footerBarRect.size.height
		}
	}
	
	// implicit
	var loginUserId: String = ""
	var editableMessageIndex: Int? {
		didSet {
			if let index = editableMessageIndex {
				let editingMessage = self.messages[index]
				DispatchQueue.main.async {
					self.hideFileButtons()
					self.prepareForEditMessage(message: editingMessage.message)
				}
			}
			else {
				DispatchQueue.main.async {
					self.unhideFileButtons()
					self.prepareForNextMessage()
				}
			}
		}
	}
	// members (Open Channel) or participants (Group Channel)
	var members: [ChatPeopleVM] = [ChatPeopleVM]()
	var hasMoreParticipants: Bool = false
	var updatedMessageId: Int64 = 0
	
	// explicit
	var channelFrozen: Bool = false
	var channelUrl: String?
	var channelCoverUrl: String?
	var channelType: ChannelType?
	var channelHasInactiveMember: Bool = false
	weak var delegate: ChatMessagingProtocol?
	
    private var getPreviousMessagesLock: Bool = true
    private var sendingMessageLock: Bool = true
    private var messagingEnabled: Bool = false {
        didSet {
            self.viewFooterBg.isUserInteractionEnabled = messagingEnabled
            self.txtvMessage.isEditable = messagingEnabled
            self.btnSend.isEnabled = messagingEnabled
            
            if messagingEnabled {
                self.sendingMessageLock = false
                self.getPreviousMessagesLock = false
            }
        }
    }
	private var sendButtonEnabled: Bool = false {
		didSet {
			if self.sendButtonEnabled {
				DispatchQueue.main.async {
					self.btnSend.tintColor = Shortcut.appDelegate.themeManager?.getMainChatContent() ?? .lightGray
					self.btnSend.isUserInteractionEnabled = true
				}
			}
			else {
				DispatchQueue.main.async {
					self.btnSend.tintColor = UIColor.lightGray.withAlphaComponent(0.5)
					self.btnSend.isUserInteractionEnabled = false
				}
			}
		}
	}
	private var cameraButtonEnabled: Bool = false {
		didSet {
			if self.cameraButtonEnabled {
				DispatchQueue.main.async {
					self.btnCamera.tintColor = Shortcut.appDelegate.themeManager?.getMainChatContent() ?? .lightGray
					self.btnCamera.isUserInteractionEnabled = true
				}
			}
			else {
				DispatchQueue.main.async {
					self.btnCamera.tintColor = UIColor.lightGray.withAlphaComponent(0.5)
					self.btnCamera.isUserInteractionEnabled = false
				}
			}
		}
	}
	private var documentButtonEnabled: Bool = false {
		didSet {
			if self.documentButtonEnabled {
				DispatchQueue.main.async {
					self.btnDocument.tintColor = Shortcut.appDelegate.themeManager?.getMainChatContent() ?? .lightGray
					self.btnDocument.isUserInteractionEnabled = true
				}
			}
			else {
				DispatchQueue.main.async {
					self.btnDocument.tintColor = UIColor.lightGray.withAlphaComponent(0.5)
					self.btnDocument.isUserInteractionEnabled = false
				}
			}
		}
	}
	private var customNavigationBar: CustomNavBar?
	
	// MARK: - View Controller Life Cycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
	
		self.view.backgroundColor = Shortcut.appDelegate.themeManager?.getMainChatBg()
		
		self.viewFooterBg.backgroundColor = Shortcut.appDelegate.themeManager?.getMainChatFooterBg()
		self.viewFooterBg.clipsToBounds = true
		
		self.viewMessageBg.backgroundColor = Shortcut.appDelegate.themeManager?.getMainChatFieldBg().withAlphaComponent(0.5)
		
		self.sendButtonEnabled = false
		self.cameraButtonEnabled = true
		self.documentButtonEnabled = true
		
		self.txtvMessage.text = "send_a_message".localized()
		self.txtvMessage.textColor = SEND_MESSAGE_PLACEHOLDER_TEXTCOLOR
		self.txtvMessage.tintColor = SEND_MESSAGE_TEXTCOLOR
		self.txtvMessage.backgroundColor = .clear
		self.txtvMessage.font = UIFont.setRegular(fontSize: 16.0)
		self.txtvMessage.isScrollEnabled = false
		self.txtvMessage.delegate = self
		
		// cursor position
		let beginPosition = self.txtvMessage.beginningOfDocument
		self.txtvMessage.selectedTextRange = self.txtvMessage.textRange(from: beginPosition,
																		to: beginPosition)
		
		self.messageHeightConstraint.constant = SEND_MESSAGE_MIN_HEIGHT
		
		self.tblMessages.dataSource = self
		self.tblMessages.delegate = self
		self.tblMessages.tableHeaderView = UIView()
		self.tblMessages.tableFooterView = UIView()
		self.tblMessages.separatorStyle = .none
		self.tblMessages.backgroundColor = self.view.backgroundColor

		let longPressGesture:UILongPressGestureRecognizer = UILongPressGestureRecognizer(
			target: self,
			action: #selector(messageLongPressHandler(_:)))
		longPressGesture.minimumPressDuration = 1.0 // 1 second press
		self.tblMessages.addGestureRecognizer(longPressGesture)
		
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.window?.backgroundColor = self.view.backgroundColor
        }
        
		self.addObservers()
        
        // alert container view controllert
        ChatManager.alertContainerVC = self
        
        // register message cells
        // prepare sending message user interface
        self.initialize()
        
        // connecting to channel
        self.connectToChannel()
				
		if Shortcut.appDelegate.themeManager?.activeTheme.appCode == AppCode.ugo.title {
			self.toolbarBarline.isHidden = false
			self.toolbarBarline.backgroundColor = UIColor.hex("BABABA", alpha: 0.5)
		}
		else {
			self.toolbarBarline.isHidden = true
		}
		
		if(self.channelHasInactiveMember) {
			self.showDeactivatedUserError()
		}
    }
	
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
		
		self.unhideFileButtons()
		self.unlockFileButtons()
		self.unlockMessaging()
		
		var menuOptions: [String] = [GroupChannelMenu.information.rawValue,
									 GroupChannelMenu.leave.rawValue]
		var showMultipleConversationOptions = false
		if let channelType = self.channelType {
			if channelType == .openChannel || channelType == .multipleConversation {
				showMultipleConversationOptions = true
			}
			if channelType == .openChannel {
				menuOptions = [GroupChannelMenu.information.rawValue]
			}
        }
		
        navigationController?
            .navigationBar
            .setupNavWithTitle(title: self.title,
                               settings: NavigationAppearance(
                                    parentView: self.view,
                                    showBack: true,
                                    showNext: showMultipleConversationOptions,
                                    backType: .closeView,
                                    barContentColor: Shortcut.appDelegate.themeManager?.getMainChatTitleContent(),
                                    barColor: Shortcut.appDelegate.themeManager?.getMainChatTitleBar(),
                                    nextType: .image),
                               shouldRemoveShadow: false,
                               nextImage: UIImage.init(named: "vertical-elipseDots"),
                               onSuccess: { (customView) in
									if let customNavigationBar = customView as? CustomNavBar {
										customNavigationBar.btnNext.isEnabled = false
										DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
											customNavigationBar.btnNext.isEnabled = true
										}
										self.customNavigationBar = customNavigationBar
									}
                               },
                               onBack: {
									if let channelType = self.channelType,
									   channelType == .openChannel {
										self.controller.leaveConversation(completion: {
											self.leaveMessaging(leaveToChannel: false,
																animatedDismiss: true,
																completionHandler: {
												()
											})
										})
									}
									else {
										self.leaveMessaging(leaveToChannel: false,
															animatedDismiss: true,
															completionHandler: {
											()
										})
									}
                               },
                               onNext: {
                                    PopUpManager.showMenu(
                                        menu: menuOptions,
                                        vc: self,
                                        confirm: { rawValue in
                                            switch rawValue {
                                            case GroupChannelMenu.information.rawValue:
												self.txtvMessage.resignFirstResponder()
												self.performSegue(withIdentifier: ChatScreen.messagingGroupInformation.segueIdentifier,
																  sender: nil)
                                            case GroupChannelMenu.leave.rawValue:
                                                PopUpManager.popInfo(
                                                    message: "confirm_leave_conversation".localized(),
                                                    showVC: self,
                                                    okay: {
														self.controller.leaveConversation(completion: {
															self.leaveMessaging(leaveToChannel: true,
																				animatedDismiss: true,
																				completionHandler: {
																()
															})
														})
                                                    },
                                                    cancel: {
                                                        ()
                                                    })
                                            default: ()
                                            }
                                        })
                               })
		
		
		
		if Shortcut.appDelegate.themeManager?.activeTheme.appCode == AppCode.ugo.title {
			navigationController?.navigationBar.shadowImage = UIColor.hex("BABABA", alpha: 0.5).as1ptImage()
		}
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
		self.selectedUrl = ""
    }
    
    // MARK: - Actions
    
    @IBAction func btnSendAction(_ sender: UIButton) {
        guard self.sendingMessageLock == false else { return }
        if let message = self.txtvMessage.text {
			if message.count > 0 {
				let validatedMessage = self.getValidatedMessage(message: message)
				if validatedMessage.count > 0 &&
					validatedMessage != "send_a_message".localized() {
					self.sendMessage(message: message)
				}
            }
        }
    }
	
	@IBAction func btnSendCamera(_ sender: UIButton) {
		self.chooseMedia()
	}
	
	@IBAction func btnSendDocument(_ sender: UIButton) {
		PopUpManager.showAttachDocumentMenu(
			viewController: self,
			previouslySelected: nil,
			confirm: { (type, name) in
				if type == .document {
					let documentPicker = UIDocumentPickerViewController(documentTypes: self.documentTypes, in: .import)
					documentPicker.delegate = self
					documentPicker.allowsMultipleSelection = false
					self.present(documentPicker, animated: true, completion: nil)
				}
				else if type == .gallery {
					self.openMediaFromSource(sourceType: .photoLibrary, cameraCaptureMode: .photo)
				}

		})
	}
    
    // MARK: - Messaging
    
    private func connectToChannel() {
        self.messagingEnabled = false
        
        guard let channelUrl = self.channelUrl,
            let channelType = self.channelType else { return }
        
        if channelType == .openChannel {
            DebugInfo.log(info: "\(DebugInfoKey.messaging.rawValue) entering-to-open-channel \(channelUrl)")
            
            self.controller.enterToOpenChannel(
                channelUrl: channelUrl,
                completion: { (hasNext, members) in
                    DebugInfo.log(info: "\(DebugInfoKey.messaging.rawValue) entered-to-open-channel \(channelUrl) with \(members.count) participants")
					self.hasMoreParticipants = hasNext
                    self.members = members
					
					// handle receiving messages
					SBDMain.add(self, identifier: self.DELEGATE_IDENTIFIER)
					
					if let loginUser = self.controller.getLoginUser() {
						self.loginUserId = "\(loginUser.id ?? 0)"
					}
					self.messagingEnabled = true
					self.getChannelMessages()
			})
		}
		else {
			DebugInfo.log(info: "\(DebugInfoKey.messaging.rawValue) entering-to-group-channel \(channelUrl)")
			
			self.controller.enterToGroupChannel(
				channelUrl: channelUrl,
				completion: { members in
					DebugInfo.log(info: "\(DebugInfoKey.messaging.rawValue) entered-to-group-channel \(channelUrl) with \(members.count) members")
					self.members = members
					if(self.members.count == 2) {
						var members = [String]()
						self.members.forEach { member in
							members.append(member.userId)
						}
						// Confirmatory to re-check active members count.
						ChatManager.getActiveMembers(members: members) { (activeMembers) in
							if(activeMembers.count != self.members.count){
								self.showDeactivatedUserError()
							}
						}

					}
					
					// handle receiving messages
					SBDMain.add(self, identifier: self.DELEGATE_IDENTIFIER)
					
					if let loginUser = self.controller.getLoginUser() {
						self.loginUserId = "\(loginUser.id ?? 0)"
					}
					self.messagingEnabled = true
					
					DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
						// mark messages to read to this channel
						if let link = self.channelUrl,
							let type = self.channelType, type != .openChannel {
                            self.controller.channelMessagesMarkAsRead(
                                completion: { channelUrl in
                                    self.delegate?.channelMessagesMarkedAsRead(channelUrl: link)
                                })
                        }
                        self.getChannelMessages()
                    }
                    
                })
        }
    }
    
    private func getChannelMessages() {
        // this is the initial messages
        self.controller.pullUp(
            completion: { messages in
                DebugInfo.log(info: "\(DebugInfoKey.messaging.rawValue) first \(messages.count) message(s)")
                                
                // remove header because you have all the messages
                if messages.count == 0 {
                    self.tblMessages.cr.removeHeader()
                    DebugInfo.log(info: "\(DebugInfoKey.messaging.rawValue) remove header refresh")
                }
                
				DispatchQueue.background(
					delay: 0.05,
					background: {
						self.messages = messages
					},
					completion: {
						DispatchQueue.main.async(
							execute: {
								self.tblMessages.reloadData()
								self.autoScrollMessages()
						})
						
						if !self.channelFrozen && !self.channelHasInactiveMember {
							DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
									self.txtvMessage.becomeFirstResponder()
									self.sendingMessageLock = false
							}
						}
					})
				
            })
    }
    
    private func sendMessage(message: String) {
		self.sendingMessageLock = true
		self.isEditingMessage = true
		
		let validatedMessage = self.getValidatedMessage(message: message)
		if let editableMessageIndex = self.editableMessageIndex {
			let messageData = self.messages[editableMessageIndex]
			// update only when there's a change in message value
			if validatedMessage == messageData.message {
				self.messages[editableMessageIndex].isEditable = false
				self.tblMessages.reloadData()
				self.isEditingMessage = false
				
				self.editableMessageIndex = nil
			}
			else {
				// after update user message request:
				// 1. called the completion handler for updateUserMessage
				// 2. called the delegate didUpdate for receiver
				self.controller.updateUserMessage(
					messageId: messageData.messageId,
					newMessage: validatedMessage,
					completion: { message in
						self.updatedMessageId = message.messageId
						DebugInfo.log(info: "\(DebugInfoKey.messaging.rawValue) you updated user-message-id (\(message.messageId)) at index (\(editableMessageIndex))")
						
						DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
							self.messages[editableMessageIndex] = message
							self.tblMessages.reloadData()
							self.isEditingMessage = false
							
							self.editableMessageIndex = nil
						}
				})
			}
		}
		else {
			self.controller.sendMessage(
				message: validatedMessage,
				completion: { message in
					DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
						self.messages.append(message)
						self.tblMessages.reloadData()
						self.autoScrollMessages()
						self.isEditingMessage = false
						self.prepareForNextMessage()
					}
			})
		}
    }
							
	private func sendImage(image: UIImage) {
		
		self.isCurrentlyUploadingFiles = true
		self.messages.append(self.controller.emptyFileVM(userId: self.loginUserId))
		self.keyboardHeight = 0.0
		
		DispatchQueue.main.async {
			self.tblMessages.reloadData()
			self.autoScrollMessages()
			self.lockFileButtons()
			self.lockMessaging()
		}
		DispatchQueue.global(qos: .background).async {
			self.controller.sendImage(image: image) { message in
				DispatchQueue.main.async {
					self.isCurrentlyUploadingFiles = false
					if(self.messages.count > 0){
						self.messages[self.messages.count-1] = message
					}
					
					self.tblMessages.reloadData()
					self.autoScrollMessages()
					self.prepareForNextMessage()
					self.unlockFileButtons()
					self.unlockMessaging()
				}
			}
		}
		
	}
	
	private func sendVideo(videoData: NSData, lastPathComponent: String) {
		
		self.messages.append(self.controller.emptyFileVM(userId: self.loginUserId))
				self.isCurrentlyUploadingFiles = true
		self.keyboardHeight = 0.0
		
		DispatchQueue.main.async {
			self.tblMessages.reloadData()
			self.autoScrollMessages()
			self.lockFileButtons()
			self.lockMessaging()
		}
		
		DispatchQueue.global(qos: .background).async {
			self.controller.sendVideo(videoData: videoData, lastPathComponent: lastPathComponent) { message in
				DispatchQueue.main.async {
				self.isCurrentlyUploadingFiles = false
					if(self.messages.count > 0){
						self.messages[self.messages.count-1] = message
					}
					self.tblMessages.reloadData()
					self.autoScrollMessages()
					self.prepareForNextMessage()
					self.unlockFileButtons()
					self.unlockMessaging()
				}
			}
		}
	}
	
	private func sendDocument(documentData: NSData, lastPathComponent: String) {
		
		self.messages.append(self.controller.emptyFileVM(userId: self.loginUserId))
				self.isCurrentlyUploadingFiles = true
		self.keyboardHeight = 0.0
		
		DispatchQueue.main.async {
			self.tblMessages.reloadData()
			self.autoScrollMessages()
			self.lockFileButtons()
			self.lockMessaging()
		}
		
		DispatchQueue.global(qos: .background).async {
			self.controller.sendDocument(documentData: documentData, lastPathComponent: lastPathComponent) { message in
				DispatchQueue.main.async {
					self.isCurrentlyUploadingFiles = false
			
					if(self.messages.count > 0){
						self.messages[self.messages.count-1] = message
					}
					self.tblMessages.reloadData()
					self.autoScrollMessages()
					self.prepareForNextMessage()
					self.unlockFileButtons()
					self.unlockMessaging()
				}
			}
		}
		
	}
	
	private func lockMessaging() {
		self.txtvMessage.isEditable = false
		self.txtvMessage.isUserInteractionEnabled = false
		self.sendButtonEnabled = false
	}
	
	private func  unlockMessaging() {
		self.txtvMessage.isEditable = true
		self.txtvMessage.isUserInteractionEnabled = true
	}
	
	private func hideFileButtons() {
		self.documentWidthConstraint.constant = 0.0;
		self.cameraWidthConstraint.constant = 0.0;
		self.cameraToDocumentConstraint.constant = 0.0;
		self.documentToTextboxWidthConstraint.constant = 0.0;
	}
	
	private func unhideFileButtons() {
		self.documentWidthConstraint.constant = self.documentWidth;
		self.cameraWidthConstraint.constant = self.cameraWidth;
		self.cameraToDocumentConstraint.constant = self.cameraToDocumentWidth;
		self.documentToTextboxWidthConstraint.constant = self.cameraToDocumentWidth;
	}
	
	private func lockFileButtons() {
		self.cameraButtonEnabled = false
		self.documentButtonEnabled = false
		
	}
	
	private func unlockFileButtons() {
		self.cameraButtonEnabled = true
		self.documentButtonEnabled = true
	}
	    
    // MARK: - Public Methods
	
	public func leaveMessaging(
		leaveToChannel: Bool,
		animatedDismiss: Bool,
		completionHandler: @escaping (() -> Void)) {
        DebugInfo.log(info: "\(DebugInfoKey.messaging.rawValue) leave messaging")
        
        self.txtvMessage.resignFirstResponder()
        
        // lock user interactions
        self.sendingMessageLock = true
        self.getPreviousMessagesLock = true
        self.messagingEnabled = false
        
        // with leaving to channel
		if leaveToChannel {
            self.delegate?.leavedConversation(channelUrl: self.channelUrl)
        }

        // mark messages to read to this group channel
        if let link = self.channelUrl, let type = self.channelType, type != .openChannel {
            self.controller.channelMessagesMarkAsRead(
                completion: { channelUrl in
                    self.delegate?.channelMessagesMarkedAsRead(channelUrl: link)
                    DebugInfo.log(info: "\(DebugInfoKey.messaging.rawValue) messages marked as read \(link)")
                })
        }

        // remove user chat message listener
        SBDMain.removeChannelDelegate(forIdentifier: self.DELEGATE_IDENTIFIER)
		
        // clean-up the data providers
        self.controller.leavedToMessaging()
        self.messages.removeAll()
        self.tblMessages.reloadData()
		
        NotificationCenter.default.removeObserver(self)
		
        self.dismiss(animated: animatedDismiss,
					 completion: {
            completionHandler()
        })
    }
	
	// MARK: - Private Methods
    
	private func addObservers() {
		// keyboard observers
		let notificationCenter = NotificationCenter.default
		notificationCenter.addObserver(
			self,
			selector: #selector(adjustForKeyboard(notification:)),
			name: UIResponder.keyboardWillShowNotification,
			object: nil)
		notificationCenter.addObserver(
			self,
			selector: #selector(adjustForKeyboard(notification:)),
			name: UIResponder.keyboardDidShowNotification,
			object: nil)
		notificationCenter.addObserver(
			self,
			selector: #selector(adjustForKeyboard(notification:)),
			name: UIResponder.keyboardWillHideNotification,
			object: nil)
		
		// network connection status observers
		notificationCenter.addObserver(
			self,
			selector: #selector(networkConnectionStatus(notification:)),
			name: .networkConnected,
			object: nil)
		notificationCenter.addObserver(
			self,
			selector: #selector(networkConnectionStatus(notification:)),
			name: .networkNoConnection,
			object: nil)
		
		// chat manager observers
		notificationCenter.addObserver(
			self,
			selector: #selector(chatManagerNotificationHandler(notification:)),
			name: .sendBirdError,
			object: nil)
		notificationCenter.addObserver(
			self,
			selector: #selector(chatManagerNotificationHandler(notification:)),
			name: .connectedUser,
			object: nil)
		notificationCenter.addObserver(
			self,
			selector: #selector(chatManagerNotificationHandler(notification:)),
			name: .disconnectedUser,
			object: nil)
	}
	
    private func initialize() {
        // register tableview cell
        self.tblMessages.register(UINib(nibName: "ChatMessageTableViewCell",
                                 bundle: Bundle.main),
                        forCellReuseIdentifier: String(describing: ChatMessageTableViewCell.self))
        self.tblMessages.register(UINib(nibName: "ChatOwnedMessageTableViewCell",
                                  bundle: Bundle.main),
                        forCellReuseIdentifier: String(describing: ChatOwnedMessageTableViewCell.self))
		self.tblMessages.register(UINib(nibName: "ChatOwnedFileMessageTableViewCell",
										bundle: Bundle.main),
								  forCellReuseIdentifier: String(describing: ChatOwnedFileMessageTableViewCell.self))
		self.tblMessages.register(UINib(nibName: "ChatOwnedOtherFileMessageTableViewCell",
			  bundle: Bundle.main),
		forCellReuseIdentifier: String(describing: ChatOwnedOtherFileMessageTableViewCell.self))
		
		self.tblMessages.register(UINib(nibName: "ChatOtherFileMessageTableViewCell",
			  bundle: Bundle.main),
		forCellReuseIdentifier: String(describing: ChatOtherFileMessageTableViewCell.self))
		
		self.tblMessages.register(UINib(nibName: "ChatFileMessageTableViewCell",
										bundle: Bundle.main),
								  forCellReuseIdentifier: String(describing: ChatFileMessageTableViewCell.self))
							
							
        self.tblMessages.rowHeight = UITableView.automaticDimension
        self.tblMessages.estimatedRowHeight = ChatMessageTableViewCell.HEIGHT
        self.tblMessages.allowsMultipleSelection = false
        
        if self.channelFrozen {
            // entire view footer off the screen below
            let extraOffset: CGFloat = CGFloat(10.0)
            self.viewFooterBottomConstraint.constant = (self.footerBarHeight + extraOffset) * -1
            
            // disable user interaction
			DispatchQueue.main.async {
				self.viewFooterBg.isUserInteractionEnabled = false
				self.lockFileButtons()
				self.hideFileButtons()
			}
			
            // remove keyboard listeners
            NotificationCenter.default.removeObserver(
                self,
                name: UIResponder.keyboardWillShowNotification,
                object: nil)
            NotificationCenter.default.removeObserver(
                self,
                name: UIResponder.keyboardWillHideNotification,
                object: nil)
        }
        else {
			DispatchQueue.main.async {
				self.prepareForNextMessage()
			}
        }
    }
    
    private func getPreviousMessages() {
        self.controller.getPreviousMessages { messages in
            DebugInfo.log(info: "\(DebugInfoKey.messaging.rawValue) more \(messages.count) previous message(s)")
           
            if messages.count == 0 {
                self.getPreviousMessagesLock = true
                self.tblMessages.reloadData()
                return
            }
            
			// we filtered the new messages in the case user send messages from empty message list
			// and first trigger of load previous messages
			let messageIds = self.messages.map({ $0.messageId })
			let filteredNewMessages = messages.filter { message in
				return !messageIds.contains(message.messageId)
			}
			if filteredNewMessages.count == 0 {
				return
			}
			
            DispatchQueue.background(
				delay: 0.05,
				background: {
					if self.messages.count > 1 {
						self.messages.insert(contentsOf: filteredNewMessages, at: 0)
					}
				},
				completion: {
					if self.messages.count > 1 {
						self.tblMessages.reloadData()
						let indexPath = IndexPath(row: filteredNewMessages.count, section: 0)
						self.tblMessages.scrollToRow(at: indexPath, at: .top, animated: false)
					}
				})
        }
    }
    
    private func updateMessageGroupings() {
        // show/hide user photo and message details
        var groupedUserId: String = ""
        
        for (index, element) in self.messages.enumerated() {
            let createdDate: Date = element.messageCreated.toDate()
            var previousCreatedDate: Date?
            if index > 1 {
                let previousElement = self.messages[index - 1]
                previousCreatedDate = previousElement.messageCreated.toDate()
            }
            
            let userId = element.userId
            if userId != groupedUserId {
                groupedUserId = userId
                element.isShowDetails = true
            }
            else {
                var showDetails = false
                if index > 1 {
                    let calendar = Calendar.current
                    let dateComponents1 = calendar.dateComponents([.year, .month, .day], from: createdDate)
                    let dateComponents2 = calendar.dateComponents([.year, .month, .day], from: previousCreatedDate ?? Date())
                    
                    if dateComponents1.year != dateComponents2.year || dateComponents1.month != dateComponents2.month || dateComponents1.day != dateComponents2.day {
                        showDetails = true
                    }
                    else {
                        showDetails = false
                    }
                }
                element.isShowDetails = showDetails
            }
            
        }
    }
    
    private func prepareForNextMessage() {
        // prepare ui for next send of message
        self.sendingMessageLock = false
        
        self.txtvMessage.text = "send_a_message".localized()
        self.txtvMessage.textColor = SEND_MESSAGE_PLACEHOLDER_TEXTCOLOR
    
        // cursor position
        let beginPosition = self.txtvMessage.beginningOfDocument
        self.txtvMessage.selectedTextRange = self.txtvMessage.textRange(from: beginPosition,
                                                                        to: beginPosition)
        
        self.autoResizeHeightSendMessage()
		self.sendButtonEnabled = false
    }
    
	private func prepareForEditMessage(message: String) {
		// prepare ui for editing of message
		self.sendingMessageLock = false
		
		
		self.txtvMessage.text = message
		self.txtvMessage.textColor = SEND_MESSAGE_TEXTCOLOR

		
		// cursor position
		let endPosition = self.txtvMessage.endOfDocument
		self.txtvMessage.selectedTextRange = self.txtvMessage.textRange(from: endPosition,
																		to: endPosition)
		
		self.autoResizeHeightSendMessage()
		self.sendButtonEnabled = true
	}
	
    private func autoResizeHeightSendMessage() {
        guard !self.channelFrozen else { return }
        
        let sizeToFitIn = CGSize(width: self.txtvMessage.bounds.size.width,
								 height: CGFloat(MAXFLOAT))
        let newSize = self.txtvMessage.sizeThatFits(sizeToFitIn)
        if newSize.height <= SEND_MESSAGE_MAX_HEIGHT {
            self.messageHeightConstraint.constant = newSize.height
            self.txtvMessage.isScrollEnabled = false
        }
        else {
			self.messageHeightConstraint.constant = SEND_MESSAGE_MAX_HEIGHT
            self.txtvMessage.isScrollEnabled = true
        }
    }
    
	private func autoScrollMessages(allowScrolling: Bool = true) {
        self.drawViewableMessagesRect(isHidden: true)
        
        let topOffset = self.keyboardHeight
        
        var bottomOffset: CGFloat = 5.0
        if self.channelFrozen {
            bottomOffset = bottomOffset + self.footerBarHeight
        }
        
        self.tblMessages.contentInset = UIEdgeInsets(
                                            top: topOffset,
                                            left: 0,
                                            bottom: bottomOffset,
                                            right: 0)

        guard self.messages.count > 1 else { return }
		guard allowScrolling else { return }
		
        // check if all cells is visible
        let topCellRect = self.tblMessages.rectForRow(
            at: IndexPath(row: 0, section: 0)
        )
        let bottomCellRect = self.tblMessages.rectForRow(
            at: IndexPath(row: self.messages.count - 1, section: 0)
        )
   
        if let superview = self.tblMessages.superview {
            let convertedRectTop = self.tblMessages.convert(topCellRect, to:superview)
            let convertedRectBottom = self.tblMessages.convert(bottomCellRect, to:superview)
           
            let intersectTop = self.viewableMessagesView.frame.contains(convertedRectTop)
            let intersectBottom = self.viewableMessagesView.frame.contains(convertedRectBottom)
           
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
               if intersectTop && intersectBottom {
                    self.tblMessages.scrollToFirstRow(animated: false)
               }
               else {
                    self.tblMessages.scrollToLastRow(datasource: self.messages)
               }
            }
        
        }
               
    }
    
    private func openSafari(url: URL) {
        if UIApplication.shared.canOpenURL(url) {
            let safariVC = SFSafariViewController(url: url)
            self.present(safariVC, animated: true, completion: {
                
            })
        }
    }
    
    private func alertForNoInternetConnection(errorDetails: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            PopUpManager.popCustomMsg(message: errorDetails,
                                      showVC: self,
                                      proceed: {})
        }
    }
    
    private func drawViewableMessagesRect(isHidden:Bool = false) {
        self.viewableMessagesView.removeFromSuperview()
        
        let topOffset = CGFloat(10.0)
        let limitHeight = self.view.frame.size.height - self.view.safeAreaInsets.bottom - self.keyboardHeight - self.viewFooterBg.frame.size.height
        let view = UIView(frame: CGRect(x: self.view.safeAreaInsets.left,
                                        y: self.keyboardHeight - topOffset,
                                        width: self.view.frame.size.width,
                                        height: limitHeight + topOffset))
        view.backgroundColor = UIColor(hex: "FF0000", alpha: 0.5)
        view.isUserInteractionEnabled = false
        view.isHidden = isHidden
        
        self.viewableMessagesView = view
        self.view.addSubview(self.viewableMessagesView)
    }
    
	private func getValidatedMessage(message: String) -> String {
		return message.trimmingCharacters(in: .whitespacesAndNewlines)
	}
	
	// MARK: - Handlers
	
	@objc func messageLongPressHandler(_ longPressGestureRecognizer: UILongPressGestureRecognizer) {
		if longPressGestureRecognizer.state == UIGestureRecognizer.State.began {
			self.isEditingMessage = true
			let touchPoint = longPressGestureRecognizer.location(in: self.tblMessages)
			if let indexPath = self.tblMessages.indexPathForRow(at: touchPoint) {
				let data = self.messages[indexPath.row]
				DebugInfo.log(info: "\(DebugInfoKey.messaging.rawValue) edit/remove user-message-id (\(data.messageId)) at index (\(indexPath.row))")
				
				// edit/remove only owned messages
				if let isFile = data.isFile, isFile == false,
					self.channelFrozen == false,
					data.userId == self.loginUserId {
					
					// no existing editable cell
					// select new non-editable cell
					if let editableCellData = data.isEditable, editableCellData == true {
						data.isEditable = false
						self.tblMessages.reloadCellatIdxPath(idxPath: indexPath)
						self.editableMessageIndex = nil
						return
					}
					
					// has existing editable cell
					// select new non-editable cell
					if let editableCellData = data.isEditable, editableCellData == false,
						let editableMessageIndex = self.editableMessageIndex {
						// reset the existing editable cell
						let existingEditableCellData = self.messages[editableMessageIndex]
						existingEditableCellData.isEditable = false
						self.tblMessages.reloadData()
						self.editableMessageIndex = nil
						return
					}
					
					PopUpManager.showMessageOperationsMenu(
						viewController: self,
						previouslySelected: nil,
						confirm: { (type, name) in
							if type == .edit {
								self.editableMessageIndex = indexPath.row
								
								data.isEditable = true
								self.tblMessages.reloadCellatIdxPath(idxPath: indexPath)
							}
							else if type == .remove {
								PopUpManager.popInfo(
									message: "confirm_remove_message".localized(),
									showVC: self,
									okay: {
										DebugInfo.log(info: "\(DebugInfoKey.messaging.rawValue) deleting user-message-id (\(data.messageId)) at index (\(indexPath.row))...")
										
										// after delete user message request:
										// 1. called the delegate messageWasDeleted for receiver
										// 2. called the completion handler for deleteUserMessage
										self.controller.deleteUserMessage(
											messageId: data.messageId,
											completion: { messageId in
												let deletedMessages = self.messages.filter({ $0.messageId == data.messageId })
												if deletedMessages.count == 0 {
													DebugInfo.log(info: "\(DebugInfoKey.messaging.rawValue) successfully removed user-message-id (\(messageId)) at index (\(indexPath.row))")
												}
												else {
													DebugInfo.log(info: "\(DebugInfoKey.messaging.rawValue) failed to remove user-message-id (\(messageId)) at index (\(indexPath.row))")
												}
										})
									},
									cancel: {
										()
								})
							}
					})
				}
			}
		}
	}
	
	// MARK: - Navigation
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let vc = segue.destination as? ChatGroupInformationViewController,
			segue.identifier == ChatScreen.messagingGroupInformation.segueIdentifier {
			vc.showNextNavigationBar = false
			vc.groupName = self.title
			vc.coverUrl = self.channelCoverUrl
			vc.channelType = self.channelType
			vc.hasMoreParticipants = self.hasMoreParticipants
			vc.members = self.members
        }
		
		if let vc = segue.destination as? TITURLWebviewController,
			segue.identifier == ChatScreen.webView.segueIdentifier {
			vc.urlMain = self.selectedUrl
			vc.title = "Filename"
			self.selectedUrl = ""
		}
    }
	
    // MARK: - Observers
    
    @objc func adjustForKeyboard (notification: NSNotification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillShowNotification {
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
				self.keyboardHeight = keyboardViewEndFrame.height
				self.autoScrollMessages(allowScrolling: false)
			}
        }
		else if notification.name == UIResponder.keyboardWillHideNotification {
            self.keyboardHeight = 0.0
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
				self.autoScrollMessages(allowScrolling: false)
			}
        }
		else if notification.name == UIResponder.keyboardDidShowNotification {
			if let customNavigationBar = self.customNavigationBar {
				customNavigationBar.btnNext.isEnabled = true
			}
		}
    }
    
    @objc func chatManagerNotificationHandler(notification: NSNotification) {
        if notification.name == .sendBirdError {
			
            if !self.messagingEnabled {
                self.messagingEnabled = true
            }
			if self.sendingMessageLock {
				self.sendingMessageLock = false
			}
			if (self.isCurrentlyUploadingFiles) {
				self.isCurrentlyUploadingFiles = false
				if(self.messages.count > 0) {
					self.messages.removeLast()
					self.unlockFileButtons()
					self.tblMessages.reloadData()
		
				}
			}
			
			let error = notification.object as! SBDError
			if(error.code == ChatManager.SendBirdError.deactivatedUser.rawValue) {
				self.showDeactivatedUserError()
			}
        }
        else if notification.name == .connectedUser {
            SBDMain.add(self, identifier: self.DELEGATE_IDENTIFIER)
            self.connectToChannel()
        }
        else if notification.name == .disconnectedUser {
            SBDMain.removeChannelDelegate(forIdentifier: self.DELEGATE_IDENTIFIER)
        }
    }
	
	func showDeactivatedUserError() {
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
			
			PopUpManager.popCustomMsgWithDisabledGesture(message: "deactivated_user_message".localized(),
									  showVC: self,
									  proceed: {
										if let channelType = self.channelType,
										   channelType == .openChannel {
											self.controller.leaveConversation(completion: {
												self.leaveMessaging(leaveToChannel: false,
																	animatedDismiss: true,
																	completionHandler: {
													()
												})
											})
										}
										else {
											self.leaveMessaging(leaveToChannel: false,
																animatedDismiss: true,
																completionHandler: {
												()
											})
										}
			})
		}
	}
	
	

    @objc func networkConnectionStatus(notification: NSNotification) {
        if notification.name == .networkConnected {
            if !self.messagingEnabled {
                self.messagingEnabled = true
            }
        }
        else if notification.name == .networkNoConnection {
            if self.messagingEnabled {
                self.messagingEnabled = false
            }
        }
    }
    
    // MARK: - UITextViewDelegate
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            self.txtvMessage.text = "send_a_message".localized()
            self.txtvMessage.textColor = SEND_MESSAGE_PLACEHOLDER_TEXTCOLOR
            
            // cursor position
            let beginPosition = textView.beginningOfDocument
            textView.selectedTextRange = textView.textRange(from: beginPosition,
                                                            to: beginPosition)
        }
    }
	
    func textView(_ textView: UITextView,
                  shouldChangeTextIn range: NSRange,
                  replacementText text: String) -> Bool {
		
        // detect for return key
        if text == "\n" {
            if textView.text == "send_a_message".localized() {
                return false
            }
			else if textView.text.count > 0 {
				if self.getValidatedMessage(message: textView.text).count == 0 {
					return false
				}
                if !self.sendingMessageLock {
                    self.sendMessage(message: textView.text)
                    return false
                }
				
            }
        }
        // detect for backspace
        else if text == "" {
            if textView.text.count <= 1 || textView.text == "send_a_message".localized() {
                self.txtvMessage.text = "send_a_message".localized()
                self.txtvMessage.textColor = SEND_MESSAGE_PLACEHOLDER_TEXTCOLOR
                
                // cursor position
                let beginPosition = textView.beginningOfDocument
                textView.selectedTextRange = textView.textRange(from: beginPosition,
                                                                to: beginPosition)
                
				self.sendButtonEnabled = false
            }
        }
        // valid key inputs
        else {
            if textView.text == "send_a_message".localized() {
                textView.text = ""
                textView.textColor = SEND_MESSAGE_TEXTCOLOR
            }
        }

		if let message = textView.text,
		   message != "send_a_message".localized(),
		   let textRange = Range(range, in: textView.text) {
			let updatedText = message.replacingCharacters(in: textRange, with: text)
			let validatedMessage = self.getValidatedMessage(message: updatedText)
			
			self.sendButtonEnabled = validatedMessage.count > 0 && validatedMessage != "send_a_message".localized()
			textView.textColor = self.sendButtonEnabled ? SEND_MESSAGE_TEXTCOLOR : SEND_MESSAGE_PLACEHOLDER_TEXTCOLOR
		}
		
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.autoResizeHeightSendMessage()
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = self.messages[indexPath.row]
        
		// owned messages
        if data.userId == self.loginUserId {
			// owned file message
			if let isFile = data.isFile, isFile == true {
				if(data.fileType == Constants.sendBirdVideoType || data.fileType == Constants.sendBirdDocumentType) {
					let cell = tableView.dequeueReusableCell(
						withIdentifier: String(describing: ChatOwnedOtherFileMessageTableViewCell.self),
						for: indexPath) as! ChatOwnedOtherFileMessageTableViewCell
					cell.selectionStyle = .none
					cell.delegate = self
					cell.openSafari = { url in
						self.controller.checkConnection { (disconnected, error) in
							if disconnected {
								self.alertForNoInternetConnection(errorDetails: error)
							}
							else {
								self.openSafari(url: url)
							}
						}
					}
					cell.setNeedsLayout()
					cell.layoutIfNeeded()
					cell.configureView(vm: data, showMessageGrouping: data.isShowDetails)
					return cell
				}
				else {
					let cell = tableView.dequeueReusableCell(
						withIdentifier: String(describing: ChatOwnedFileMessageTableViewCell.self),
						for: indexPath) as! ChatOwnedFileMessageTableViewCell
					cell.selectionStyle = .none
					cell.openSafari = { url in
						self.controller.checkConnection { (disconnected, error) in
							if disconnected {
								self.alertForNoInternetConnection(errorDetails: error)
							}
							else {
								self.openSafari(url: url)
							}
						}
					}
					cell.imgFile.image = nil
					cell.configureView(vm: data, showMessageGrouping: data.isShowDetails)
					return cell
				}
			}
			// owned user message
			else {
				let cell = tableView.dequeueReusableCell(
					withIdentifier: String(describing: ChatOwnedMessageTableViewCell.self),
					for: indexPath) as! ChatOwnedMessageTableViewCell
				
				cell.selectionStyle = .none
				cell.openSafari = { url in
					self.controller.checkConnection { (disconnected, error) in
						if disconnected {
							self.alertForNoInternetConnection(errorDetails: error)
						}
						else {
							self.openSafari(url: url)
						}
					}
				}
				cell.configureView(vm: data, showMessageGrouping: data.isShowDetails)
				return cell
			}
        }
		// recipient messages
        else {
			// recipient file message
            if let isFile = data.isFile, isFile == true {
				if(data.fileType == Constants.sendBirdVideoType || data.fileType == Constants.sendBirdDocumentType) {
					let cell = tableView.dequeueReusableCell(
						withIdentifier: String(describing: ChatOtherFileMessageTableViewCell.self),
						for: indexPath) as! ChatOtherFileMessageTableViewCell
					cell.selectionStyle = .none
					cell.delegate = self
					cell.openSafari = { url in
						self.controller.checkConnection { (disconnected, error) in
							if disconnected {
								self.alertForNoInternetConnection(errorDetails: error)
							}
							else {
								self.openSafari(url: url)
							}
						}
					}
					cell.setNeedsLayout()
					cell.layoutIfNeeded()
					cell.configureView(vm: data, showMessageGrouping: data.isShowDetails)
					return cell
				}
				else {
					let cell = tableView.dequeueReusableCell(
						withIdentifier: String(describing: ChatFileMessageTableViewCell.self),
						for: indexPath) as! ChatFileMessageTableViewCell
					cell.selectionStyle = .none
					cell.openSafari = { url in
						self.controller.checkConnection { (disconnected, error) in
							if disconnected {
								self.alertForNoInternetConnection(errorDetails: error)
							}
							else {
								self.openSafari(url: url)
							}
						}
					}
					cell.configureView(vm: data, showMessageGrouping: data.isShowDetails)
					return cell
				}
			}
			// recipient user message
			else {
				let cell = tableView.dequeueReusableCell(
					withIdentifier: String(describing: ChatMessageTableViewCell.self),
					for: indexPath) as! ChatMessageTableViewCell
				cell.selectionStyle = .none
				cell.openSafari = { url in
					self.controller.checkConnection { (disconnected, error) in
						if disconnected {
							self.alertForNoInternetConnection(errorDetails: error)
						}
						else {
							self.openSafari(url: url)
						}
					}
				}
				cell.configureView(vm: data, showMessageGrouping: data.isShowDetails)
				return cell
			}
        }
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let data = self.messages[indexPath.row]
		DebugInfo.log(info: "\(DebugInfoKey.messaging.rawValue) selected a message \(data.message) (\(data.messageId)) at index (\(indexPath.row))")
    }
    
    // MARK: - UIScrollViewDelegate
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.getPreviousMessagesLock = false
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.getPreviousMessagesLock = true
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard self.getPreviousMessagesLock == false else { return }
        
        var contentOffsetLimit: CGFloat = CGFloat(0.0)
        if self.keyboardHeight > 0.0 {
            contentOffsetLimit = CGFloat(self.keyboardHeight * -1)
        }
        
        if scrollView.contentOffset.y <= contentOffsetLimit {
            // pagination
            if !self.getPreviousMessagesLock {
                self.getPreviousMessagesLock = true
                self.getPreviousMessages()
            }
        }
    }
    
	func openDocumentWithFileManager(documentUrl: String) {
		self.view.endEditing(true)
		self.selectedUrl = documentUrl
		self.performSegue(withIdentifier: ChatScreen.webView.segueIdentifier,
		sender: nil)
	}

	//MARK:- WKNavigationDelegate

	func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation:
	WKNavigation!, withError error: Error) {
		DebugInfo.log(info: "\(DebugInfoKey.messaging.rawValue) webview error \(error.localizedDescription)")
	}
	func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation:
	WKNavigation!) {
		DebugInfo.log(info: "\(DebugInfoKey.messaging.rawValue) webview start to load")
	}
	func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
		DebugInfo.log(info: "\(DebugInfoKey.messaging.rawValue) webview finish to load")
	}
	
	// MARK: - ChatOwnedFileMessageTableViewCellDelegate and ChatFileMessageTableViewCellDelegate
	func openOwnDocument(documentUrl: String?) {
		guard let url = documentUrl else { return }
		self.openDocumentWithFileManager(documentUrl: url)
	}
	
	func openDocument(documentUrl: String?) {
		guard let url = documentUrl else { return }
		self.openDocumentWithFileManager(documentUrl: url)
	}
	
    // MARK: - SBDChannelDelegate
    
	func channel(_ sender: SBDBaseChannel, didUpdate message: SBDBaseMessage) {
		// process only from receiver updates/deletes
		guard message.messageId != self.updatedMessageId else {
			self.updatedMessageId = 0
			return
		}
		DebugInfo.log(info: "\(DebugInfoKey.messaging.rawValue) (ChannelDelegate) edited by other-user message-id (\(message.messageId))")
		
		let updatedMessages = self.messages.filter({ $0.messageId == message.messageId })
		if let messageData = updatedMessages.first {
			DebugInfo.log(info: "\(DebugInfoKey.messaging.rawValue) auto-update user-message-id (\(message.messageId))")
			
			messageData.message = message.message
			self.tblMessages.reloadData()
		}
	}
	
	func channel(_ sender: SBDBaseChannel, messageWasDeleted messageId: Int64) {
		DebugInfo.log(info: "\(DebugInfoKey.messaging.rawValue) (ChannelDelegate) removed by user message-id (\(messageId))")
				
		let deletedMessages = self.messages.filter({ $0.messageId == messageId })
		if let message = deletedMessages.first,
			let index = self.messages.index(of: message) {
			DebugInfo.log(info: "\(DebugInfoKey.messaging.rawValue) auto-delete user-message-id (\(messageId)) at index (\(index))")
			
			if index < self.messages.count {
				self.messages.remove(at: index)
				self.tblMessages.reloadData()
			}
		}
	}
	
    func channel(_ sender: SBDBaseChannel, didReceive message: SBDBaseMessage) {
		guard self.channelUrl != nil else { return }
		
		if let channelUrl = self.channelUrl,
		 channelUrl != message.channelUrl {
			return
		}
		
        if message is SBDUserMessage {
            let messageReceived = message
            
            let message = messageReceived.message
			let messageId = messageReceived.messageId
            let messageCreatedAt = messageReceived.createdAt
            
            var senderPhotoUrl: String?
            var senderName: String?
            var senderUserId: String?
            if let sender = messageReceived.sender {
                senderPhotoUrl = sender.profileUrl
                senderName = sender.nickname
                senderUserId = sender.userId
            }
            let viewModel = ChatMessageVM(
                userId: senderUserId ?? "",
                name: senderName ?? "",
                photoUrl: senderPhotoUrl ?? "",
                message: message,
				messageId: messageId,
                messageCreated: messageCreatedAt
            )
            self.messages.append(viewModel)
            DebugInfo.log(info: "\(DebugInfoKey.messaging.rawValue) (ChatMessagingVC) new user-message \(viewModel.message) from \(viewModel.name) (\(viewModel.userId))")
        }
        
        else if message is SBDAdminMessage {
            let messageReceived = message
            
            let message = messageReceived.message
			let messageId = messageReceived.messageId
            let messageCreatedAt = messageReceived.createdAt
            
            let viewModel = ChatMessageVM(
                userId: "",
                name: "",
                photoUrl: "",
                message: message,
				messageId: messageId,
                messageCreated: messageCreatedAt
            )
            // The admin message doesn’t have a sender
            self.messages.append(viewModel)
            DebugInfo.log(info: "\(DebugInfoKey.messaging.rawValue) (ChatMessagingVC) new admin-message \(viewModel.message)")
        }
        
        else if message is SBDFileMessage {
			guard let messageReceived = message as? SBDFileMessage else { return }
		   
			let messageId = messageReceived.messageId
			let messageCreatedAt = messageReceived.createdAt
			
			var senderPhotoUrl: String?
			var senderName: String?
			var senderUserId: String?
			if let sender = messageReceived.sender {
			   senderPhotoUrl = sender.profileUrl
			   senderName = sender.nickname
			   senderUserId = sender.userId
			}

			let viewModel = ChatMessageVM(
				userId: senderUserId ?? "",
				name: senderName ?? "",
				photoUrl: senderPhotoUrl ?? "",
				messageId: messageId,
				messageCreated: messageCreatedAt,
				isFile: true,
				fileName:messageReceived.name,
				fileUrl: messageReceived.url,
				fileType: messageReceived.type)

			self.messages.append(viewModel)
			DebugInfo.log(info: "\(DebugInfoKey.messaging.rawValue) (ChatMessagingVC) new user-message \(viewModel.message) from \(viewModel.name) (\(viewModel.userId))")
        }
		
		self.tblMessages.reloadData()
		// scroll only when not in editing mode
		if self.editableMessageIndex == nil {
			self.tblMessages.scrollToLastRow(datasource: self.messages)
		}
    }
			
	func openMediaFromSource(sourceType: UIImagePickerController.SourceType, cameraCaptureMode: UIImagePickerController.CameraCaptureMode){
		
		if(sourceType == .photoLibrary) {
			openPhotoGalleryWithPermissions(sourceType: sourceType, cameraCaptureMode: cameraCaptureMode)
		} else {
			if(cameraCaptureMode == .video) {
				openVideoCameraWithPermissions(sourceType: sourceType, cameraCaptureMode: cameraCaptureMode)
			} else {
				openPhotoCameraWithPermissions(sourceType: sourceType, cameraCaptureMode: cameraCaptureMode)
			}
		}
		
		
		
	}
	
	func openPhotoCameraWithPermissions(sourceType: UIImagePickerController.SourceType, cameraCaptureMode: UIImagePickerController.CameraCaptureMode) {

			self.checkCameraPermission { (cameraPermission) in
				if ( cameraPermission ) {
					
					if(UIImagePickerController .isSourceTypeAvailable(sourceType)){
						self.imagePicker.sourceType = sourceType
						self.imagePicker.mediaTypes = [kUTTypeMovie as String, kUTTypeImage as String]
						if (sourceType != .photoLibrary) {
							self.imagePicker.cameraCaptureMode = cameraCaptureMode
						}

						self.imagePicker.videoQuality = .typeHigh
						self.imagePicker.delegate = self
						self.present(self.imagePicker, animated: true, completion: nil)
					}
					else{
						let alert  = UIAlertController(title: "warning".localized(), message: "CAMERA_NOT_AVAIL".localized(), preferredStyle: .alert)
						alert.addAction(UIAlertAction(title: "ok".localized(), style: .default, handler: nil))
						self.present(alert, animated: true, completion: nil)
					}
					
					
				} else {
					let alert  = UIAlertController(title: "allow_camera_access".localized(), message: nil, preferredStyle: .alert)
					alert.addAction(UIAlertAction(title: "allow_access".localized(), style: .default, handler: { _ in
						self.gotoSettings();
					}))
					self.present(alert, animated: true, completion: nil)
					
				}
			}
						
		
				
			
	}
	
	func openVideoCameraWithPermissions(sourceType: UIImagePickerController.SourceType, cameraCaptureMode: UIImagePickerController.CameraCaptureMode) {
		
		self.checkCameraPermission { (cameraPermission) in
				if( cameraPermission ) {
					self.checkMicrophonePermission { (microphonePermission) in
						if ( microphonePermission ) {
							
							if(UIImagePickerController .isSourceTypeAvailable(sourceType)){
								self.imagePicker.sourceType = sourceType
								self.imagePicker.mediaTypes = [kUTTypeMovie as String, kUTTypeImage as String]
								if (sourceType != .photoLibrary) {
									self.imagePicker.cameraCaptureMode = cameraCaptureMode
								}

								self.imagePicker.videoQuality = .typeHigh
								self.imagePicker.delegate = self
								self.present(self.imagePicker, animated: true, completion: nil)
							}
							else{
								let alert  = UIAlertController(title: "warning".localized(), message: "CAMERA_NOT_AVAIL".localized(), preferredStyle: .alert)
								alert.addAction(UIAlertAction(title: "ok".localized(), style: .default, handler: nil))
								self.present(alert, animated: true, completion: nil)
							}
							
							
						} else {
							let alert  = UIAlertController(title: "allow_microphone_access".localized(), message: nil, preferredStyle: .alert)
							alert.addAction(UIAlertAction(title: "allow_access".localized(), style: .default, handler: { _ in
								self.gotoSettings();
							}))
							self.present(alert, animated: true, completion: nil)
						}
					}
						
		
				} else {
					let alert  = UIAlertController(title: "allow_camera_access".localized(), message: nil, preferredStyle: .alert)
					alert.addAction(UIAlertAction(title: "allow_access".localized(), style: .default, handler: { _ in
						self.gotoSettings();
					}))
					self.present(alert, animated: true, completion: nil)
				}
			}
	}
	
	func openPhotoGalleryWithPermissions(sourceType: UIImagePickerController.SourceType, cameraCaptureMode: UIImagePickerController.CameraCaptureMode) {
		

		self.checkPhotoGalleryPermission { ( photosPermission ) in
			if ( photosPermission ) {
				if(UIImagePickerController .isSourceTypeAvailable(sourceType)){
					let pickerController = DKImagePickerController()
					pickerController.assetType = .allAssets
				
					pickerController.showsCancelButton = true
					pickerController.allowMultipleTypes = false
					pickerController.maxSelectableCount = 1
					pickerController.didSelectAssets = { [unowned self] (assets: [DKAsset]) in
						for each in assets {
						switch each.type {
						case .video:
							//possibiliy add animation
							each.fetchAVAsset(options: .none, completeBlock: { video, info in
		
								if let videoUrl = video as? AVURLAsset {
									let compressedURL = NSURL.fileURL(withPath: NSTemporaryDirectory() + NSUUID().uuidString + ".mp4")
									self.compressVideo(
										inputURL: videoUrl.url,
										outputURL: compressedURL) { (exportSession) in

										 guard let session = exportSession else {
											 return
										 }

										 switch session.status {
											case .failed,
												 .unknown:
												
												DispatchQueue.main.async {
												let alert  = UIAlertController(title: "warning".localized(), message: "FAILED_VIDEO".localized(), preferredStyle: .alert)
												alert.addAction(UIAlertAction(title: "ok".localized(), style: .default, handler: nil))
												self.present(alert, animated: true, completion: nil)
												}
												
											case.waiting,
												.exporting,
												.cancelled:
													break
										
											case .completed:
												guard let compressedData = NSData(contentsOf: compressedURL) else {
													return
												}
												self.sendVideo(videoData: compressedData,
														   lastPathComponent: compressedURL.lastPathComponent)
											
										 }
									 }
								}
							})
						case .photo:
							each.fetchOriginalImage(completeBlock: { (image, nil) in
								guard let image = image else {
									return
								}
								if let newImage = image.resizeWith(percentage: Constants.imageScaleDownRatio) {
									guard self.sendingMessageLock == false else { return }
										self.sendImage(image: newImage)
								}
							})
						}
						}
						
						
					}
					self.present(pickerController, animated: true) {}
				}
				else{
					let alert  = UIAlertController(title: "warning".localized(), message: "CAMERA_NOT_AVAIL".localized(), preferredStyle: .alert)
					alert.addAction(UIAlertAction(title: "ok".localized(), style: .default, handler: nil))
					self.present(alert, animated: true, completion: nil)
				}
				
				
			} else {
				let alert  = UIAlertController(title: "allow_photo_access".localized(), message: nil, preferredStyle: .alert)
				alert.addAction(UIAlertAction(title: "allow_access".localized(), style: .default, handler: { _ in
					self.gotoSettings();
				}))
				self.present(alert, animated: true, completion: nil)
			}
		}
						
		
		
	}
	
	func checkCameraPermission(_ handler: @escaping (_ granted: Bool) -> Void) {
        func hasCameraPermission() -> Bool {
            #if swift(>=4.0)
            return AVCaptureDevice.authorizationStatus(for: .video) == .authorized
            #else
            return AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo) == .authorized
            #endif
        }
		
        
        func needsToRequestCameraPermission() -> Bool {
            #if swift(>=4.0)
            return AVCaptureDevice.authorizationStatus(for: .video) == .notDetermined
            #else
            return AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo) == .notDetermined
            #endif
        }
		
        
        #if swift(>=4.0)
        hasCameraPermission() ? handler(true) : (needsToRequestCameraPermission() ?
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { granted in
                DispatchQueue.main.async(execute: { () -> Void in
                    hasCameraPermission() ? handler(true) : handler(false)
                })
            }) : handler(false))
        #else
        hasCameraPermission() ? handler(true) : (needsToRequestCameraPermission() ?
            AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: { granted in
                DispatchQueue.main.async(execute: { () -> Void in
                    hasCameraPermission() ? handler(true) : handler(false)
                })
				
            }) : handler(false))
        #endif
    }
	
	
	func checkPhotoGalleryPermission(_ handler: @escaping (_ granted: Bool) -> Void) {
		
		func hasPhotoGalleryPermission() -> Bool {
            #if swift(>=4.0)
            return PHPhotoLibrary.authorizationStatus() == .authorized
            #else
            return PHPhotoLibrary.authorizationStatus() == .authorized
            #endif
        }
		
		func needsToRequestPhotoGalleryPermission() -> Bool {
			#if swift(>=4.0)
			return PHPhotoLibrary.authorizationStatus() == .notDetermined
			#else
			return PHPhotoLibrary.authorizationStatus() == .notDetermined
			#endif
		}
		 
		 #if swift(>=4.0)
		 hasPhotoGalleryPermission() ? handler(true) : (needsToRequestPhotoGalleryPermission() ?
			PHPhotoLibrary.requestAuthorization({ granted in
				 DispatchQueue.main.async(execute: { () -> Void in
					 hasPhotoGalleryPermission() ? handler(true) : handler(false)
				 })
			 }) : handler(false))
		 #else
		 hasMicrophonePersmission() ? handler(true) : (needsToRequestMicrophonePermission() ?
			 PHPhotoLibrary.requestAuthorization({ granted in
				 DispatchQueue.main.async(execute: { () -> Void in
					 hasMicrophonePersmission() ? handler(true) : handler(false)
				 })

			 }) : handler(false))
		 #endif
		

	}
	func checkMicrophonePermission(_ handler: @escaping (_ granted: Bool) -> Void) {
	
		// Returned true for all to still be able to use even if it's not allowed.
		
		func hasMicrophonePersmission() -> Bool {
            #if swift(>=4.0)
            return AVCaptureDevice.authorizationStatus(for: .audio) == .authorized
            #else
            return AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeAudio) == .authorized
            #endif
        }
        
		
		func needsToRequestMicrophonePermission() -> Bool {
		   #if swift(>=4.0)
		   return AVCaptureDevice.authorizationStatus(for: .audio) == .notDetermined
		   #else
		   return AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeAudio) == .notDetermined
		   #endif
	   }
        
        #if swift(>=4.0)
        hasMicrophonePersmission() ? handler(true) : (needsToRequestMicrophonePermission() ?
            AVCaptureDevice.requestAccess(for: .audio, completionHandler: { granted in
                DispatchQueue.main.async(execute: { () -> Void in
                    hasMicrophonePersmission() ? handler(true) : handler(true)
                })
            }) : handler(true))
        #else
        hasMicrophonePersmission() ? handler(true) : (needsToRequestMicrophonePermission() ?
            AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeAudio, completionHandler: { granted in
                DispatchQueue.main.async(execute: { () -> Void in
                    hasMicrophonePersmission() ? handler(true) : handler(true)
                })
				
            }) : handler(true))
        #endif
    }
	
	
	func chooseMedia() {
		let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "take_photo".localized(), style: .default, handler: { _ in
			self.openMediaFromSource(sourceType: .camera, cameraCaptureMode: .photo)
		}))
		alert.addAction(UIAlertAction(title: "MENU_RECORD_VIDEO".localized(), style: .default, handler: { _ in
			self.openMediaFromSource(sourceType: .camera, cameraCaptureMode: .video)
		}))
		alert.addAction(UIAlertAction.init(title: "cancel".localized(), style: .cancel, handler: nil))
		self.present(alert, animated: true, completion: nil)
	}
	
	func gotoSettings() {
		if let appSettings = URL(string: UIApplication.openSettingsURLString) {
			if #available(iOS 10.0, *) {
				UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
			} else {
				UIApplication.shared.openURL(appSettings)
			}
		}
	}


}


