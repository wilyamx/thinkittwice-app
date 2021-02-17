 //
//  ChatManager.swift
//  DailyTraining
//
//  Created by John Andrew Daugdaug on 6/23/20.
//  Copyright © 2020 Andrew Daugdaug. All rights reserved.
//
import UIKit
import SendBirdSDK

class ChatManager: NSObject {
    private let appId: String
	private var pendingDeviceToken: Data?
	
    public static let PAGE_LIMIT: UInt = 15
    public static let USER_METADATA_KEY: String = "user_group_id"
	public static let USER_POSITION_METADATA_KEY: String = "user_position"
    public static let ADMIN_MESSAGE_BG_COLOR: UIColor = .blue
    public static let LINK_COLOR: UIColor = UIColor(hex: "007AFF") ?? .cyan
    public static let CHANNEL_COVER_PHOTO_URL_PREFIX = "https://static.sendbird.com/sample/cover/"
    
    public static let notificationCenter: NotificationCenter = .default
    public static var alertContainerVC: UIViewController?
    
    static private var userListQuery: SBDApplicationUserListQuery?
    static private var openChannelListQuery: SBDOpenChannelListQuery?
    static private var groupChannelListQuery: SBDGroupChannelListQuery?
	static private var participantListQuery: SBDParticipantListQuery?

    // changeable
    static private var messageListQuery: SBDPreviousMessageListQuery?
    static private var enteredOpenChannel: SBDOpenChannel?
    static private var enteredGroupChannel: SBDGroupChannel?
    
    // connected current user details
    public static var userId: String?
    public static var nickname: String?
    
    init(appId: String) {
        self.appId = appId
		self.pendingDeviceToken = nil

        SBDMain.initWithApplicationId(self.appId)
        DebugInfo.log(info: "\(DebugInfoKey.messaging.rawValue) sendbird app-id \(self.appId)")
		DebugInfo.log(info: "\(DebugInfoKey.messaging.rawValue) SBDMain app-id \(SBDMain.getApplicationId() ?? "")")
    }
    
	// MARK: - User Connect
	
    func initBasedOnActiveTheme() {
        // initialize chat based on theme appcode
        if let themeAppCode = Shortcut.appDelegate.themeManager?.activeTheme.appCode {
           let appCode = AppCode.strAppCodeToAppCode(appCode: themeAppCode)
           let sendBirdAppId = ChatManager.getAppId(appCode: appCode)
            DebugInfo.log(info: "\(DebugInfoKey.messaging.rawValue) sendbird app-id \(self.appId) from active theme appCode \(appCode)")
            Shortcut.appDelegate.chatManager = ChatManager(appId: sendBirdAppId)
        }
    }
    
    func logoutUser(
		unregisterPush: Bool,
		completion: @escaping (()->Void)) {
		NSLog("\(DebugInfoKey.messaging.rawValue) disconnecting current-user \(ChatManager.nickname ?? "?") (\(ChatManager.userId ?? "?")) to chat...")
        
		if unregisterPush {
			self.unregisterPush()
		}
        
        ChatManager.disconnectUserFromChat(completion: {
            // clear data
            ChatManager.userId = nil
            ChatManager.nickname = nil
            
            ChatManager.messageListQuery = nil
            ChatManager.enteredOpenChannel = nil
            ChatManager.enteredGroupChannel = nil
            
            ChatManager.userListQuery = nil
            ChatManager.openChannelListQuery = nil
            ChatManager.groupChannelListQuery = nil
			ChatManager.participantListQuery = nil
            
            completion()
        })
    }
    
    func isUserLoginChat()-> Bool {
        if let _ = SBDMain.getCurrentUser() { return true }
        return false
    }
    
	// - - - - - - - - - - - - - - - - -
	// Connect chat-user implementation
	// - - - - - - - - - - - - - - - - -
	// * TabBarVC.viewDidLoad
	// 	-- checkNetworkSignalRecursively
	//
	// * TabBarVC.didSetAppIcon (change app-container)
	// 	-- Shortcut.appDelegate.connectUserForChat
	//
	// * AppDelegate.applicationWillEnterForeground
	//  -- Shortcut.appDelegate.connectUserForChat
	//
	// * ChatVC.viewWillAppear
	//	-- Shortcut.appDelegate.connectUserForChat
	
	// - - - - - - - - - - - - - - - - -
	// Observe network connection status
	// - - - - - - - - - - - - - - - - -
	// ChatVC
	// ChatChannelVC
	// ChatPeopleVC
	// ChatMessagingVC
	
	// - - - - - - - - - - - - - - - - -
	// Disconnect chat-user implementation
	// - - - - - - - - - - - - - - - - -
	// * AppDelegate.applicationDidEnterBackground
	// * SettingsVC.actionLogout
	
