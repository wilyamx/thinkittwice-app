//
//  LoginScreen.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 5/9/23.
//

import SwiftUI

struct LoginScreen: View {
    @State private var username: String = ""
    @State private var password: String = ""
    
    @State private var isActive = false
    
    var body: some View {
        if isActive {
            SplashScreen()
        }
        else {
            ZStack {
                Color.green
                    .ignoresSafeArea()
                
                VStack(spacing: 10) {
                    
                    HStack {
                        Text("Login")
                            .font(.title)
                            .fontWeight(.bold)
                        Spacer()
                    }
                    .padding()
                    
                    VStack(alignment: .leading, spacing: 10) {
                        TextField("Username", text: $username)
                            .font(.system(size: 17, weight: .thin))
                            .foregroundColor(.primary)
                            .frame(height: 44)
                            .padding(.horizontal, 12)
                            .background(Color.green.opacity(0.25))
                            .cornerRadius(4.0)
                        
                        SecureField("Password", text: $password)
                            .font(.system(size: 17, weight: .thin))
                            .foregroundColor(.primary)
                            .frame(height: 44)
                            .padding(.horizontal, 12)
                            .background(Color.green.opacity(0.25))
                            .cornerRadius(4.0)
                        
                        Button(action: {
                            isActive = true
                        },
                               label: {
                            Text("Login")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 40)
                                .background(.purple)
                                .clipShape(Capsule())
                        })
                        .padding(.vertical)
                    }
                    .padding(.horizontal)
                    
                    HStack {
                        Rectangle()
                            .fill(.black.opacity(0.3))
                            .frame(height: 1)
                        
                        Text("OR")
                            .fontWeight(.bold)
                            .foregroundColor(.black.opacity(0.3))
                        Rectangle()
                            .fill(.black.opacity(0.3))
                            .frame(height: 1)
                    }
                    .padding(.horizontal)
                    
                    HStack {
                        Button(action: {},
                               label: {
                            HStack(spacing: 5) {
                                Image(systemName: "square.and.arrow.up")
                                    .foregroundColor(.white)
                                Text("Facebook")
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                            }
                            .padding(.vertical, 10)
                            .frame(width: (UIScreen.main.bounds.width - 80) / 2)
                            .background(.blue)
                            .clipShape(Capsule())
                        })
                        .padding(.bottom)
                        
                        Button(action: {},
                               label: {
                            HStack(spacing: 5) {
                                Image(systemName: "globe")
                                    .foregroundColor(.white)
                                Text("Google")
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                            }
                            .padding(.vertical, 10)
                            .frame(width: (UIScreen.main.bounds.width - 80) / 2)
                            .background(.red)
                            .clipShape(Capsule())
                        })
                        .padding(.bottom)
                    }
                    .padding(.horizontal)
                    
                }
                
                .background(.white)
                .cornerRadius(20)
                .padding()
            }
        }
    }
}

struct LoginScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoginScreen()
    }
}
