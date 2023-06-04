//
//  RegistrationView.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 6/4/23.
//

import SwiftUI

struct RegistrationView: View {
    @ObservedObject var viewModel = RegistrationViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Section(header: Text("Personal Information")) {
                        TextField("First Name", text: $viewModel.firstName)
                        TextField("Last Name", text: $viewModel.lastName)
                        TextField("Email", text: $viewModel.email)
                        SecureField("Password", text: $viewModel.password)
                        DatePicker("Birthdate", selection: $viewModel.birthdate, displayedComponents: .date)
                    }
                    
                    Section(header: Text("Actions")) {
                        Toggle("Send Newsletter", isOn: $viewModel.shouldSendNewsLetter)
                        Stepper("Years", value: $viewModel.yearsOfExperience)
                        Text("\(viewModel.yearsOfExperience) years in Software Development")
                        Link("Privacy Policy", destination: URL(string: "https://www.facebook.com/")!)
                        Link("Term and Conditions", destination: URL(string: "https://www.google.com/")!)
                    }
                }
               
                Button(action: {
                    if viewModel.register() {
                        presentationMode.wrappedValue.dismiss()
                    }
                },
                       label: {
                    Text("Save")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 40)
                        .background(Color.accentColor)
                        .clipShape(Capsule())
                })
                .padding()
                
                Spacer()
            }
            .accentColor(ColorNames.accentColor.getColor())
            .navigationTitle("Registration")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        hideKeyboard()
                    }, label: {
                        Image(systemName: "keyboard")
                    })
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image(systemName: "xmark")
                    })
                }
            }
        }
        
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}