    func registerUser(userId: String,
                      userName: String,
                      userGroupId: String,
                      userPosition: String,
                      userPhotoUrl: String,
                      isCreateMetaData: Bool,
                      completion: @escaping ((Error?)->Void)) {
        
        func startLogin() {
            NSLog("\(DebugInfoKey.messaging.rawValue) (ChatManager) connecting user \(userName) (\(userId)) to chat \(self.appId)...")
            
            SBDMain.connect(
                withUserId: userId,
                completionHandler: { [weak self] (user, error) in
                    
                guard let strongSelf = self, error == nil,
                    let user = user else {
                    
                    ChatManager.userId = nil
                    ChatManager.nickname = nil
					ChatManager.sdkHandledError(error: error, handledAlert: true)
                    completion(error)
                    return
                }
                
				// register pending device token if any
				if let pendingDeviceToken = SBDMain.getPendingPushToken() {
					strongSelf.pendingDeviceToken = pendingDeviceToken
					strongSelf.registerPush()
				}
					
                // extract connected user details
                ChatManager.userId = user.userId
                ChatManager.nickname = user.nickname
                NSLog("\(DebugInfoKey.messaging.rawValue) (ChatManager) sendbird abled to connect current-user \(ChatManager.nickname ?? "") (\(ChatManager.userId ?? ""))")
                
                strongSelf.updateChatProfile(
                  name: userName,
                  imageUrl: userPhotoUrl.cleanupImageUrl(),
                  completion: {
                        NSLog("\(DebugInfoKey.messaging.rawValue) (ChatManager) updated chat profile for current-user (\(userName))")
                    })
                
				if isCreateMetaData {
                    let data = [
                        ChatManager.USER_METADATA_KEY: userGroupId,
						ChatManager.USER_POSITION_METADATA_KEY: userPosition
                    ]
                    user.createMetaData(
						data,
						completionHandler: { (metaData, error) in
                        guard error == nil else {
                            ChatManager.userId = nil
                            ChatManager.nickname = nil
							ChatManager.sdkHandledError(error: error, handledAlert: true)
                            completion(error)
                            return
                        }
                    })
                }
                completion(nil)
            })
        }
        
        if SBDMain.getConnectState() == .open {
            // Connected to the chat server
			NSLog("\(DebugInfoKey.messaging.rawValue) user ALREADY CONNECTED to chat. reconnecting user to chat \(self.appId)...")
			
			self.logoutUser(
				unregisterPush: false,
				completion: {
					startLogin()
            })
        }
        else if SBDMain.getConnectState() == .connecting {
            // Connecting to the chat server
			NSLog("\(DebugInfoKey.messaging.rawValue) user STILL CONNECTING to chat.")
        }
        else {
            // Disconnected from the chat server
			NSLog("\(DebugInfoKey.messaging.rawValue) user DISCONNECTED from chat.")
            startLogin()
        }
    }
    
    func updateChatProfile(name: String,
                           imageUrl: String,
                           completion: @escaping (()->Void)) {
        SBDMain.updateCurrentUserInfo(
            withNickname: name,
            profileUrl: imageUrl,
            completionHandler: { (error) in
                guard error == nil else {
					ChatManager.sdkHandledError(error: error)
                    completion()
                    return
                }
                completion()
            })
    }
    
    static func disconnectUserFromChat(completion: @escaping (()->Void)) {
        SBDMain.disconnect(completionHandler: {
            NSLog("\(DebugInfoKey.messaging.rawValue) user disconnected from chat server successfully!")
			self.showDetails()
            self.disconnectedUser()
            completion()
        })
    }
    
    static func resetGroupChannelListing() {
        self.groupChannelListQuery = SBDGroupChannel.createMyGroupChannelListQuery()
    }
    
    static func getAppId(appCode: AppCode) -> String {
		// non-container app
        var sendBirdAppId = Shortcut.sendBirdAppId
		
		#if CONTAINER
        switch appCode {
        case .albert:
            sendBirdAppId = Shortcut.sendBirdAppIdAlbert
        case .ugo:
            sendBirdAppId = Shortcut.sendBirdAppIdUgo
        case .energia:
            sendBirdAppId = Shortcut.sendBirdAppIdEnergia
        default:
			// non-container app
            sendBirdAppId = Shortcut.sendBirdAppId
        }
		#endif
		
		let decryptedAppId = sendBirdAppId.decrypt()
		DebugInfo.log(info: "\(DebugInfoKey.messaging.rawValue) getAppId for \(appCode.title) with encrypted app-id \(sendBirdAppId)")
		DebugInfo.log(info: "\(DebugInfoKey.messaging.rawValue) getAppId for \(appCode.title) with decrypted app-id \(decryptedAppId)")
        return decryptedAppId
    }
    
	static func hasUserDetails() -> Bool {
		guard SBDMain.getCurrentUser() != nil else { return false }
		guard SBDMain.getConnectState() == .open else { return false }
		guard self.userId != nil else { return false }
		guard self.nickname != nil else { return false }
		return true
	}
	
    // MARK: - Logs
    
    static func showDetails() {
        DebugInfo.log(info: "\(DebugInfoKey.messaging.rawValue) chat details...")
		DebugInfo.log(info: "\(DebugInfoKey.messaging.rawValue) -- ChatManager chat-user \(self.nickname ?? "?") (\(self.userId ?? "?"))")
		DebugInfo.log(info: "\(DebugInfoKey.messaging.rawValue) -- SBDMain app-id \(SBDMain.getApplicationId() ?? "?")")
		DebugInfo.log(info: "\(DebugInfoKey.messaging.rawValue) -- SBDMain current-user \(SBDMain.getCurrentUser()?.userId ?? "?")")
		DebugInfo.log(info: "\(DebugInfoKey.messaging.rawValue) -- SBDMain connect-state \(SBDMain.getConnectState().rawValue)")
    }
    
