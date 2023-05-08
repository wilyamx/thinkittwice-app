# Think It Twice: Sample iOS Swift Code

A mobile application for bringing **digital training solution** in the luxury retail industry.

* [Official site](https://youralbert.com/)
* [iOS App](https://apps.apple.com/ph/app/albert-daily-feed/id1193114829)

## Featured Codes

**Project Folder:** `/ DailyTraining`

1. `ChatMembersViewController` - **VIEW**

	* `ChatPeopleController` - **VIEW MODEL**
	* `ChatPeopleTableViewCell`
	* `ChatPeopleVM`
	
1. `ChatMessagingViewController` - **VIEW**

	* `ChatMessagingController` - **VIEW MODEL**
	* `ChatMessageTableViewCell`
	* `ChatOwnedMessageTableViewCell`
	* `ChatMessageVM`
	
1. `ChatManager` - **MODEL**

	* backend requests for SendBird server
	
	<p float="left">
		<img src="images/chat-people.png" alt="ChatPeopleViewController" height="400">
		<img src="images/chat-messaging.png" alt="ChatMessagingViewController" height="400">
	<p float="left">

## MVVM Architectural Design Pattern

1. **Model**
	- returns the api model in **`struct` that extents to `Codable`**
2. **View**
	- the displayable **`UIViewController`**
	- use VM (model to display the view)
3. **View Model**
	- calls the network api
	- converts the api model in **custom `class` that extents to `NSObject`**

## SwiftUI Conversion

**Project Folder:** `/ DailyTraining-SwiftUI`

<p float="left">
	<img src="images/notifications-bar.png" alt="Notifications Bar" height="400">
	<img src="images/notifications.png" alt="Notifications" height="400">
	<img src="images/notifications-menu.png" alt="Notifications Menu" height="400">
	<img src="images/notifications-alert.png" alt="Notifications Alert" height="400">
</p>

<p float="left">
	<img src="images/channels-chat.png" alt="Channels Chat" height="400">
	<img src="images/channels-people.png" alt="Channels User" height="400">
</p>

<p float="left">
	<img src="images/profile.png" alt="Profile" height="400">
</p>