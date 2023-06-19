//
//  MockData.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 6/19/23.
//

import Foundation

extension Chat {
    static func example1() -> Chat {
        return Chat(messageId: 200,
                    title: "Tellus id interdum velit laoreet",
                    message: "Dis parturient montes nascetur ridiculus mus mauris vitae ultricies. Nec feugiat nisl pretium fusce id velit ut.",
                    avatar: "charleyrivers",
                    unread: 125,
                    type: 1)
    }
    
    static func example2() -> Chat {
        return Chat(messageId: 200,
                    title: "Tellus id interdum velit laoreet",
                    message: "Dis parturient montes nascetur ridiculus mus mauris vitae ultricies. Nec feugiat nisl pretium fusce id velit ut.",
                    avatar: "charleyrivers",
                    unread: 125,
                    type: 2)
    }
    
    static func example3() -> Chat {
        return Chat(messageId: 200,
                    title: "Tellus id interdum velit laoreet",
                    message: "Dis parturient montes nascetur ridiculus mus mauris vitae ultricies. Nec feugiat nisl pretium fusce id velit ut.",
                    avatar: "charleyrivers",
                    unread: 125,
                    type: 3)
    }
}

extension ChatUser {
    static func example() -> ChatUser {
        return ChatUser(userId: 2000,
                        title: "Tincidunt lobortis feugiat",
                        avatar: "turtlerock",
                        name: "Wiley McConway")
    }
}

extension BreedModel {
    static func example1() -> BreedModel {
        return BreedModel(id: "abys",
                          name: "Abyssinian",
                          temperament: "Active, Energetic, Independent, Intelligent, Gentle",
                          description: "The Abyssinian is easy to care for, and a joy to have in your home. They’re affectionate cats and love both people and other animals.",
                        energy_level: 5,
                          hairless: 0,
                          wikipedia_url: "https://en.wikipedia.org/wiki/American_Curl",
                          reference_image_id: "xnsqonbjW",
                          alt_names: "Turkish Cat, Swimming cat"
                     )
    }

    static func example2() -> BreedModel {
        return BreedModel(id: "cypr",
                          name: "Cyprus",
                          temperament: "Affectionate, Social",
                          description: "Loving, loyal, social and inquisitive, the Cyprus cat forms strong ties with their families and love nothing more than to be involved in everything that goes on in their surroundings. They are not overly active by nature which makes them the perfect companion for people who would like to share their homes with a laid-back relaxed feline companion.",
                          energy_level: 4,
                          hairless: 1,
                          wikipedia_url: "https://en.wikipedia.org/wiki/American_Curl",
                          reference_image_id: "xnsqonbjW",
                          alt_names: "Turkish Cat, Swimming cat"
                     )
    }
    
    static func bombayCat() -> BreedModel {
        return BreedModel(id: "bomb",
                          name: "Bombay",
                          temperament: "Affectionate, Dependent, Gentle, Intelligent, Playful",
                          description: "The the golden eyes and the shiny black coa of the Bopmbay is absolutely striking. Likely to bond most with one family member, the Bombay will follow you from room to room and will almost always have something to say about what you are doing, loving attention and to be carried around, often on his caregiver's shoulder.",
                          energy_level: 3,
                          hairless: 0,
                          wikipedia_url: "https://en.wikipedia.org/wiki/American_Curl",
                          reference_image_id: "5iYq9NmT1",
                          alt_names: "Small black Panther"
                     )
    }
}

extension GitHubUser {
    static func placeholder() -> GitHubUser {
        return GitHubUser(avatarUrl: "https://avatars.githubusercontent.com/u/2200483?v=4",
                          login: "GITHUB USER",
                          bio: "Software Developer",
                          name: "GitHub User")
    }
    
    static func example() -> GitHubUser {
        return GitHubUser(avatarUrl: "https://avatars.githubusercontent.com/u/2200483?v=4",
                          login: "WILYAMX",
                          bio: "iOS Developer",
                          name: "William Rena")
    }
}

extension Notification {
    static func example() -> Notification {
        return Notification(id: 1,
                            title: "Your financial report is overdue",
                            description: "Please submit your quarterly figures for Q2 by EOB on August 15")
    }
}
