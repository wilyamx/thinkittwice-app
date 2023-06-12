//
//  MessagingUsersView.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 5/3/23.
//

import SwiftUI

struct MessagingUsersView: View {
    @EnvironmentObject var viewModel:MessagingUsersViewModel
    
    let rowSpacing: CGFloat = 5.0
    
    var body: some View {
        VStack {
            List() {
                ForEach(0..<viewModel.list.count, id: \.self) { index in
                    let item = viewModel.list[index]
                    Button {
                        logger.info(message: "selected-item index: \(index), id: \(item.id)")
                    } label: {
                        ChatUserRow(user: item)
                    }
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
                logger.info(message: "onAppear")
                viewModel.getUsers()
            }
        }
    }
}

struct MessagingUsersView_Previews: PreviewProvider {
    static var previews: some View {
        MessagingUsersView()
            .environmentObject(MessagingUsersViewModel())
    }
}
