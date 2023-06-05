//
//  ProfileAvatar.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 5/8/23.
//

import SwiftUI

struct ProfileAvatar: View {
    var user: GitHubUser
    
    var body: some View {
        ZStack(alignment: .bottom) {
            AsyncImage(url: URL(string: user.avatarUrl)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Circle())
            } placeholder: {
                Circle()
                    .foregroundColor(.secondary)
            }
            .frame(width: 150)
            
//            Image("turtlerock")
//                .resizable()
//                .aspectRatio(contentMode: .fit)
//                .clipShape(Circle())
//            .frame(width: 150)

            HStack(spacing: 5) {
                Image(systemName: "star.fill")
                    .foregroundColor(.white)
                    .font(.system(size: 12))
                    .padding(.leading, 10)

                Text(user.login.uppercased())
                    .frame(height: 25)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.trailing, 10)
                    .minimumScaleFactor(0.5)
            }
            .background(.black)
            .cornerRadius(.greatestFiniteMagnitude)
        }
    }
}

struct ProfileAvatar_Previews: PreviewProvider {
    static var previews: some View {
        ProfileAvatar(user: GitHubUser.example())
    }
}
