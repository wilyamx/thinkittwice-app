//
//  ChatPeopleController.swift
//  DailyTraining
//
//  Created by John Andrew Daugdaug on 7/2/20.
//  Copyright © 2020 Andrew Daugdaug. All rights reserved.
//

import Foundation

class ChatPeopleController: BaseController, ChatPeopleSearchProtocol {
    
    private var listPeople = [ChatPeopleVM]()
    private var lastPagePagination = false
    
	// required in ChatPeopleSearchProtocol
	public var userNameFilter: String?
	
    func pullDown(completion: @escaping (([ChatPeopleVM])->Void)) {
        self.lastPagePagination = false
        
        getPeople(
            completion: { [unowned self] (listPeople) in
                self.listPeople.removeAll()
                self.listPeople.append(contentsOf: listPeople)
                completion(self.listPeople)
            })
    }
    
    func pullUp(completion: @escaping (([ChatPeopleVM])->Void)) {
        guard !self.lastPagePagination else {
            completion([ChatPeopleVM]())
            return
        }
        
        getPeople(
            completion: { [unowned self] (listPeople) in
                self.listPeople.append(contentsOf: listPeople)
                completion(self.listPeople)
            },
            nextPageMode: true)
    }
    
	func getLoginUser() -> User? {
		return userManager.getLoginUser()
	}
	
    func getPeople(completion: @escaping (([ChatPeopleVM])->Void),
                   nextPageMode: Bool? = false) {
        guard let user = userManager.getLoginUser() else {
            return
        }
        
        Shortcut.appDelegate.chatManager.userDetails()
        
        var people = [ChatPeopleVM]()
        
        // reached last page
        if self.lastPagePagination {
           completion(people)
           return
        }
        
        ChatManager.getUserList(
            groupId: "\(user.groupId ?? 0)",
            completion: { (hasNext, listPeople) in
                listPeople.forEach { person in
                    people.append(
                      ChatPeopleVM(userId:person.userId ?? "",
                                   name: person.name ?? "",
                                   photoUrl: person.photoUrl ?? "",
                                   position: person.position ?? "",
                                   status: person.connectionStatus ?? false))
                }
				DebugInfo.log(info: "\(DebugInfoKey.messaging.rawValue) more \(people.count) people(s)")
                completion(people)
                if !hasNext {
                    self.lastPagePagination = true
                }
            },
            nextPageMode: nextPageMode!,
			userNameFilter: self.userNameFilter
        )
    }
  
	func getMoreParticipants(
		completion: @escaping ((Bool, [ChatPeopleVM])->Void)) {
		guard let _ = userManager.getLoginUser() else {
			return
		}
		
		var participants = [ChatPeopleVM]()
		ChatManager.getMoreParticipants(completion: { (hasNext, listPeople) in
			listPeople.forEach { person in
				participants.append(
				  ChatPeopleVM(userId:person.userId ?? "",
							   name: person.name ?? "",
							   photoUrl: person.photoUrl ?? "",
							   position: person.position ?? "",
							   status: person.connectionStatus ?? false))
			}
			DebugInfo.log(info: "\(DebugInfoKey.messaging.rawValue) more \(participants.count) participant(s)")
			completion(hasNext, participants)
		})
	}
	
    func singleConversation(to userId:String,
                            username: String,
                            completion: @escaping ((ChatChannelVM)->Void)) {
        guard let loginUser = userManager.getLoginUser() else {
            return
        }
        
        // apply conversation not to self
        if "\(loginUser.id!)" == userId {
            return
        }
        
        ChatManager.singleConversation(
            to: userId,
            memberName: username,
            completion: { channel in
                let viewModel = ChatChannelVM(
                        totalCount: 0,
                        title: channel.name ?? "",
                        subTitle: channel.time?.toDate() ?? "",
                        photoUrl: channel.photo ?? "",
                        type: ChannelType.singleConversation,
                        channelUrl: channel.channelUrl ?? "")
                completion(viewModel)
            })
    
    }
	
	func multipleConversation(to userIds:[String],
							  groupName: String,
							  groupImageData: Data?,
							  completion: @escaping ((ChatChannelVM)->Void)) {
        guard let _ = userManager.getLoginUser() else {
            return
        }
                
        ChatManager.multipleConversation(
            to: userIds,
            groupName: groupName,
			groupImageData: groupImageData,
            completion: { channel in
                let viewModel = ChatChannelVM(
                        totalCount: 0,
                        title: channel.name ?? "",
                        subTitle: channel.time?.toDate() ?? "",
                        photoUrl: channel.photo ?? "",
                        type: ChannelType.multipleConversation,
                        channelUrl: channel.channelUrl ?? "")
                completion(viewModel)
            })
    
    }
}
