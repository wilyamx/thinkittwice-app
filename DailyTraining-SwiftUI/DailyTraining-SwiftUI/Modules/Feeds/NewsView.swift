//
//  NewsView.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 6/6/23.
//

import SwiftUI

struct NewsView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Image("peacock")
                .resizable()
                .frame(height: 200)
                .cornerRadius(15)
                .overlay(alignment: .topLeading) {
                    VStack(alignment: .leading) {
                        Text("MARKET NEWS")
                            .fontWeight(.bold)
                            .padding([.top, .leading])
                        
                        Spacer()
                        
                        Text("Pretium aenean pharetra magna ac in andf placerat vestibulum. Pretium aenean pharetra magna pharetra magna ac placerat. In the most holy ground and to the whole world.")
                            .lineLimit(4)
                            .padding([.leading, .trailing, .bottom])
                    }
                }
                .foregroundColor(Color.white)
                
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
    }
}

struct NewsView_Previews: PreviewProvider {
    static var previews: some View {
        NewsView()
    }
}
