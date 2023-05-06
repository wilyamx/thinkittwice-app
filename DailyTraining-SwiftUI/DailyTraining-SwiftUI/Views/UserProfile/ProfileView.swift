//
//  ProfileView.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 5/3/23.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        NavigationView {
            ZStack {
                Color(UIColor(red: 242/256,
                              green: 242/256,
                              blue: 242/256,
                              alpha: 1.0))
                
                VStack(spacing: 20) {
                    VStack(spacing: 0) {
                        ZStack(alignment: .bottom) {
                            Image("turtlerock")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .clipShape(Circle())
                            .frame(width: 150)

                            HStack(spacing: 5) {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.white)
                                    .font(.system(size: 12))
                                    .padding(.leading, 10)

                                Text("LOREM IPSUM")
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
                        .padding()

                        VStack {
                            Text("William Saberon Rena")
                                .font(.title2)
                                .fontWeight(.bold)
                                .minimumScaleFactor(0.6)
                            Text("Mobile Developer")
                                .foregroundColor(.secondary)
                                .font(.subheadline)
                                .minimumScaleFactor(0.6)
                        }

                        VStack(spacing: 5) {
                            Text("Level 1")
                                .font(.body)
                                .minimumScaleFactor(0.6)
                            ProgressView(value: 0.5)
                                .frame(width: 250)
                            Text("500 / 1 000 points")
                                .foregroundColor(.secondary)
                                .font(.footnote)
                                .minimumScaleFactor(0.6)
                        }
                        .padding()
                    }
                    .frame(maxWidth: .infinity)
                    .background(.white)
                    
                    HStack() {
                        Text("Ranking Your Activity")
                            .font(.body)
                            .fontWeight(.bold)
                            .minimumScaleFactor(0.5)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    .background(.clear)
                    .padding([.horizontal])
                    
                    VStack() {
                        
                        HStack(spacing: 30) {
                            ZStack {
                                Circle()
                                    .frame(width: 150)
                                    .foregroundColor(Color(UIColor(red: 242/256,
                                                                   green: 242/256,
                                                                   blue: 242/256,
                                                                   alpha: 1.0)))
                                
                                VStack(spacing: 5) {
                                    Text("Rank")
                                        .foregroundColor(.secondary)
                                        .minimumScaleFactor(0.75)
                                    Text("11th")
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .minimumScaleFactor(0.75)
                                    Text("/ 30")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                        .minimumScaleFactor(0.75)
                                }
                            }
                            
                            ZStack {
                                Circle()
                                    .frame(width: 150)
                                    .foregroundColor(.white)
                                
                                Circle()
                                    .stroke(
                                        Color(UIColor(red: 242/256,
                                                      green: 242/256,
                                                      blue: 242/256,
                                                      alpha: 1.0)),
                                        lineWidth: 10
                                    )
                                    .frame(width: 140)
                                
                                Circle()
                                    .trim(from: 0, to: 0.25)
                                    .stroke(
                                        Color.accentColor,
                                        style: StrokeStyle(lineWidth: 10,
                                                           lineCap: .round)
                                    )
                                    .rotationEffect(.degrees(-90))
                                    .frame(width: 140)
                                
                                VStack(spacing: 5) {
                                    Text("Combo")
                                        .foregroundColor(.secondary)
                                        .minimumScaleFactor(0.75)
                                    Text("2")
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .minimumScaleFactor(0.75)
                                    Text("Days")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                        .minimumScaleFactor(0.75)
                                }
                            }
                        }
                        .background(.clear)
                        .padding(.top)
                        
                        HStack(spacing: 30) {
                            VStack(alignment: .leading) {
                                Text("80%")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .minimumScaleFactor(0.3)
                                Text("Rate")
                                    .foregroundColor(.secondary)
                                    .minimumScaleFactor(0.5)
                                    .font(.caption)
                            }
                            
                            VStack(alignment: .leading) {
                                Text("70%")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .minimumScaleFactor(0.3)
                                Text("Rate")
                                    .foregroundColor(.secondary)
                                    .minimumScaleFactor(0.5)
                                    .font(.caption)
                            }
                            
                            VStack(alignment: .leading) {
                                Text("4 min.")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .minimumScaleFactor(0.3)
                                Text("Ranking Page All Time")
                                    .foregroundColor(.secondary)
                                    .minimumScaleFactor(0.5)
                                    .font(.caption)
                            }
                        }
                        .background(.clear)
                        .padding(.bottom)
                    }
                    .frame(maxWidth: .infinity)
                    .background(.white)
                    .cornerRadius(20)
                    .padding([.horizontal])
                    
                    Spacer()

                }
            }
            
            .navigationBarTitle("User Profile", displayMode: .inline)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        print("[DebugMode] Settings!")
                    }, label: {
                        Image(systemName: "gearshape")
                    })
                }
            }
        }
        
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
