//
//  ChatMessagingController.swift
//  DailyTraining
//
//  Created by William Reña on 7/17/20.
//  Copyright © 2020 Andrew Daugdaug. All rights reserved.
//

import UIKit

class ChatMessagingController: BaseController {
	private var messages = [ChatMessageVM]()
	
	func pullDown(completion: @escaping (([ChatMessageVM])->Void)) {
		self.getMessages(
			completion: { [unowned self] messages in
				self.messages.insert(contentsOf: messages, at: 0)
				completion(messages)
			},
			nextPageMode: true
		)
	}
	
	func pullUp(completion: @escaping (([ChatMessageVM])->Void)) {
		self.getMessages(
			completion: { [unowned self] (messages) in
				self.messages.removeAll()
				self.messages.append(contentsOf: messages)
				completion(self.messages)
			},
			nextPageMode: false)
	}
	
	func getPreviousMessages(completion: @escaping (([ChatMessageVM])->Void)) {
		self.getMessages(
			completion: { [unowned self] messages in
				self.messages.insert(contentsOf: messages, at: 0)
				completion(messages)
			},
			nextPageMode: true
		)
	}
	
	func getLoginUser() -> User? {
		return self.userManager.getLoginUser()
	}
	
    func leavedToMessaging() {
        self.messages.removeAll()
        ChatManager.leavedToMessaging()
    }
    
    func enterToOpenChannel(
        channelUrl: String,
        completion: @escaping ((Bool, [ChatPeopleVM])->Void)) {
            guard let _ = userManager.getLoginUser() else { return }
		
			var membersVM = [ChatPeopleVM]()
            ChatManager.enterToOpenChannel(
                channelUrl: channelUrl,
                completion: { (hasNext, participants) in
					participants.forEach { memberModel in
						membersVM.append(
							ChatPeopleVM(userId:memberModel.userId ?? "",
										 name: memberModel.name ?? "",
										 photoUrl: memberModel.photoUrl ?? "",
										 position: memberModel.position ?? "",
										 status: memberModel.connectionStatus ?? false))
					}
					completion(hasNext, membersVM)
                })
    }
    
    func enterToGroupChannel(
        channelUrl: String,
        completion: @escaping (([ChatPeopleVM])->Void)) {
            guard let _ = userManager.getLoginUser() else { return }
		
			var membersVM = [ChatPeopleVM]()
            ChatManager.enterToGroupChannel(
                channelUrl: channelUrl,
                completion: { members in
					members.forEach { memberModel in
						membersVM.append(
							ChatPeopleVM(userId:memberModel.userId ?? "",
										 name: memberModel.name ?? "",
										 photoUrl: memberModel.photoUrl ?? "",
										 position: memberModel.position ?? "",
										 status: memberModel.connectionStatus ?? false))
					}
					completion(membersVM)
                })
    }
    
    func leaveConversation(
        completion: @escaping (()->Void)) {
        ChatManager.leaveConversation(
            completion: {
                completion()
            })
    }
    
    func getMessages(
        completion: @escaping (([ChatMessageVM])->Void),
        nextPageMode: Bool = false) {
            var messagesVM = [ChatMessageVM]()
            ChatManager.getMessages(
                completion: { messages in
                    messages.forEach { messageModel in
                        messagesVM.append(
                            ChatMessageVM(
                                userId: messageModel.senderUserId ?? "",
                                name: messageModel.senderName ?? "",
                                photoUrl: messageModel.photoUrl ?? "",
                                message: messageModel.message,
								messageId: messageModel.messageId,
                                messageCreated: messageModel.createdAt,
								isFile: messageModel.isFile,
								fileName: messageModel.fileName ?? "",
								fileUrl: messageModel.fileUrl ?? "",
								fileType: messageModel.fileType ?? "")
                            )
                    }
                    completion(messagesVM)
                },
                nextPageMode: nextPageMode)
    }
    
