//
//  WSRErrorAlertView.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 11/1/23.
//

import SwiftUI

struct WSRErrorAlertView: View {
    @Binding var showErrorAlert: Bool
    
    var errorAlertType: WSRErrorAlertType
    var closeErrorAlert: () -> Void
    
    var body: some View {
        ZStack {
            VStack {
                VStack(spacing:20) {
                    ZStack {
                        Circle()
                            .foregroundColor(.red)
                            .frame(height: 50)
                        Image(systemName: errorAlertType.getIconSystemName())
                            .foregroundColor(.white)
                            .font(.system(size: 25))
                            .bold()
                    }
                    
                    Text(errorAlertType.getTitle())
                        .font(.title2).bold()
                        .minimumScaleFactor(0.9)
                        .lineLimit(1)
                    Text(errorAlertType.getMessage())
                        .font(.subheadline)
                        .minimumScaleFactor(0.9)
                        .lineLimit(1)
                        .foregroundColor(.gray)
                    
                    Button(action: {
                        showErrorAlert.toggle()
                        closeErrorAlert()
                    },
                           label: {
                        Text(errorAlertType.getActionButtonText())
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(.black)
                            .font(.headline)
                    })
                    .cornerRadius(10)
                    .padding(.bottom)
                }
                .padding(20)
                .background(Color.bgColor)
                .cornerRadius(15)
            }
            .padding(30)
            .background(.clear)
        }
    }
}

struct WSRErrorAlertView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.gray
            WSRErrorAlertView(
                showErrorAlert: .constant(true),
                errorAlertType: .domain,
                closeErrorAlert: {
                    logger.info(message: "Close!")
                })
        }
    }
}
