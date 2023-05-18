//
//  FeedsView.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 5/3/23.
//

import SwiftUI

struct FeedsView: View {
    @EnvironmentObject var viewModel: FeedsViewModel
    
    var body: some View {
        let _ = Self._printChanges()
        
        ZStack {
            if viewModel.isLoading {
                ProgressView()
                    .scaleEffect(2)
            }
            else if viewModel.errorMessage != nil {
                Text("Error")
                    .foregroundColor(.red)
                    .font(.system(size: 50))
            }
            else {
                VStack {
                    Text("Breed list")
                        .font(.system(size: 50))
                    Text("\(viewModel.breeds.count) items")
                        .font(.system(size: 25))
                        .foregroundColor(.red)
                }
            }
        }
        .onAppear {
            logger.log(logKey: .info, category: "FeedView", message: "onAppear")
            viewModel.fetchAllBreeds()
        }
    }
}

struct FeedsView_Previews: PreviewProvider {
    static var previews: some View {
        FeedsView()
            .environmentObject(FeedsViewModel())
    }
}
