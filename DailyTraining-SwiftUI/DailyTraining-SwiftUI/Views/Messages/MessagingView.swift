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
    
    init() {
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(Color.accentColor)
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
            .navigationBarTitle("Channel", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        print("[DebugMode] Search!")
                    }, label: {
                        Image(systemName: "magnifyingglass")
                    })
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        print("[DebugMode] Settings!")
                    }, label: {
                        Image(systemName: "gearshape")
                    })
                }
            }
        }
        
        .searchable(text: $searchText)
        .onChange(of: searchText) { searchText in
            print("[Debug] New search text: \(searchText)")
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