    func userDetails() {
        DebugInfo.log(info: "\(DebugInfoKey.messaging.rawValue) chat details...")
        DebugInfo.log(info: "\(DebugInfoKey.messaging.rawValue) -- ChatManager sendbird app-id \(self.appId)")
		DebugInfo.log(info: "\(DebugInfoKey.messaging.rawValue) -- ChatManager chat-user \(ChatManager.nickname ?? "?") (\(ChatManager.userId ?? "?"))")
		DebugInfo.log(info: "\(DebugInfoKey.messaging.rawValue) -- SBDMain app-id \(SBDMain.getApplicationId() ?? "?")")
		DebugInfo.log(info: "\(DebugInfoKey.messaging.rawValue) -- SBDMain current-user \(SBDMain.getCurrentUser()?.userId ?? "?")")
		DebugInfo.log(info: "\(DebugInfoKey.messaging.rawValue) -- SBDMain connect-state \(SBDMain.getConnectState().rawValue)")
    }
    
	// MARK: - APNS
	
	func registerPush() {
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		guard var deviceToken = appDelegate.apnsManager.getAPNSTokenRaw() else { return }
		
		if let pendingDeviceToken = self.pendingDeviceToken {
			DebugInfo.log(info: "\(DebugInfoKey.messaging.rawValue) register pending device-token")
			deviceToken = pendingDeviceToken
		}
		
		SBDMain.registerDevicePushToken(
			deviceToken,
			unique: true,
			completionHandler: {(status, error) in
				if error == nil {
					if status == SBDPushTokenRegistrationStatus.pending {
						DebugInfo.log(info: "\(DebugInfoKey.messaging.rawValue) device-token registration pending")
					}
					else {
						DebugInfo.log(info: "\(DebugInfoKey.messaging.rawValue) device successfully registered")
						self.pendingDeviceToken = nil
					}
				}
				else {
					DebugInfo.log(info: "\(DebugInfoKey.messaging.rawValue) device registration failure")
					ChatManager.sdkHandledError(error: error)
				}
		})
	}
		
	func unregisterPush() {
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		guard var deviceToken = appDelegate.apnsManager.getAPNSTokenRaw() else { return }

		if let pendingDeviceToken = self.pendingDeviceToken {
			NSLog("\(DebugInfoKey.messaging.rawValue) unregister pending device-token")
			deviceToken = pendingDeviceToken
		}
		
		SBDMain.unregisterPushToken(
			deviceToken,
			completionHandler: { (token, error) in
				guard error == nil else {
					ChatManager.sdkHandledError(error: error)
					return
				}
				NSLog("\(DebugInfoKey.messaging.rawValue) unregistered device-token")
				self.pendingDeviceToken = nil
		})
	}
	
	func didReceivePush(userInfo: NSDictionary, applicationState: UIApplication.State) {
		// https://docs.sendbird.com/ios/push_notifications#3_step_5_handle_a_notification_payload
		guard let selectedApsPayload = userInfo["aps"] as? NSDictionary else { return }
		guard let selectedSendBirdPayload = userInfo["sendbird"] as? NSDictionary else { return }
		let selectedChannelInfo = selectedSendBirdPayload["channel"] as! NSDictionary
		let selectedChannelUrl = selectedChannelInfo["channel_url"] as! String
		
		NSLog("\(DebugInfoKey.messaging.rawValue) selected aps payload: \(selectedApsPayload)")
		NSLog("\(DebugInfoKey.messaging.rawValue) selected sendbird payload: \(selectedSendBirdPayload)")
		
		// replace old notification message from same channel
		// one push notification message for each channel
		let userNotificationCenter = UNUserNotificationCenter.current()
		userNotificationCenter.getDeliveredNotifications(
			completionHandler: { notifications in
				for (index, notification) in notifications.enumerated() {
					// https://bitbucket.org/thinkittwice/documentation/src/master/notifications-payload.md
					let userInfo = notification.request.content.userInfo as NSDictionary
					let apsPayload = userInfo["aps"] as! NSDictionary
					let sendBirdPayload = userInfo["sendbird"] as! NSDictionary
					
					let channelInfo = sendBirdPayload["channel"] as! NSDictionary
					let channelUrl = channelInfo["channel_url"] as! String
					
					// notifications where sorted by latest message first
					if index == 0 {
						continue
					}
					else {
						if channelUrl == selectedChannelUrl {
							NSLog("\(DebugInfoKey.messaging.rawValue) remove notification-message \(apsPayload["alert"] ?? "") for channel \(channelUrl)")
							userNotificationCenter.removeDeliveredNotifications(
								withIdentifiers: [notification.request.identifier]
							)
						}
					}
				}
		})
		
		// app was in background via home button (user forced to disconnect from chat)
		// user was disconnected from chat
		// action method when user interactively selected the notification
		if applicationState == .inactive {
			// has existing messaging
			if let enteredChannel = ChatManager.getEnteredChannel() {
				// same channel
				if enteredChannel.channelUrl == selectedChannelUrl {
					()
				}
				// different channel
				else {
					// handled in TabBarViewController
					ChatManager.selectedNotification(payload: selectedSendBirdPayload)
				}
			}
			// no opened messaging view
			else {
				// handled in TabBarViewController
				ChatManager.selectedNotification(payload: selectedSendBirdPayload)
			}
		}
	}
	
