# Think It Twice: Sample iOS Swift Code

A mobile application for bringing digital training solution in the luxury retail industry.

* [Official site](https://youralbert.com/)
* [iOS App](https://apps.apple.com/ph/app/albert-daily-feed/id1193114829)

## Featured Codes

1. `ChatMembersViewController` - **VIEW**

	<img src="images/chat-people.png" alt="ChatPeopleViewController" height="400">
	
	* `ChatPeopleController` - **VIEW MODEL**
	* `ChatPeopleTableViewCell`
	* `ChatPeopleVM`
	
1. `ChatMessagingViewController` - **VIEW**

	<img src="images/chat-messaging.png" alt="ChatMessagingViewController" height="400">
	
	* `ChatMessagingController` - **VIEW MODEL**
	* `ChatMessageTableViewCell`
	* `ChatOwnedMessageTableViewCell`
	* `ChatMessageVM`
	
1. `ChatManager` - **MODEL**

	* backend requests for SendBird server
	
## MVVM Architectural Design Pattern

1. **Model**
	- returns the api model in **`struct` that extents to `Codable`**
2. **View**
	- the displayable **`UIViewController`**
	- use VM (model to display the view)
3. **View Model**
	- calls the network api
	- converts the api model in **custom `class` that extents to `NSObject`**