    func sendMessage(
        message: String,
        completion: @escaping ((ChatMessageVM)->Void)) {
            ChatManager.sendUserMessage(
                message: message,
                completion: { messageModel in
                    let vm = ChatMessageVM(
                        userId: messageModel.senderUserId ?? "",
                        name: messageModel.senderName ?? "",
                        photoUrl: messageModel.photoUrl ?? "",
                        message: messageModel.message,
						messageId: messageModel.messageId,
                        messageCreated: messageModel.createdAt)
                    self.messages.append(vm)
                    completion(vm)
                })
    }
	

	
	func emptyFileVM(userId: String) -> ChatMessageVM {
		return ChatMessageVM(
			userId: userId,
			name: "",
			photoUrl: "",
			message: "",
			messageCreated: 0,
			isFile: true, //!import as this will add the temporaray file cell when doing an upload
			fileName: "",
			fileUrl: "",
			fileType: "")
	}
	
	func sendImage(
		image: UIImage,
		completion: @escaping ((ChatMessageVM)->Void)) {
		ChatManager.sendUserImage(
			image: image,
			completion: { messageModel in
				let vm = ChatMessageVM(
					userId: messageModel.senderUserId ?? "",
					name: messageModel.senderName ?? "",
					photoUrl: messageModel.photoUrl ?? "",
					message: messageModel.message,
					messageCreated: messageModel.createdAt,
					isFile: messageModel.isFile,
					fileUrl: messageModel.fileUrl ?? "",
					fileType: messageModel.fileType ?? "")
				self.messages.append(vm)
				completion(vm)
		})
	}
	
	func sendVideo(
		videoData: NSData,
		lastPathComponent: String,
		completion: @escaping ((ChatMessageVM)->Void)) {
		ChatManager.sendUserVideo(
			videoData: videoData,
			lastPathComponent: lastPathComponent,
			completion: { messageModel in
				let vm = ChatMessageVM(
					userId: messageModel.senderUserId ?? "",
					name: messageModel.senderName ?? "",
					photoUrl: messageModel.photoUrl ?? "",
					message: messageModel.message,
					messageCreated: messageModel.createdAt,
					isFile: messageModel.isFile,
					fileName: messageModel.fileName ?? "",
					fileUrl: messageModel.fileUrl ?? "",
					fileType: messageModel.fileType ?? "")
				self.messages.append(vm)
				completion(vm)
		})
	}
	
	func sendDocument(
		documentData: NSData,
		lastPathComponent: String,
		completion: @escaping ((ChatMessageVM)->Void)) {
		ChatManager.sendUserDocument(
			documentData: documentData,
			lastPathComponent: lastPathComponent,
			completion: { messageModel in
				let vm = ChatMessageVM(
					userId: messageModel.senderUserId ?? "",
					name: messageModel.senderName ?? "",
					photoUrl: messageModel.photoUrl ?? "",
					message: messageModel.message,
					messageCreated: messageModel.createdAt,
					isFile: messageModel.isFile,
					fileName: messageModel.fileName ?? "",
					fileUrl: messageModel.fileUrl ?? "",
					fileType: messageModel.fileType ?? "")
				self.messages.append(vm)
				completion(vm)
		})
	}
    
    func channelMessagesMarkAsRead(
        completion: @escaping ((String)->Void)) {
            ChatManager.channelMessagesMarkAsRead(
                completion: { channelUrl in
                    completion(channelUrl)
                })
    }
	
	func updateUserMessage(
		messageId: Int64,
		newMessage: String,
        completion: @escaping ((ChatMessageVM)->Void)) {
            ChatManager.updateUserMessage(
				messageId: messageId,
				newMessage: newMessage,
                completion: { messageModel in
					let vm = ChatMessageVM(
						userId: messageModel.senderUserId ?? "",
						name: messageModel.senderName ?? "",
						photoUrl: messageModel.photoUrl ?? "",
						message: messageModel.message,
						messageId: messageModel.messageId,
						messageCreated: messageModel.createdAt)
                    completion(vm)
                })
    }
	
	func deleteUserMessage(
		messageId: Int64,
        completion: @escaping ((Int64)->Void)) {
            ChatManager.deleteUserMessage(
				messageId: messageId,
                completion: { deletedMessageId in
                    completion(deletedMessageId)
                })
    }
}