	// MARK: - Factory Method
	
	static func getChannelViewModelFromNotification(payload: NSDictionary) -> ChatChannelVM {
		// https://bitbucket.org/thinkittwice/documentation/src/master/notifications-payload.md
		// open channel don't have message notification
		let channel = payload["channel"] as! NSDictionary
		let sender = payload["sender"] as! NSDictionary
		let unreadMessageCount = payload["unread_message_count"] as! Int
		
		let groupChannelCustomType = channel["custom_type"] as! String
		let groupChannelType = GroupChannelCustomType(rawValue: UInt(groupChannelCustomType) ?? GroupChannelCustomType.singleConversation.rawValue)
		// default value to 1x1 conversation
		var title = sender["name"] as! String
		var channelType = ChannelType.singleConversation
		if groupChannelType == GroupChannelCustomType.groupConversation {
			title = channel["name"] as! String
			channelType = ChannelType.multipleConversation
		}
		
		let channelViewModel = ChatChannelVM(
			totalCount: unreadMessageCount,
			title: title,
			subTitle: "",
			photoUrl: "",
			type: channelType,
			channelUrl: channel["channel_url"] as! String,
			isFrozen: false)
		return channelViewModel
	}
	
    // MARK: - User and Channel Listing
  
    static func getUserList(
        groupId: String,
        completion: @escaping ((Bool, [ChatPersonModel])->Void),
        includeLoginUser: Bool? = true,
        nextPageMode: Bool = false,
		userNameFilter: String? = nil) {
            if nextPageMode == false {
                self.userListQuery = SBDMain.createApplicationUserListQuery()
            }
        
            guard let listQuery: SBDApplicationUserListQuery = self.userListQuery else { return }
            listQuery.limit = self.PAGE_LIMIT
            listQuery.setMetaDataFilterWithKey(self.USER_METADATA_KEY, values: [groupId])
            listQuery.loadNextPage(
				completionHandler: { (users, error) in
					guard error == nil, let people = users else {
						self.sdkHandledError(error: error)
						return
					}
					var listUsers = [ChatPersonModel]()
					people.forEach { user in
						guard let metadata = user.metaData else { return }
						let userPosition = metadata["user_position"]
						let status = user.connectionStatus == SBDUserConnectionStatus.online ? true: false
						
						let model = ChatPersonModel(
							userId: user.userId,
							name: user.nickname ?? "",
							position: userPosition,
							connectionStatus: status,
							photoUrl: user.profileUrl ?? "")
						
						if let userNameFilter = userNameFilter,
						   userNameFilter.count > 0 {
							if let userName = model.name?.lowercased() {
								let userNameFilterLowerCased = userNameFilter.lowercased()
								if userName.contains(userNameFilterLowerCased) {
									listUsers.append(model)
								}
							}
						}
						else {
							listUsers.append(model)
						}
					}
					completion(listQuery.hasNext, listUsers)
            })
    }
    
    static func getOpenChannel(
        groupId: String,
        completion: @escaping ((Bool, [ChatChannelModel])->Void),
        nextPageMode: Bool = false,
		channelNameFilter: String? = nil) {
            if nextPageMode == false {
                self.openChannelListQuery = SBDOpenChannel.createOpenChannelListQuery()
            }
            
            guard let listQuery: SBDOpenChannelListQuery = self.openChannelListQuery else { return }
            listQuery.limit = self.PAGE_LIMIT
            listQuery.customTypeFilter = groupId
			listQuery.channelNameFilter = channelNameFilter
            listQuery.loadNextPage(completionHandler: { (openChannels, error) in
                guard error == nil, let channels = openChannels else {
                    self.sdkHandledError(error: error)
                    return
                }
                var listChannels = [ChatChannelModel]()
                channels.forEach { channel in
                    let type = ChannelType.openChannel
                    let name = channel.name
                    let time = channel.createdAt
                    let avatarUrl = channel.coverUrl
                    let channelUrl = channel.channelUrl
                    let isFrozen = channel.isFrozen
                    
                    listChannels.append(ChatChannelModel(
                      name: name,
                      time: time,
                      photo: avatarUrl,
                      type: type.rawValue,
                      channelUrl: channelUrl,
                      isFrozen: isFrozen))
                }
				if !listQuery.hasNext {
					self.groupChannelListQuery = SBDGroupChannel.createMyGroupChannelListQuery()
				}
                completion(listQuery.hasNext, listChannels)
                
                // reset group channel to continue existing results of open channel listing
              
            })
    }
    
