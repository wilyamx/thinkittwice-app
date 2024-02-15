//
//  FeedsView.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 5/3/23.
//

import SwiftUI

struct FeedsView: View {
    @EnvironmentObject var viewModel: FeedsViewModel
    @EnvironmentObject var notificationsViewModel: NotificationsViewModel
    
    let rowSpacing: CGFloat = 10.0
    
    var body: some View {
        NavigationStack {
            listView
                .wsr_LoadingView(viewModel: viewModel)
                .wsr_ErrorAlertView(viewModel: viewModel)
                .task {
                    if viewModel.breeds.count == 0 {
                        logger.info(message: "listView.task.BEGIN")
                        await viewModel.initializeData(deletePersistedData: true)
                        logger.info(message: "listView.task.END")
                    }
                }
                .refreshable {
                    await viewModel.initializeData(
                        deletePersistedData: true,
                        shuffle: true
                    )
                }
                .navigationTitle(LocalizedStringKey(String.daily_training))
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
                ForEach(viewModel.cats, id: \.id) { cat in
                    if [1, 2].contains(cat.energyLevel) {
                        DailyChallengeView(
                            list: $notificationsViewModel.list,
                            cat: cat
                        )
                    }
                    else if [3, 4].contains(cat.energyLevel) {
                        BrandTrainingView(
                            list: $notificationsViewModel.list,
                            cat: cat
                        )
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
            .environment(\.locale, .init(identifier: "en"))
        
        FeedsView()
            .environmentObject(FeedsViewModel())
            .environment(\.locale, .init(identifier: "fr"))
        
        FeedsView()
            .environmentObject(FeedsViewModel())
            .environment(\.locale, .init(identifier: "ar"))
    }
}
