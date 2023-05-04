//
//  MessagingChatsViewModel.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 5/4/23.
//

import Foundation
import SwiftUI

final class MessagingChatsViewModel: ObservableObject {
    @Published var chats: [Chat] = load("ChatsData.json")
}

struct Chat: Hashable, Codable, Identifiable {
    //var id = UUID()
    var id: Int
    var messageId: Int
    var title: String
    var message: String
    var avatar: String
}

func load<T: Decodable>(_ filename: String) -> T {
    let data: Data

    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
    else {
        fatalError("Couldn't find \(filename) in main bundle.")
    }

    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }

    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}
