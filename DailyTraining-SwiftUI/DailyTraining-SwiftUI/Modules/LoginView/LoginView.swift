//
//  LoginView.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 5/9/23.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var viewModel: LoginViewModel

    @State private var isPresentedRegistration: Bool = false
    @FocusState private var focusField: Field?
    
    enum Field: Hashable {
        case username
        case password
    }
    
    var body: some View {
        if viewModel.viewState == .populated {
            SplashScreen()
        }
        else {
            ZStack {
                ColorNames.accentColor.colorValue
                    .ignoresSafeArea()
                
                VStack {
                    Spacer()
                    
                    VStack(spacing: 10) {

                        HStack {
                            Text(String.daily_training)
                                .foregroundColor(.black)
                                .font(.title)
                                .fontWeight(.bold)
                            Spacer()
                        }
                        .padding()
                        
                        // Email and Password Entry
                        VStack(alignment: .leading, spacing: 10) {
                            emailInputView
                            passwordInputView
                            loginButton
                        }
                        .padding(.horizontal)
                        
                        // Divider
                        divider
                        
                        // Facebook and Google
                        buttonLink
                    }
                    .background(.white)
                    .cornerRadius(20)
                    .padding()
                    
                    Spacer()
                    
                    // Signin Link
                    signinLink
                }
                
            }
//            .toolbar {
//                ToolbarItemGroup(placement: .keyboard) {
//                    Spacer()
//                    Button("Done") {
//                        focusField = nil
//                    }
//                }
//            }
            .onAppear {
                focusField = .username
            }
            .fullScreenCover(isPresented: $isPresentedRegistration) {
                RegistrationView()
            }
        }
    }
    
    @ViewBuilder
    private var emailInputView: some View {
        ZStack(alignment: .trailing) {
            TextField(String.email, text: $viewModel.username)
                .font(.system(size: 17, weight: .thin))
                .foregroundColor(.black)
                .frame(height: 44)
                .padding(.horizontal, 12)
                .background(ColorNames.accentColor.colorValue.opacity(0.25))
                .cornerRadius(4.0)
                .focused($focusField, equals: .username)
                .disableAutocorrection(true)
                .autocapitalization(.none)
                .keyboardType(.emailAddress)
            
            Button {
                viewModel.username = String.empty
            } label: {
                Image(systemName: .systemName(.xmark))
            }
            .padding(.trailing)
        }
    }
    
    @ViewBuilder
    private var passwordInputView: some View {
        ZStack(alignment: .trailing) {
            if viewModel.isSecured {
                SecureField(String.password, text: $viewModel.password)
                    .font(.system(size: 17, weight: .thin))
                    .foregroundColor(.black)
                    .frame(height: 44)
                    .padding(.horizontal, 12)
                    .background(ColorNames.accentColor.colorValue.opacity(0.25))
                    .cornerRadius(4.0)
                    .focused($focusField, equals: .password)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .onSubmit {
                        viewModel.login()
                    }
            }
            else {
                TextField(String.password, text: $viewModel.password)
                    .font(.system(size: 17, weight: .thin))
                    .foregroundColor(.black)
                    .frame(height: 44)
                    .padding(.horizontal, 12)
                    .background(ColorNames.accentColor.colorValue.opacity(0.25))
                    .cornerRadius(4.0)
                    .focused($focusField, equals: .password)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .onSubmit {
                        viewModel.login()
                    }
            }
            
            Button {
                viewModel.isSecured.toggle()
            } label: {
                Image(systemName: .systemName(viewModel.isSecured ? .eye : .eye_slash))
            }
            .padding(.trailing)
        }
    }
    
    @ViewBuilder
    private var loginButton: some View {
        Button(action: {
            viewModel.login()
        },
               label: {
            Text(String.login)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 40)
                .background(.purple)
                .clipShape(Capsule())
        })
        .padding(.vertical)
        .alert(isPresented: $viewModel.showingAlert) {
            Alert(title: Text(viewModel.errorMessage),
                  dismissButton: .default(Text(String.got_it)) {
                viewModel.password = String.empty
                focusField = .password
                }
            )
        }
    }
    
    @ViewBuilder
    private var divider: some View {
        HStack {
            Rectangle()
                .fill(.black.opacity(0.3))
                .frame(height: 1)
            
            Text(String.or.uppercased())
                .fontWeight(.bold)
                .foregroundColor(.black.opacity(0.3))
            Rectangle()
                .fill(.black.opacity(0.3))
                .frame(height: 1)
        }
        .padding(.horizontal)
    }
    
    @ViewBuilder
    private var buttonLink: some View {
        HStack {
            Link(destination: URL(string: String.facebook_url)!,
                 label: {
                HStack(spacing: 5) {
                    Image(systemName: .systemName(.square_and_arrow_up))
                        .foregroundColor(.white)
                    Text(String.facebook)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                .padding(.vertical, 10)
                .frame(width: (UIScreen.main.bounds.width - 80) / 2)
                .background(.blue)
                .clipShape(Capsule())
            })
            .padding(.bottom)

            Link(destination: URL(string: String.google_url)!,
                 label: {
                HStack(spacing: 5) {
                    Image(systemName: .systemName(.globe))
                        .foregroundColor(.white)
                    Text(String.google)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                .padding(.vertical, 10)
                .frame(width: (UIScreen.main.bounds.width - 80) / 2)
                .background(.red)
                .clipShape(Capsule())
            })
            .padding(.bottom)
            
        }
        .padding(.horizontal)
    }
    
    @ViewBuilder
    private var signinLink: some View {
        HStack {
            Text(String.new_around_here)
                .foregroundColor(Color.black)
            Text(String.sign_in)
                .foregroundColor(Color.red)
                .onTapGesture {
                    isPresentedRegistration = true
                }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(LoginViewModel())
    }
}
