//
//  FeedsView.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 5/3/23.
//

import SwiftUI

struct FeedsView: View {
    @EnvironmentObject var viewModel: FeedsViewModel
    
    let rowSpacing: CGFloat = 10.0
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.white
                
                if viewModel.viewState == .error {
                    if viewModel.showErrorAlert && viewModel.errorAlertType != .none {
                        WSRErrorAlertView(
                            showErrorAlert: $viewModel.showErrorAlert,
                            errorAlertType: viewModel.errorAlertType,
                            closeErrorAlert: {
                                viewModel.resetErrorStatuses()
                            })
                    }
                    else {
                        RetryView(message: viewModel.errorMessage)
                    }
                }
                // checking for persisted data
                else if viewModel.cats.isEmpty {
                    if viewModel.breeds.isEmpty {
                        ProgressView()
                            .scaleEffect(2)
                            .task {
                                logger.info(message: "ProgressView.task.BEGIN")
                                await viewModel.initializeData()
                                logger.info(message: "ProgressView.task.END")
                            }
                    }
                }
                else {
                    listView
                }
                
            }
            .navigationTitle("Daily Training")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        logger.log(category: .info, message: "Settings!")
                    }, label: {
                        Image(systemName: "slider.horizontal.3")
                    })
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        Task {
                            logger.info(message: "Button.task.BEGIN")
                            await viewModel.deleteAllPersistedData()
                            logger.info(message: "Button.task.END")
                        }
                    }, label: {
                        Image(systemName: "arrow.clockwise.circle")
                    })
                }
            }
            
        }
        
    }
    
    @ViewBuilder
    private var listView: some View {
        List {
            Group {
                // display persisted data
                ForEach(viewModel.cats.shuffled(), id: \.id) { cat in
                    if [1, 2].contains(cat.energyLevel) {
                        DailyChallengeView(cat: cat)
                    }
                    else if [3, 4].contains(cat.energyLevel) {
                        BrandTrainingView(cat: cat)
                    }
                    else {
                        NewsView(cat: cat)
                    }
                }
            }
            .listRowSeparator(.hidden)
            .listRowBackground(
                RoundedRectangle(cornerRadius: 15)
                    .padding(EdgeInsets(top: rowSpacing,
                                        leading: rowSpacing,
                                        bottom: rowSpacing,
                                        trailing: rowSpacing))
                    .background(.clear)
                    .foregroundColor(.white)
            )
        }
        .listStyle(.plain)
        .background(ColorNames.listBackgroundColor.colorValue)
        .buttonStyle(.borderless)
    }
    
}

struct FeedsView_Previews: PreviewProvider {
    static var previews: some View {
        FeedsView()
            .environmentObject(FeedsViewModel())
    }
}
