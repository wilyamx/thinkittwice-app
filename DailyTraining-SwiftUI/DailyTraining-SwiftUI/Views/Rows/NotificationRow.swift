//
//  NotificationRow.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 5/5/23.
//

import SwiftUI

struct NotificationRow: View {
    @State private var showingAlert = false
    
    var body: some View {
        HStack() {

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
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Your financial report is overdue")
                    .font(.headline)
                    .minimumScaleFactor(0.9)
                    .lineLimit(1)
                Text("Please submit your quarterly figures for Q2 by EOB on August 15")
                    .font(.subheadline)
                    .minimumScaleFactor(0.9)
                    .lineLimit(2)
                Text("SAP Analytics | Just Now")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .minimumScaleFactor(0.9)
                    .lineLimit(1)
            }
            
            HStack(alignment: .center, spacing: 20) {
                Menu {
                    Button("Approve") { print("[DebugMode] Approve!") }
                    Button("Reject") { print("[DebugMode] Reject!") }
                    Button("Forward") { print("[DebugMode] Forward!") }
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
                        title: Text("Are you sure you want to delete this notification?"),
                        message: Text("There is no undo"),
                        primaryButton: .destructive(Text("Delete")) {
                            print("[DebugMode] Deleting notification...")
                        },
                        secondaryButton: .cancel()
                    )
                }
            }
            .padding([.top], -40)
            
            .navigationTitle("Notifications")
        }
    }
}

struct NotificationRow_Previews: PreviewProvider {
    static var previews: some View {
        NotificationRow()
    }
}
