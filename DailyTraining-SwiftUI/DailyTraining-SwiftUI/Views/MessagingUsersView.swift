//
//  MessagingUsersView.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 5/3/23.
//

import SwiftUI

struct MessagingUsersView: View {
    var body: some View {
        List(0..<15) { item in
            Image("turtlerock")
                .resizable()
                .scaledToFit()
                .frame(height: 60)
                .clipShape(Circle())
            VStack(alignment: .leading) {
                Text("Topic one")
                    .font(.headline)
                    .fontWeight(.bold)
                Text("Lorem ipsum dolor sit amet")
                    .font(.subheadline)
                    .fontWeight(.regular)
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct MessagingUsersView_Previews: PreviewProvider {
    static var previews: some View {
        MessagingUsersView()
    }
}
