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
    
    private func takeActionHandler(title: String, description: String) {
        if let lastItem = notificationsViewModel.list.first {
            let notification = Notification(
                id: lastItem.id + 1,
                title: title,
                description: description
            )
            notificationsViewModel.list.append(notification)
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
                            cat: cat,
                            takeAction: {
                                takeActionHandler(
                                    title: cat.name,
                                    description: cat.temperament
                                )
                            }
                        )
                    }
                    else if [3, 4].contains(cat.energyLevel) {
                        BrandTrainingView(
                            cat: cat,
                            takeAction: {
                                takeActionHandler(
                                    title: cat.name,
                                    description: cat.breedExplanation)
                            }
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
        let viewModel = FeedsViewModel(mockData: true)
        
        FeedsView()
            .previewDisplayName("en")
            .environmentObject(viewModel)
            .environment(\.locale, .init(identifier: "en"))
        
        FeedsView()
            .previewDisplayName("fr")
            .environmentObject(viewModel)
            .environment(\.locale, .init(identifier: "fr"))
        
        FeedsView()
            .previewDisplayName("ar")
            .environmentObject(viewModel)
            .environment(\.locale, .init(identifier: "ar"))
    }
}
