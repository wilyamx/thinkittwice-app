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
        NavigationStack {
            VStack(spacing: 20) {
                userInfoView
                rankingActivityView
                gaugesView
                logoutButton
                Spacer()
            }
            .wsr_LoadingView(viewModel: viewModel)
            .wsr_ErrorAlertView(viewModel: viewModel)
            .navigationBarTitle(
                LocalizedStringKey(String.your_profile),
                displayMode: .inline
            )
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        viewModel.showActiveEmail()
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
    
    @ViewBuilder
    private var userInfoView: some View {
        VStack(spacing: 0) {
            ProfileAvatar(user: viewModel.userDetails ?? GitHubUser.placeholder())
                .padding()
            // Name
            nameView
            ProgressDetails()
                .padding()
        }
        .frame(maxWidth: .infinity)
        .background(.white)
    }
    
    @ViewBuilder
    private var nameView: some View {
        VStack {
            Text(viewModel.userDetails?.name ?? GitHubUser.placeholder().name)
                .font(.title2)
                .fontWeight(.bold)
                .minimumScaleFactor(0.8)
            Text(viewModel.userDetails?.bio ?? GitHubUser.placeholder().bio)
                .foregroundColor(.secondary)
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .minimumScaleFactor(0.8)
        }
    }
    
    @ViewBuilder
    private var rankingActivityView: some View {
        HStack {
            Text(LocalizedStringKey(String.ranking_your_activity))
                .font(.body)
                .fontWeight(.bold)
                .minimumScaleFactor(0.5)
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(.clear)
        .padding([.horizontal])
    }
    
    @ViewBuilder
    private var gaugesView: some View {
        VStack() {
            HStack(spacing: 30) {
                CircularRankIndicator()
                RankingRateCircularBar()
            }
            .background(.clear)
            .padding(.top)
            
            HStack(spacing: 30) {
                ActivityGauge(value: "80%",
                              dimension: LocalizedStringKey(String.rate))
                ActivityGauge(value: "75%",
                              dimension: LocalizedStringKey(String.rate))
                ActivityGauge(
                    value: "40 \(String.mins.localizedString())",
                    dimension: LocalizedStringKey(String.ranking_page_all_time)
                )
            }
            .background(.clear)
            .padding(.bottom)
        }
        .frame(maxWidth: .infinity)
        .background(.white)
        .cornerRadius(20)
        .padding([.horizontal])
    }
    
    @ViewBuilder
    private var logoutButton: some View {
        Button(action: {
            self.viewModel.logout()
        },
               label: {
            Text(self.viewModel.logoutButtonAction)
                .wsr_ButtonLabel(bgColor: .green, fgColor: .white, font: .title2)
        })
        .padding(.horizontal)
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = ProfileViewModel(userDetails: GitHubUser.example())
        
        ProfileView()
            .previewDisplayName("en")
            .environmentObject(viewModel)
            .environment(\.locale, .init(identifier: "en"))
        
        ProfileView()
            .previewDisplayName("fr")
            .environmentObject(viewModel)
            .environment(\.locale, .init(identifier: "fr"))
        
        ProfileView()
            .previewDisplayName("ar")
            .environmentObject(viewModel)
            .environment(\.locale, .init(identifier: "ar"))
    }
}
