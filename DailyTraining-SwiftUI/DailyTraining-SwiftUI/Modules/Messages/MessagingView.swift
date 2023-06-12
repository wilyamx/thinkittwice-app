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
    
    init() {
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(Color.accentColor)
        UISegmentedControl.appearance().setTitleTextAttributes(
            [.foregroundColor: UIColor.black], for: .selected
        )
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("Choose a channel", selection: $pickerSelectedIndex) {
                    ForEach(Channel.allCases, id: \.self) {
                        channel in
                        Text(channel.rawValue.uppercased())
                            .tag(channel.index)
                    }
                }
                .padding([.leading, .trailing], 15.0)
                .pickerStyle(.segmented)
                .onChange(of: pickerSelectedIndex) { index in
                    if index == 0 {
                        selectedChannel = .chats
                    }
                    else if index == 1 {
                        selectedChannel = .people
                    }
                }

                switch selectedChannel {
                case Channel.chats:
                    MessagingChatsView()
                        .environmentObject(MessagingChatsViewModel())
                case Channel.people:
                    MessagingUsersView()
                        .environmentObject(MessagingUsersViewModel())
                }
            
                Spacer()
            }
            
            .navigationBarTitle("Channel")
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
        .searchable(text: $searchText)
        .onChange(of: searchText) { searchText in
            logger.info(message: "New search text: \(searchText)")
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
}

enum ChannelType: Int, CaseIterable {
    case topic = 0
    case single = 1
    case group = 2
    case event = 3
}
