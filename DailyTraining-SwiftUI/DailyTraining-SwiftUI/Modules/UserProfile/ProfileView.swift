//
//  ProfileView.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 5/3/23.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var viewModel: ProfileViewModel
    
    var body: some View {
        let _ = Self._printChanges()
        
        NavigationView {
            ZStack {
                Color(UIColor(red: 242/256,
                              green: 242/256,
                              blue: 242/256,
                              alpha: 1.0))
                
                VStack(spacing: 20) {
                    VStack(spacing: 0) {
                        ProfileAvatar()
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

                        ProgressDetails()
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
                            CircularRankIndicator()
                            RankingRateCircularBar()
                        }
                        .background(.clear)
                        .padding(.top)
                        
                        HStack(spacing: 30) {
                            ActivityGauge(value: "80%", dimension: "Rate")
                            ActivityGauge(value: "75%", dimension: "Rate")
                            ActivityGauge(value: "4 mins.", dimension: "Ranking Page All Time")
                        }
                        .background(.clear)
                        .padding(.bottom)
                    }
                    .frame(maxWidth: .infinity)
                    .background(.white)
                    .cornerRadius(20)
                    .padding([.horizontal])
                    
                    Button(action: {
                        self.viewModel.logout()
                    },
                           label: {
                        Text(self.viewModel.logoutButtonAction)
                            .frame(height: 45)
                            .frame(maxWidth: .infinity)
                            .font(.title2)
                            .foregroundColor(.white)
                            .background(.green)
                            .cornerRadius(20)
                    })
                    .padding(.horizontal)
                    
                    Spacer()

                }
            }
            
            .navigationBarTitle("Your Profile", displayMode: .inline)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        logger.log(logKey: .info, category: "ProfileView", message: "Settings!")
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
            .environmentObject(ProfileViewModel())
    }
}
