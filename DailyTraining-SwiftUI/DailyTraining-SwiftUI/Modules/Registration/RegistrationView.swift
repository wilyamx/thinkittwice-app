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
            .navigationTitle(LocalizedStringKey(String.registration))
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
            .wsr_LoadingView(viewModel: viewModel)
            .wsr_ErrorAlertView(viewModel: viewModel)
            .onChange(of: viewModel.validatedUser) {
                if viewModel.validatedUser {
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
        
    }
    
    @ViewBuilder
    private var personalInformationSection: some View {
        Section(header: Text(LocalizedStringKey(String.personal_information))) {
            HStack {
                Text(String("👤"))
                TextField(LocalizedStringKey(String.first_name), text: $viewModel.firstName)
                    .focused($focusField, equals: .firstname)
            }
            HStack {
                Text(String("👤"))
                TextField(LocalizedStringKey(String.last_name), text: $viewModel.lastName)
                    .focused($focusField, equals: .lastname)
            }
            
            HStack {
                Text(String("✉️"))
                TextField(LocalizedStringKey(String.email), text: $viewModel.email)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .focused($focusField, equals: .email)
            }
            HStack {
                Text(String("🔑"))
                SecureField(LocalizedStringKey(String.password), text: $viewModel.password)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .focused($focusField, equals: .password)
            }
            HStack {
                Text(String("🎂"))
                DatePicker(LocalizedStringKey(String.birthdate), selection: $viewModel.birthdate, displayedComponents: .date)
            }
        }
    }
    
    @ViewBuilder
    private var actionsSection: some View {
        Section(header: Text(LocalizedStringKey(String.actions))) {
            Toggle(LocalizedStringKey(String.send_newsletter), isOn: $viewModel.shouldSendNewsLetter)
            Stepper(LocalizedStringKey(String.years), value: $viewModel.yearsOfExperience)
            Text(getYearsOfExperience())
            Link(LocalizedStringKey(String.privacy_policy), destination: URL(string: "https://www.facebook.com/")!)
            Link(LocalizedStringKey(String.terms_and_conditions), destination: URL(string: "https://www.google.com/")!)
        }
    }
    
    private func getYearsOfExperience() -> LocalizedStringResource {
        return "\(viewModel.yearsOfExperience) years in Software Development"
    }
    
    @ViewBuilder
    private var saveButton: some View {
        Button(action: {
            viewModel.register()
        },
               label: {
            Text(LocalizedStringKey(String.save))
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
            .previewDisplayName("en")
            .environment(\.locale, .init(identifier: "en"))
        
        RegistrationView()
            .previewDisplayName("fr")
            .environment(\.locale, .init(identifier: "fr"))
        
        RegistrationView()
            .previewDisplayName("ar")
            .environment(\.locale, .init(identifier: "ar"))
    }
}
