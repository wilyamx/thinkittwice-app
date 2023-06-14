//
//  MessagingView.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 5/3/23.
//

import SwiftUI

struct MessagingView: View {
    @State private var selectedChannel: Channel = .chats
    @State private var searchText: String = ""
    
    @State private var pickerSelectedIndex: Int = 0
    
    @StateObject var chatsViewModel: MessagingChatsViewModel = MessagingChatsViewModel()
    @StateObject var usersViewModel: MessagingUsersViewModel = MessagingUsersViewModel()
    
    init() {
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(Color.accentColor)
        UISegmentedControl.appearance().setTitleTextAttributes(
            [.foregroundColor: UIColor.black], for: .selected
        )
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Picker("Choose a channel", selection: $pickerSelectedIndex) {
                    ForEach(Channel.allCases, id: \.self) {
                        channel in
                        Text(channel.rawValue.uppercased())
                            .tag(channel.index)
                    }
                }
                .padding(.horizontal, 15.0)
                .pickerStyle(.segmented)
                .onChange(of: pickerSelectedIndex) { index in
                    if index == 0 {
                        selectedChannel = .chats
                    }
                    else if index == 1 {
                        selectedChannel = .people
                    }
                    logger.info(message: "Channel change: \(selectedChannel)")
                }

                switch selectedChannel {
                case Channel.chats:
                    MessagingChatsView(viewModel: chatsViewModel)
                        .onAppear {
                            chatsViewModel.searchBy(key: searchText)
                        }
                case Channel.people:
                    MessagingUsersView(viewModel: usersViewModel)
                        .onAppear {
                            usersViewModel.searchBy(key: searchText)
                        }
                }
            
                Spacer()
            }
            
            .navigationBarTitle("Channel")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        logger.info(message: "Search!")
                    }, label: {
                        Image(systemName: "magnifyingglass")
                    })
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        logger.info(message: "Settings!")
                    }, label: {
                        Image(systemName: "gearshape")
                    })
                }
            }
            .toolbarBackground(.white, for: .navigationBar)
        }
        .searchable(text: $searchText, prompt: "\(selectedChannel.searchPrompt)")
        .onChange(of: searchText) { searchText in
            logger.info(message: "New search text: \"\(searchText)\" for: \(self.selectedChannel)")
            
            switch selectedChannel {
            case .chats:
                chatsViewModel.searchBy(key: searchText)
            case .people:
                usersViewModel.searchBy(key: searchText)
            }
        }
    }
}

struct MessagingView_Previews: PreviewProvider {
    static var previews: some View {
        MessagingView()
    }
}

enum Channel: String, CaseIterable, Equatable {
    case chats = "chats"
    case people = "people"
    
    var index: Int {
        switch self {
        case .chats: return 0
        case .people: return 1
        }
    }
    
    var searchPrompt: String {
        switch self {
        case .chats: return "Search by chat title"
        case .people: return "Search by user title"
        }
    }
}

enum ChannelType: Int, CaseIterable {
    case topic = 0
    case single = 1
    case group = 2
    case event = 3
}
