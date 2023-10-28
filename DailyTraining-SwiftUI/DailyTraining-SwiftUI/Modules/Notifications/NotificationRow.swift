//
//  NotificationRow.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 5/5/23.
//

import SwiftUI

struct NotificationRow: View {
    
    @Binding var list: [Notification]
    @State private var showingAlert = false
    
    var notification: Notification
    
    var body: some View {
        HStack {
            circularImage
            
            VStack(alignment: .leading, spacing: 10) {
                Text(notification.title)
                    .font(.headline)
                    .minimumScaleFactor(0.9)
                    .lineLimit(1)
                Text(notification.description)
                    .font(.subheadline)
                    .minimumScaleFactor(0.9)
                    .lineLimit(2)
                Text("SAP Analytics | Just Now")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .minimumScaleFactor(0.9)
                    .lineLimit(1)
            }
            
            Spacer()
            
            popoverView
        }
    }
    
    @ViewBuilder
    private var circularImage: some View {
        HStack(spacing: -15) {
            ZStack {
                Circle()
                    .frame(height: 50)
                Text("WR")
                    .foregroundColor(.white)
                    .minimumScaleFactor(0.5)
            }
            
            ZStack {
                Circle()
                    .foregroundColor(Color(UIColor(red: 246/255,
                                              green: 246/255,
                                              blue: 246/255,
                                              alpha: 1.0)))
                    .frame(height: 20)
                Image(systemName: "heart.fill")
                    .foregroundColor(.red)
                    .font(.system(size: 12))
            }
            .padding([.top], -25)
        }
        .padding([.top], -30)
    }
    
    @ViewBuilder
    private var popoverView: some View {
        HStack(alignment: .center, spacing: 20) {
            Menu {
                Button("Approve") { logger.info(message: "Approve!") }
                Button("Reject") { logger.info(message: "Reject!") }
                Button("Forward") { logger.info(message: "Forward!") }
            } label: {
                Image(systemName: "ellipsis")
                    .fontWeight(.bold)
            }
        
            Button {
                showingAlert = true
            } label: {
                Image(systemName: "xmark")
                    .fontWeight(.bold)
            }
            .buttonStyle(.borderless)
            .frame(width: 20)
            .alert(isPresented: $showingAlert) {
                Alert(
                    title: Text("Are you sure you want to delete this notification with id: \(notification.id)?"),
                    message: Text("There is no undo"),
                    primaryButton: .destructive(Text("Delete")) {
                        logger.info(message: "Deleting notification with id: \(notification.id)")
                        list.removeAll(where: { $0.id == notification.id })
                    },
                    secondaryButton: .cancel()
                )
            }
        }
        .padding([.top], -40)
        .navigationTitle("Notifications")
    }
}

struct NotificationRow_Previews: PreviewProvider {
    static var previews: some View {
        List {
            NotificationRow(list: .constant([Notification]()),
                            notification: Notification.example())
        }
    }
}
