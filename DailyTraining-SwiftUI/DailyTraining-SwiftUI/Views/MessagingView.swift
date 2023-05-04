//
//  MessagingView.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 5/3/23.
//

import SwiftUI

struct MessagingView: View {
    @State private var selectedChannel: Channel = .chats
    
    init() {
        UISegmentedControl.appearance().selectedSegmentTintColor = .green
        UISegmentedControl.appearance().setTitleTextAttributes(
            [.foregroundColor: UIColor.black], for: .selected
        )
        
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("Choose a channel", selection: $selectedChannel) {
                    ForEach(Channel.allCases, id: \.self) { channel in
                        Text(channel.rawValue.uppercased())
                    }
                }
                .padding([.leading, .trailing], 10.0)
                .pickerStyle(SegmentedPickerStyle())
                               
                switch selectedChannel {
                case .chats:
                    MessagingChatsView()
                case .people:
                    MessagingUsersView()
                }
                
                Spacer()
            }
            .navigationTitle("Channels")
            .accentColor(.green)
        }
    }
}

struct MessagingView_Previews: PreviewProvider {
    static var previews: some View {
        MessagingView()
    }
}

enum Channel: String, CaseIterable {
    case chats = "chats"
    case people = "people"
}

enum ChannelType: Int, CaseIterable {
    case topic = 0
    case single = 1
    case group = 2
    case event = 3
}
