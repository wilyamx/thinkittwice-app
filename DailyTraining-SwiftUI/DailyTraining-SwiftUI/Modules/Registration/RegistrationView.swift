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
    
    @FocusState private var focusField: Field?
    
    enum Field: Hashable {
        case firstname
        case lastname
        case email
        case password
    }

    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    personalInformationSection
                    actionsSection
                }
                .onAppear {
                    focusField = .firstname
                }
                
                saveButton
                Spacer()
            }
            .accentColor(ColorNames.accentColor.colorValue)
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
    
    @ViewBuilder
    private var personalInformationSection: some View {
        Section(header: Text("Personal Information")) {
            HStack {
                Text("👤")
                TextField("First Name", text: $viewModel.firstName)
                    .focused($focusField, equals: .firstname)
            }
            HStack {
                Text("👤")
                TextField("Last Name", text: $viewModel.lastName)
                    .focused($focusField, equals: .lastname)
            }
            
            HStack {
                Text("✉️")
                TextField("Email", text: $viewModel.email)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .focused($focusField, equals: .email)
            }
            HStack {
                Text("🔑")
                SecureField("Password", text: $viewModel.password)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .focused($focusField, equals: .password)
            }
            HStack {
                Text("🎂")
                DatePicker("Birthdate", selection: $viewModel.birthdate, displayedComponents: .date)
            }
        }
    }
    
    @ViewBuilder
    private var actionsSection: some View {
        Section(header: Text("Actions")) {
            Toggle("Send Newsletter", isOn: $viewModel.shouldSendNewsLetter)
            Stepper("Years", value: $viewModel.yearsOfExperience)
            Text("\(viewModel.yearsOfExperience) years in Software Development")
            Link("Privacy Policy", destination: URL(string: "https://www.facebook.com/")!)
            Link("Term and Conditions", destination: URL(string: "https://www.google.com/")!)
        }
    }
    
    @ViewBuilder
    private var saveButton: some View {
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
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}
