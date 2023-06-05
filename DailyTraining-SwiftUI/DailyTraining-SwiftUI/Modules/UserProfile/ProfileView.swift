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
                ColorNames.listBackgroundColor.colorValue
                
                VStack(spacing: 20) {
                    VStack(spacing: 0) {
                        ProfileAvatar(user: viewModel.userDetails ?? GitHubUser.placeholder())
                            .padding()

                        VStack {
                            Text(viewModel.userDetails?.name ?? GitHubUser.placeholder().name)
                                .font(.title2)
                                .fontWeight(.bold)
                                .minimumScaleFactor(0.6)
                            Text(viewModel.userDetails?.bio ?? GitHubUser.placeholder().bio)
                                .foregroundColor(.secondary)
                                .font(.subheadline)
                                .multilineTextAlignment(.center)
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
                        logger.info(message: "Settings!")
                    }, label: {
                        Image(systemName: "gearshape")
                    })
                }
            }
            .onAppear {
                logger.info(message: "onAppear!")
            }
            .task {
                logger.info(message: "task!")
                
                await viewModel.getUserDetails()
                
                logger.info(message: "user details complete!")
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
