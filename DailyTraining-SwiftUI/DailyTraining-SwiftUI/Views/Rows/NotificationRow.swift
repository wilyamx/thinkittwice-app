//
//  NotificationRow.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 5/5/23.
//

import SwiftUI

struct NotificationRow: View {
    var body: some View {
        HStack() {

            ZStack {
                Circle()
                    .frame(height: 40)
                Text("WR")
                    .foregroundColor(.white)
                    .minimumScaleFactor(0.5)
            }
            .padding([.top], -45)
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Your financial report is overdue")
                    .font(.headline)
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
                Text("Please submit your quarterly figures for Q2 by EOB on August 15")
                    .font(.subheadline)
                    .minimumScaleFactor(0.5)
                    .lineLimit(2)
                Text("SAP Analytics | Just Now")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
            }
            
            Button {
                print("Approve | Reject | Forward")
            } label: {
                Label("", systemImage: "ellipsis")
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .frame(width: 20)
            }
            .padding([.top], -45)
            .buttonStyle(.bordered)
            
            Spacer()
            Button {
                print("Remove")
            } label: {
                Label("", systemImage: "xmark")
                    .fontWeight(.bold)
                    .frame(width: 20)
            }
            .padding([.top], -45)
            .buttonStyle(.bordered)
            .frame(width: 20)
            
            .navigationTitle("Notifications")
            //.padding([.trailing], -30)
        }
    }
}

struct NotificationRow_Previews: PreviewProvider {
    static var previews: some View {
        NotificationRow()
    }
}