    static func getGroupChannel(
        memberId: String,
        completion: @escaping ((Bool, [ChatChannelModel])->Void),
        nextPageMode: Bool = false,
		channelNameFilter: String? = nil) {
		if nextPageMode == false  {
				self.groupChannelListQuery = SBDGroupChannel.createMyGroupChannelListQuery()
		}
            
            guard let listQuery: SBDGroupChannelListQuery = self.groupChannelListQuery else { return }
            listQuery.includeEmptyChannel = true
            listQuery.order = .latestLastMessage
            listQuery.limit = self.PAGE_LIMIT
			listQuery.channelNameContainsFilter = channelNameFilter
            listQuery.loadNextPage(
                completionHandler: { (groupChannels, error) in
                    guard error == nil, let channels = groupChannels else {
                        self.sdkHandledError(error: error)
                        return
                    }
					
                    var listChannels = [ChatChannelModel]()
                    channels.forEach { channel in
                        // 1x1 conversation
                        if channel.memberCount == 2 && channel.hasConversation(to: memberId) && channel.customType == "\(GroupChannelCustomType.singleConversation.rawValue)" {
                            if let partnerUser = channel.singleConversationMember(to: memberId) {
                                let type = ChannelType.singleConversation
                                var name = partnerUser.nickname
                                var avatarUrl = partnerUser.profileUrl
								if(!partnerUser.isActive) {
									name = "unknown_user".localized()
									avatarUrl = ""
								}
                                let channelUrl = channel.channelUrl
                                let isFrozen = channel.isFrozen
                                let unreadMessageCount = channel.unreadMessageCount
                                
                                var lastMessage: String? = nil
                                if let message = channel.lastMessage {
                                    lastMessage = message.message
									if (channel.lastMessage is SBDFileMessage) {
										lastMessage = "file_message".localized()
									}
                                }
                                
								if(!partnerUser.isActive) {
									listChannels.append(
										ChatChannelModel(
											name: name,
											photo: avatarUrl,
											lastMsg: lastMessage,
											type: type.rawValue,
											channelUrl: channelUrl,
											isFrozen: isFrozen,
											unreadMessageCount: unreadMessageCount,
											hasInactiveMember: true
									))
								} else {
									listChannels.append(
										ChatChannelModel(
											name: name,
											photo: avatarUrl,
											lastMsg: lastMessage,
											type: type.rawValue,
											channelUrl: channelUrl,
											isFrozen: isFrozen,
											unreadMessageCount: unreadMessageCount
									))
								}
                            }
                        }
						else if channel.memberCount >= 2 &&
							channel.customType == "\(GroupChannelCustomType.groupConversation.rawValue)" {
							let type = ChannelType.multipleConversation
							let name = channel.name
							let avatarUrl = channel.coverUrl
							let channelUrl = channel.channelUrl
							let isFrozen = channel.isFrozen
							let unreadMessageCount = channel.unreadMessageCount
							
							var lastMessage: String? = nil
							if let message = channel.lastMessage {
								lastMessage = message.message
								if (channel.lastMessage is SBDFileMessage) {
									lastMessage = "file_message".localized()
								}
							}
							
							listChannels.append(
								ChatChannelModel(
									name: name,
									photo: avatarUrl,
									lastMsg: lastMessage,
									type: type.rawValue,
									channelUrl: channelUrl,
									isFrozen: isFrozen,
									unreadMessageCount: unreadMessageCount
							))
						}
                    }
                    completion(listQuery.hasNext, listChannels)
            })
    }
    
    static func channelMessagesMarkAsRead(
        completion: @escaping((String)->Void)) {
            guard let channel = self.enteredGroupChannel else { return }
            channel.markAsRead()
            completion(channel.channelUrl)
    }

    // MARK: - Conversations

    static func singleConversation(
        to memberId: String,
        memberName: String,
        completion: @escaping ((ChatChannelModel)->Void)) {
            guard let userId = self.userId,
                let currentUsername = self.nickname else { return }
        
            let params = SBDGroupChannelParams()
            params.isDistinct = true
            params.addUserIds([memberId, userId])
            params.name = "\(memberName)_\(currentUsername)"
            params.customType = "\(GroupChannelCustomType.singleConversation.rawValue)"

            SBDGroupChannel.createChannel(
                with: params,
                completionHandler: { (groupChannel, error) in
                    guard error == nil,
                        let channel = groupChannel,
                        channel.customType == "\(GroupChannelCustomType.singleConversation.rawValue)" else {
                            self.sdkHandledError(error: error)
                            return
                    }
                    
                    // 1x1 conversation
					// including the active user in the count
                    if channel.memberCount == 2 && channel.hasConversation(to: memberId) {
                        if let partnerUser = channel.singleConversationMember(to: memberId) {
                            let type = ChannelType.singleConversation
                            let name = memberName
                            let avatarUrl = partnerUser.profileUrl
                            let channelUrl = channel.channelUrl

                            var lastMessage: String? = nil
                            if let message = channel.lastMessage {
								lastMessage = message.message
								if (channel.lastMessage is SBDFileMessage) {
									lastMessage = "file_message".localized()
								}
							}
        
                            let model = ChatChannelModel(
                                    name: name,
                                    photo: avatarUrl,
                                    lastMsg: lastMessage,
                                    type: type.rawValue,
                                    channelUrl: channelUrl)
                            completion(model)
                        }
                    }
                    else {
                        ()
                    }
            })
        
    }
  
