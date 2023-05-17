//
//  MessagingChatsView.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 5/3/23.
//

import SwiftUI

struct MessagingChatsView: View {
    
    @EnvironmentObject var viewModel: MessagingChatsViewModel
    
    let rowSpacing: CGFloat = 5.0
    
    var body: some View {
        let _ = Self._printChanges()
        
        VStack {
            Text("Chat Listing")
            
            List() {
                ForEach(viewModel.list) { chat in
                    ChatRow(chat: chat)
                }
                .listRowBackground(
                    RoundedRectangle(cornerRadius: 5)
                        .padding(EdgeInsets(top: rowSpacing,
                                            leading: rowSpacing,
                                            bottom: rowSpacing,
                                            trailing: rowSpacing))
                        .background(.clear)
                        .foregroundColor(.white)
                    
                )
                .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
            .padding(.all, 5)
            .background(Color(UIColor(red: 246/255,
                                      green: 246/255,
                                      blue: 246/255,
                                      alpha: 1.0)))
            .onAppear {
                logger(logKey: .info, any: viewModel, message: "onAppear")
                viewModel.getChats()
            }
        }
    }
}

struct MessagingChatsView_Previews: PreviewProvider {
    static var previews: some View {
        MessagingChatsView()
            .environmentObject(MessagingChatsViewModel())
    }
}
