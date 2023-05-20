//
//  ConversationsViewModel.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 5/21/23.
//

import Foundation

final class ConversationsViewModel: ObservableObject {
    @Published var list: [Conversation] = [Conversation]()
    
    func getList() {
        list = [
            Conversation(message: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."),
            Conversation(message: "Nulla malesuada pellentesque elit"),
            Conversation(message: "Magnis dis parturient montes nascetur ridiculus mus mauris"),
            Conversation(message: "Sem fringilla ut morbi"),
            Conversation(message: "Suspendisse interdum"),
            Conversation(message: "Sit amet venenatis urna cursus eget "),
            Conversation(message: "Adipiscing vitae proin sagittis nisl rhoncus mattis"),
            Conversation(message: "Enim eu turpis egestas pretium"),
            Conversation(message: "Elementum curabitur"),
            Conversation(message: "Consequat semper viverra nam libero")
        ]
    }
}

struct Conversation: Hashable {
    let id = UUID()
    let message: String
    
    static func example() -> Conversation {
        return Conversation(message: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.")
    }
}