    static func multipleConversation(
        to memberIds: [String],
        groupName: String,
		groupImageData: Data?,
        completion: @escaping ((ChatChannelModel)->Void)) {
			guard memberIds.count > 0 else { return }
        
            let params = SBDGroupChannelParams()
            params.isDistinct = false
            params.addUserIds(memberIds)
            params.name = groupName
            params.customType = "\(GroupChannelCustomType.groupConversation.rawValue)"
		
			if let imageData = groupImageData {
				params.coverImage = imageData
			}
		
            SBDGroupChannel.createChannel(
                with: params,
                completionHandler: { (groupChannel, error) in
                    guard error == nil,
                        let channel = groupChannel,
                        channel.customType == "\(GroupChannelCustomType.groupConversation.rawValue)" else {
                            self.sdkHandledError(error: error)
                            return
                    }
                    
					// custom group conversation
                    // including the active user in the count
                    if channel.memberCount >= 2 {
						let type = ChannelType.multipleConversation
						let name = groupName
						let avatarUrl = channel.coverUrl
						let channelUrl = channel.channelUrl

						var lastMessage: String? = nil
						if let message = channel.lastMessage {
							lastMessage = message.message
						}

						let model = ChatChannelModel(
								name: name,
								photo: avatarUrl,
								lastMsg: lastMessage,
								type: type.rawValue,
								channelUrl: channelUrl)
						completion(model)
                        
                    }
                    else {
                        ()
                    }
            })
        
    }
    
    static func leaveConversation(
        completion: @escaping (()->Void)) {
        guard let channel = self.getEnteredChannel() else { return }
        
        switch channel {
        case let openChannel as SBDOpenChannel:
            openChannel.exitChannel(completionHandler: { (error) in
                guard error == nil else {
                    self.sdkHandledError(error: error)
                    return
                }
				DebugInfo.log(info: "\(DebugInfoKey.messaging.rawValue) (ChatManager) exited to channel (\(channel.channelUrl))")
                self.leavedToMessaging()
                completion()
            })
        case let groupChannel as SBDGroupChannel:
            groupChannel.leave(completionHandler: { (error) in
                guard error == nil else {
                    self.sdkHandledError(error: error)
                    return
                }
				DebugInfo.log(info: "\(DebugInfoKey.messaging.rawValue) (ChatManager) leaved to channel (\(channel.channelUrl))")
                self.leavedToMessaging()
                completion()
            })
        default:
            completion()
        }
    }
    
    
    // MARK: - Messaging
    
    static func getEnteredChannel() -> SBDBaseChannel? {
        let enteredOpenChannel = self.enteredOpenChannel
        let enteredGroupChannel = self.enteredGroupChannel
    
        var enteredChannel: SBDBaseChannel?
        if enteredOpenChannel != nil {
            enteredChannel = self.enteredOpenChannel
        }
        else if enteredGroupChannel != nil {
            enteredChannel = self.enteredGroupChannel
        }
        return enteredChannel
    }
    
    static func enterToOpenChannel(
        channelUrl: String,
        completion: @escaping ((Bool, [ChatPersonModel])->Void)) {
			DebugInfo.log(info: "\(DebugInfoKey.messaging.rawValue) SBDMain app-id \(SBDMain.getApplicationId() ?? "")")
            SBDOpenChannel.getWithUrl(
                channelUrl,
                completionHandler: { (channel, error) in
                    guard error == nil else {
                        self.sdkHandledError(error: error)
                        return
                    }

					self.enteredOpenChannel = channel
					if let channel = channel {
						channel.enter(completionHandler: { (error) in
							guard error == nil else {
								self.sdkHandledError(error: error)
								return
							}
							
							if channel.participantCount > 0 {
								DebugInfo.log(info: "\(DebugInfoKey.messaging.rawValue) total participants: \(channel.participantCount)")
								
								self.participantListQuery = channel.createParticipantListQuery()
								self.participantListQuery?.limit = self.PAGE_LIMIT
								self.participantListQuery?.loadNextPage(completionHandler: { (participants, error) in
									if error != nil {
										self.sdkHandledError(error: error)
										return
									}
									
									// participants
									var listUsers = [ChatPersonModel]()
									if let participants = participants {
										participants.forEach { user in
											guard let metadata = user.metaData else { return }
											let userPosition = metadata["user_position"]
											let status = user.connectionStatus == SBDUserConnectionStatus.online ? true: false

											listUsers.append(
												ChatPersonModel(
													userId: user.userId,
													name: user.nickname ?? "",
													position: userPosition,
													connectionStatus: status,
													photoUrl: user.profileUrl ?? ""))
										}
									}
									
									completion(self.participantListQuery?.hasNext ?? false, listUsers)
								})
							}
						})
					}
	
            })
    }
    
	static func getMoreParticipants(
		completion: @escaping ((Bool, [ChatPersonModel])->Void)) {
		
		guard let _ = self.getEnteredChannel() else { return }
		guard let listQuery = self.participantListQuery else { return }
		
		listQuery.limit = self.PAGE_LIMIT
		listQuery.loadNextPage(completionHandler: { (participants, error) in
			if error != nil {
				self.sdkHandledError(error: error)
				return
			}
			
			// participants
			var listUsers = [ChatPersonModel]()
			if let participants = participants {
				participants.forEach { user in
					guard let metadata = user.metaData else { return }
					let userPosition = metadata["user_position"]
					let status = user.connectionStatus == SBDUserConnectionStatus.online ? true: false

					listUsers.append(
						ChatPersonModel(
							userId: user.userId,
							name: user.nickname ?? "",
							position: userPosition,
							connectionStatus: status,
							photoUrl: user.profileUrl ?? ""))
				}
			}
			
			completion(listQuery.hasNext, listUsers)
		})
	}
	
