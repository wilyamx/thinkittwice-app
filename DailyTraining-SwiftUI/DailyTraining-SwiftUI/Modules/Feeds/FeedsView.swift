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
            Circle()
                .frame(width: 200, height: 200)
                .foregroundColor(.green)
            Text("1")
                .foregroundColor(.white)
                .font(.system(size: 70))
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
