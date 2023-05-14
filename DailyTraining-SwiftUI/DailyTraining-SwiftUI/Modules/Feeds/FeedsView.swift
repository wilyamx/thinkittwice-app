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
                Text("Breed list")
                    .font(.system(size: 50))
            }
        }
        .onAppear {
            logger(logKey: .info, category: "FeedView", message: "onAppear")
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