    static func enterToGroupChannel(
        channelUrl: String,
        completion: @escaping (([ChatPersonModel])->Void)) {
			DebugInfo.log(info: "\(DebugInfoKey.messaging.rawValue) SBDMain app-id \(SBDMain.getApplicationId() ?? "")")
            SBDGroupChannel.getWithUrl(
                channelUrl,
                completionHandler: { (channel, error) in
                    guard error == nil else {
                        self.sdkHandledError(error: error)
                        return
                    }
                    self.enteredGroupChannel = channel
					
					// members
					var listUsers = [ChatPersonModel]()
					if let members = channel?.members {
						DebugInfo.log(info: "\(DebugInfoKey.messaging.rawValue) total members: \(members.count)")
						
						members.forEach { user in
							if let user = user as? SBDMember {
								guard let metadata = user.metaData else { return }
								let userPosition = metadata["user_position"]
								let status = user.connectionStatus == SBDUserConnectionStatus.online ? true: false

								listUsers.append(
									ChatPersonModel(
										userId: user.userId,
										name: user.nickname ?? "",
										position: userPosition,
										connectionStatus: status,
										photoUrl: user.profileUrl ?? ""))
								
							}
						}
					}
					
					completion(listUsers)
            })
    }
    
    static func leavedToMessaging() {
        // user leaved the message view
        
        self.messageListQuery = nil
        self.enteredOpenChannel = nil
        self.enteredGroupChannel = nil
    }
    
    static func getMessages(
        completion: @escaping (([ChatMessageModel])->Void),
        nextPageMode: Bool = false) {
            guard let channel = self.getEnteredChannel() else { return }
            if nextPageMode == false {
                self.messageListQuery = channel.createPreviousMessageListQuery()
            }
            else {
                if self.messageListQuery == nil {
                    self.messageListQuery = channel.createPreviousMessageListQuery()
                }
            }
            guard let listQuery: SBDPreviousMessageListQuery = self.messageListQuery else { return }
            listQuery.loadPreviousMessages(
                withLimit: Int(self.PAGE_LIMIT),
                reverse: false,
                completionHandler: { (userMessages, error) in
                    guard error == nil else {
                        self.sdkHandledError(error: error)
                        return
                    }
                    
                    var messagesModel = [ChatMessageModel]()
                    if let messages = userMessages {
                
                        messages.forEach { userMessage in
                            let message = userMessage.message
							let messageId = userMessage.messageId
                            let messageCreatedAt = userMessage.createdAt

                            var senderPhotoUrl: String?
                            var senderName: String?
                            var senderUserId: String?
                            if let sender = userMessage.sender {
                                senderPhotoUrl = sender.profileUrl
                                senderName = sender.nickname
								if(!sender.isActive) {
									senderName = "unknown_user".localized()
									senderPhotoUrl = ""
								}
                                senderUserId = sender.userId
                            }
                            

                             if let fileMessage = userMessage as? SBDFileMessage {
                                DebugInfo.log(info: "\(DebugInfoKey.messaging.rawValue) sendbird fileMessage \(String(describing: fileMessage))")
                                messagesModel.append(
                                                             ChatMessageModel(
                                                                 message: message,
																 messageId: messageId,
                                                                 createdAt: messageCreatedAt,
                                                                 photoUrl: senderPhotoUrl,
                                                                 senderName: senderName,
                                                                 senderUserId: senderUserId,
                                                                 isFile: true,
																 fileName: fileMessage.name,
                                                                 fileUrl: fileMessage.url,
                                                                 fileType: fileMessage.type)
                                                         )
                             } else {
                                messagesModel.append(
                                                             ChatMessageModel(
                                                                 message: message,
																 messageId: messageId,
																 createdAt: messageCreatedAt,
																 photoUrl: senderPhotoUrl,
																 senderName: senderName,
																 senderUserId: senderUserId)
                                                         )
                            }
                           
                            
				
                        }
                        completion(messagesModel)
                    }
                })
    }
    
    static func sendUserMessage(
        message: String,
        completion: @escaping ((ChatMessageModel)->Void)) {
            guard let channel = self.getEnteredChannel() else { return }
            channel.sendUserMessage(
                message,
                completionHandler: { (userMessage, error) in
                    guard error == nil else {
                        self.sdkHandledError(error: error)
                        return
                    }
                    guard let messageReceived = userMessage else { return }

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
                    
                    completion(
                        ChatMessageModel(
                            message: message,
							messageId: messageId,
                            createdAt: messageCreatedAt,
                            photoUrl: senderPhotoUrl,
                            senderName: senderName,
                            senderUserId: senderUserId)
                    )
            })
    }
		
