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
        if viewModel.isValidCredentials {
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
                            Text("Daily Training")
                                .font(.title)
                                .fontWeight(.bold)
                            Spacer()
                        }
                        .padding()
                        
                        VStack(alignment: .leading, spacing: 10) {
                            ZStack(alignment: .trailing) {
                                TextField("Email", text: $viewModel.username)
                                    .font(.system(size: 17, weight: .thin))
                                    .foregroundColor(.primary)
                                    .frame(height: 44)
                                    .padding(.horizontal, 12)
                                    .background(ColorNames.accentColor.colorValue.opacity(0.25))
                                    .cornerRadius(4.0)
                                    .focused($focusField, equals: .username)
                                    .disableAutocorrection(true)
                                    .autocapitalization(.none)
                                    .keyboardType(.emailAddress)
                                
                                Button {
                                    viewModel.username = ""
                                } label: {
                                    Image(systemName: "xmark")
                                }
                                .padding(.trailing)
                            }
                            
                            ZStack(alignment: .trailing) {
                                if viewModel.isSecured {
                                    SecureField("Password", text: $viewModel.password)
                                        .font(.system(size: 17, weight: .thin))
                                        .foregroundColor(.primary)
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
                                    TextField("Password", text: $viewModel.password)
                                        .font(.system(size: 17, weight: .thin))
                                        .foregroundColor(.primary)
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
                                    Image(systemName: viewModel.isSecured ? "eye" : "eye.slash")
                                }
                                .padding(.trailing)
                            }
                            
                            Button(action: {
                                viewModel.login()
                            },
                                   label: {
                                Text("Login")
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 40)
                                    .background(.purple)
                                    .clipShape(Capsule())
                            })
                            .padding(.vertical)
                            .alert(isPresented: $viewModel.showingAlert) {
                                Alert(title: Text("Invalid credentials"),
                                      dismissButton: .default(Text("Got it!")) {
                                    viewModel.password = ""
                                    focusField = .password
                                    }
                                )
                            }
                        }
                        .padding(.horizontal)
                        
                        HStack {
                            Rectangle()
                                .fill(.black.opacity(0.3))
                                .frame(height: 1)
                            
                            Text("OR")
                                .fontWeight(.bold)
                                .foregroundColor(.black.opacity(0.3))
                            Rectangle()
                                .fill(.black.opacity(0.3))
                                .frame(height: 1)
                        }
                        .padding(.horizontal)
                        
                        HStack {
                            Link(destination: URL(string: "https://www.facebook.com/")!,
                                 label: {
                                HStack(spacing: 5) {
                                    Image(systemName: "square.and.arrow.up")
                                        .foregroundColor(.white)
                                    Text("Facebook")
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                }
                                .padding(.vertical, 10)
                                .frame(width: (UIScreen.main.bounds.width - 80) / 2)
                                .background(.blue)
                                .clipShape(Capsule())
                            })
                            .padding(.bottom)

                            Link(destination: URL(string: "https://www.google.com/")!,
                                 label: {
                                HStack(spacing: 5) {
                                    Image(systemName: "globe")
                                        .foregroundColor(.white)
                                    Text("Google")
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
                    
                    .background(.white)
                    .cornerRadius(20)
                    .padding()
                    
                    Spacer()
                    
                    HStack {
                        Text("New around here?")
                        Text("Sign in")
                            .foregroundColor(Color.red)
                            .onTapGesture {
                                isPresentedRegistration = true
                            }
                    }
                    
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
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(LoginViewModel())
    }
}
