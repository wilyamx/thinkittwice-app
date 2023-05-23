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
        let _ = Self._printChanges()
        
        NavigationStack {
            List {
                Group {
                    VStack(alignment: .leading, spacing: 20) {
                        HStack {
                            ZStack {
                                Circle()
                                    .foregroundColor(Color(ColorNames.listBackgroundColor.rawValue))
                                Image(systemName: "bolt")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: 20)
                                    .font(.system(size: 30))
                            }
                            .frame(height: 50)
                            .clipShape(Circle())
                            
                            VStack(alignment: .leading) {
                                Text("Daily Challenge")
                                    .fontWeight(.bold)
                                
                                Text("Lorem ipsum dolor sit amet")
                                    .lineLimit(1)
                            }
                        }
                        
                        Button(action: { },
                               label: {
                            Text("TAKE THE CHALLENGE")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 40)
                                .background(.black)
                                .font(.footnote)
                        })
                        .cornerRadius(10)
                    }
                    .padding(.vertical)
 
                    VStack(alignment: .leading, spacing: 20) {
                        Text("BRAND TRAINING")
                            .fontWeight(.bold)
                                                
                        Image("butterfly")
                            .resizable()
                            .frame(height: 200)
                            .cornerRadius(15)
                        
                        Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.")
                            .lineLimit(4)
                        
                        Button(action: { },
                               label: {
                            Text("TAKE THE COURSE")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 40)
                                .background(.black)
                                .font(.footnote)
                        })
                        .cornerRadius(10)
                    }
                    .padding(.vertical)
                    
                    VStack(alignment: .leading, spacing: 20) {
                        Image("peacock")
                            .resizable()
                            .frame(height: 200)
                            .cornerRadius(15)
                            .overlay(alignment: .topLeading) {
                                Text("GREAT NEWS")
                                    .fontWeight(.bold)
                                    .padding([.top, .leading])
                            }
                            .foregroundColor(Color.white)
                            
                        Text("Pretium aenean pharetra magna ac placerat vestibulum")
                            .lineLimit(4)
                        
                        HStack {
                            HStack(spacing: 20) {
                                HStack(spacing: 0) {
                                    Image(systemName: "heart")
                                    Text("12")
                                        .fontWeight(.bold)
                                }
                                
                                HStack(spacing: 0) {
                                    Image(systemName: "bubble.left")
                                    Text("223")
                                        .fontWeight(.bold)
                                }
                            }
                            
                            Spacer()
                            
                            Text("FEB 18TH")
                                .foregroundColor(Color.gray)
                        }
                    }
                    .padding(.vertical)
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
            .background(Color(ColorNames.listBackgroundColor.rawValue))
            .padding(5)
        }
        
        
        
//        ZStack {
//            if viewModel.isLoading {
//                ProgressView()
//                    .scaleEffect(2)
//            }
//            else if viewModel.errorMessage != nil {
//                Text("Error")
//                    .foregroundColor(.red)
//                    .font(.system(size: 50))
//            }
//            else {
//                VStack {
//                    Text("Breed list")
//                        .font(.system(size: 50))
//                    Text("\(viewModel.breeds.count) items")
//                        .font(.system(size: 25))
//                        .foregroundColor(.red)
//                }
//            }
//        }
//        .onAppear {
//            logger.log(logKey: .info, category: "FeedView", message: "onAppear")
//            viewModel.fetchAllBreeds()
//        }
    }
}

struct FeedsView_Previews: PreviewProvider {
    static var previews: some View {
        FeedsView()
            .environmentObject(FeedsViewModel())
    }
}