	static func normalizedImage (image: UIImage) -> UIImage{
		if (image.imageOrientation == .up) {return image};

		UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale);
		image.draw(in: CGRect.init(x: 0, y: 0, width: image.size.width, height: image.size.height))
		let normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
		return normalizedImage!;
	}
	
	static func sendUserImage(
		image: UIImage,
		completion: @escaping ((ChatMessageModel)->Void))  {
		
		guard let channel = self.getEnteredChannel() else { return }
        
			do {

			let newImage = self.normalizedImage(image: image)
			let data = newImage.jpegData(compressionQuality: 0.3)
			
            let params = SBDFileMessageParams.init(file: data!)!
            let array = [UInt8](data!)
            var value : UInt = 0
            for byte in array {
                value = value << 8
                value = value | UInt(byte)
            }
            params.fileSize = value
            params.fileName = "IMG_\(Date().currentTimeMillis()).png"
            params.mimeType = Constants.sendBirdImageType
            
			channel.sendFileMessage(
				with: params,
                completionHandler: { (userMessage, error) in
					
                    guard error == nil else {
                        self.sdkHandledError(error: error)
                        return
                    }
                    guard let messageReceived = userMessage else { return }

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
                    
                    completion(
                        ChatMessageModel(
                            message: message,
							messageId: messageId,
                            createdAt: messageCreatedAt,
                            photoUrl: senderPhotoUrl,
                            senderName: senderName,
                            senderUserId: senderUserId,
							isFile: true,
							fileUrl: messageReceived.url,
							fileType: messageReceived.type)
                    )
            })
		}
		
			
	}
	
	static func sendUserVideo(
		videoData: NSData,
		lastPathComponent: String,
		completion: @escaping ((ChatMessageModel)->Void))  {
		
		guard let channel = self.getEnteredChannel() else { return }
        
			do {

			let params = SBDFileMessageParams.init(file: videoData as Data)!
			params.fileSize = UInt(videoData.length)
			params.fileName = lastPathComponent
            params.mimeType = Constants.sendBirdVideoType
            
			channel.sendFileMessage(
				with: params,
                completionHandler: { (userMessage, error) in
                    guard error == nil else {
                        self.sdkHandledError(error: error)
                        return
                    }
                    guard let messageReceived = userMessage else { return }

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
                    
                    completion(
                        ChatMessageModel(
                            message: message,
							messageId: messageId,
                            createdAt: messageCreatedAt,
                            photoUrl: senderPhotoUrl,
                            senderName: senderName,
                            senderUserId: senderUserId,
							isFile: true,
							fileName: messageReceived.name,
							fileUrl: messageReceived.url,
							fileType: messageReceived.type)
                    )
            })
		}
		
			
	}
    
	
    static func sendUserDocument(documentData: NSData,
								 lastPathComponent: String,
								 completion: @escaping ((ChatMessageModel)->Void)) {
        
          
		guard let channel = self.getEnteredChannel() else { return }
        
			do {

			let params = SBDFileMessageParams.init(file: documentData as Data)!
			let array = [UInt8](documentData as Data)
            var value : UInt = 0
            for byte in array {
                value = value << 8
                value = value | UInt(byte)
            }
            params.fileSize = value
			params.fileName = lastPathComponent
            params.mimeType = Constants.sendBirdDocumentType
            
			channel.sendFileMessage(
				with: params,
                completionHandler: { (userMessage, error) in
                    guard error == nil else {
                        self.sdkHandledError(error: error)
                        return
                    }
                    guard let messageReceived = userMessage else { return }

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
                    
                    completion(
                        ChatMessageModel(
                            message: message,
							messageId: messageId,
                            createdAt: messageCreatedAt,
                            photoUrl: senderPhotoUrl,
                            senderName: senderName,
                            senderUserId: senderUserId,
							isFile: true,
							fileName: messageReceived.name,
							fileUrl: messageReceived.url,
							fileType: messageReceived.type)
                    )
            })
		}
       
//
          
       }
    
	static func updateUserMessage(
		messageId: Int64,
		newMessage: String,
		completion: @escaping ((ChatMessageModel)->Void)) {
			guard let channel = self.getEnteredChannel() else { return }
			guard let params = SBDUserMessageParams(message: newMessage) else { return  }
			channel.updateUserMessage(
				withMessageId: messageId,
				userMessageParams: params,
				completionHandler: { (userMessage, error) in
					guard error == nil else {
                        self.sdkHandledError(error: error)
                        return
                    }
					guard let messageReceived = userMessage else { return }

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
					
					completion(
                        ChatMessageModel(
                            message: message,
							messageId: messageId,
                            createdAt: messageCreatedAt,
                            photoUrl: senderPhotoUrl,
                            senderName: senderName,
                            senderUserId: senderUserId)
                    )
			})
		}
	
	static func deleteUserMessage(
        messageId: Int64,
        completion: @escaping ((Int64)->Void)) {
            guard let channel = self.getEnteredChannel() else { return }
			channel.deleteMessage(
				withMessageId: messageId,
				completionHandler: { error in
					guard error == nil else {
                        self.sdkHandledError(error: error)
                        return
                    }
					completion(messageId)
			})
		}
	
	static func isUserActive(userId: String,
							 completion: @escaping ((Bool)->Void)) {

		let userQuery = SBDMain.createApplicationUserListQuery()
		userQuery?.userIdsFilter = [userId]
		userQuery?.loadNextPage(completionHandler: { (user, error) in
			guard error == nil, let user = user else {
				self.sdkHandledError(error: error)
				return
			}
			if(user.count > 0) {
				completion(true)
			} else {
				completion(false)
			}
		})

	}
	
	static func getActiveMembers(members: [String],
							 completion: @escaping (([String])->Void)) {

		let userQuery = SBDMain.createApplicationUserListQuery()
		userQuery?.userIdsFilter = members
		userQuery?.loadNextPage(completionHandler: { (users, error) in
			guard error == nil, let users = users else {
				self.sdkHandledError(error: error)
				return
			}
			
			var activeMembers = [String]()
			
			users.forEach { user in
				if(user.isActive)
				{
					activeMembers.append(user.userId)
				}
			}
			
			completion(activeMembers)
			
		})

	}
	
}
