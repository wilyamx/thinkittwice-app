//
//  FeedsView.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 5/3/23.
//

import SwiftUI

struct FeedsView: View {
    @State private var showingAlert = false
    
    var body: some View {
        VStack {
            Button("Show Alert") {
                showingAlert = true
            }
            .alert(isPresented: $showingAlert) {
                Alert(
                    title: Text("Are you sure you want to delete this notification?"),
                    message: Text("There is no undo"),
                    primaryButton: .destructive(Text("Delete")) {
                        print("Deleting...")
                    },
                    secondaryButton: .cancel()
                )
            }
            
            ZStack {
                Circle()
                    .frame(width: 200, height: 200)
                    .foregroundColor(.green)
                Text("1")
                    .foregroundColor(.white)
                    .font(.system(size: 70))
            }
        }
    }
}

struct FeedsView_Previews: PreviewProvider {
    static var previews: some View {
        FeedsView()
    }
}
