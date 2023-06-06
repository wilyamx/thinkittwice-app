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
                // checking for persisted data
                if viewModel.cats.isEmpty {
                    if viewModel.breeds.isEmpty {
                        ProgressView()
                            .scaleEffect(2)
                            .task {
                                logger.info(message: "ProgressView.task.BEGIN")
                                let _ = await viewModel.initializeData()
                                logger.info(message: "ProgressView.task.END")
                            }
                    }
                }
                else {
                    List {
                        Group {
                            // display persisted data
                            ForEach(viewModel.cats, id: \.id) { cat in
                                if [1, 2].contains(cat.energyLevel) {
                                    DailyChallengeView(cat: cat)
                                        .padding(.vertical)
                                }
                                else if [3, 4].contains(cat.energyLevel) {
                                    BrandTrainingView(cat: cat)
                                        .padding(.vertical)
                                }
                                else {
                                    NewsView(cat: cat)
                                        .padding(.vertical)
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
                    .padding(5)
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
                                    let _ = await viewModel.deleteAllPersistedData()
                                    logger.info(message: "Button.task.END")
                                }
                            }, label: {
                                Image(systemName: "arrow.clockwise.circle")
                            })
                        }
                    }
                }
                
            }

        }
        
    }
}

struct FeedsView_Previews: PreviewProvider {
    static var previews: some View {
        FeedsView()
            .environmentObject(FeedsViewModel())
    }
}
