//
//  PhoneLoginView.swift
//  UnderDogToDoList
//
//  Created by Vishal Polepalli on 11/10/22.
//

import SwiftUI
import FirebaseAuth

struct PhoneLoginView: View {
    @StateObject var viewModel: ViewModel
    
    var body: some View {

        VStack() {
            Spacer()
            logo
            Spacer()
            
            if !viewModel.receivedVerificationID {
                phoneTextField
            } else {
               codeTextField
            }
            
            Spacer()
            Spacer()
            button
            Spacer()
        }
        .onTapGesture {
            viewModel.isEditing = false
            viewModel.dismissKeyboard()
        }
    }
    
}

extension PhoneLoginView {
    var logo: some View {
        Image("MainLogo")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(height: 150)
            .padding(.horizontal, 100)
    }
    
    var button: some View {
        Button {
            viewModel.dismissKeyboard()
            //viewModel.mainViewModel.isUserLoggedIn = true
            viewModel.buttonPressed()
            viewModel.isEditing = false
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .fill(viewModel.isButtonDisabled ? .gray : ACCENT_COLOR)
                Text(viewModel.receivedVerificationID ? "Sign In" : "Request Code")
                    .scaledFont(type: .quickSandSemiBold, size: TEXT_FONT_MEDIUM, color: TEXT_COLOR)
                if viewModel.isLoading {
                    ProgressView()
                }
            }
        }
        .frame(height: 50)
        .padding(.horizontal, MARGIN_SCREEN_LEFT_RIGHT)
        .disabled(viewModel.isButtonDisabled)
    }
    
    var codeTextField: some View {
        ZStack() {
            RoundedRectangle(cornerRadius: CORNER_RADIUS).stroke(ACCENT_COLOR)
            
            TextField("", text: $viewModel.verificationCode)
                .scaledFont(type: .quickSandSemiBold, size: TEXT_FONT_LARGE, color: TEXT_COLOR)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, SIZE_PADDING_XS)
                .keyboardType(.phonePad)
                .textContentType(.telephoneNumber)
                .onTapGesture {
                    viewModel.isEditing = true
                }
                .onSubmit {
                    viewModel.isEditing = false
                }
            
            
            if viewModel.verificationCode.isEmpty && !viewModel.isEditing {
                Text("Verification Code: ")
                    .scaledFont(type: .quickSandSemiBold, size: TEXT_FONT_LARGE, color: TEXT_COLOR)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, SIZE_PADDING_XS)
            }
        }
        .frame(height: 50)
        .padding(.horizontal, MARGIN_SCREEN_LEFT_RIGHT)
    }
    
    var phoneTextField: some View {
        ZStack() {
            RoundedRectangle(cornerRadius: CORNER_RADIUS).stroke(ACCENT_COLOR)
            
            TextField("", text: $viewModel.phoneNumber)
                .scaledFont(type: .quickSandSemiBold, size: TEXT_FONT_LARGE, color: TEXT_COLOR)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, SIZE_PADDING_XS)
                .keyboardType(.phonePad)
                .textContentType(.telephoneNumber)
                .onTapGesture {
                    viewModel.isEditing = true
                }
                .onSubmit {
                    viewModel.isEditing = false
                }
            
            
            if viewModel.phoneNumber.isEmpty && !viewModel.isEditing {
                Text("Phone Number: ")
                    .scaledFont(type: .quickSandSemiBold, size: TEXT_FONT_LARGE, color: TEXT_COLOR)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, SIZE_PADDING_XS)
            }
        }
        .frame(height: 50)
        .padding(.horizontal, MARGIN_SCREEN_LEFT_RIGHT)
    }
    
}

extension PhoneLoginView {
    class ViewModel: ObservableObject {
        @Published var phoneNumber = ""
        @Published var verificationCode = ""
        @Published var shouldGoHome = false
        @Published var isEditing = false
        @Published var receivedVerificationID = false
        @Published var isLoading = false
        
        var isButtonDisabled: Bool {
            if !receivedVerificationID && phoneNumber.isEmpty {
                return true
            } else if receivedVerificationID && verificationCode.isEmpty {
                return true
            } else {
                return false
            }
        }
        
        var formattedPhoneNumber: String {
            var formattedPhoneNumber = phoneNumber.replacingOccurrences(of: "(", with: "")
            formattedPhoneNumber = formattedPhoneNumber.replacingOccurrences(of: ")", with: "")
            if !formattedPhoneNumber.hasPrefix("+1") {
                return "+1" + formattedPhoneNumber
            }
            return formattedPhoneNumber
        }
        
        var verificationID = ""
        
        var container: DependencyContainer
        var mainViewModel: MainView.ViewModel
        
        init(container: DependencyContainer, mainViewModel: MainView.ViewModel) {
            self.container = container
            self.mainViewModel = mainViewModel
        }
        
        func dismissKeyboard() {
            UIApplication.shared.endEditing()
        }
        
        func buttonPressed() {
            isLoading = true
            if !receivedVerificationID {
                requestOTP()
            } else {
                signIn()
            }
        }
        
        private func requestOTP() {
            container.firebaseAuthService.requestOTP(phoneNumber: formattedPhoneNumber) { [weak self] (verificationID, error) in
                self?.isLoading = false
                
                if let error = error {
                    print("Error: ", error.localizedDescription)
                    self?.container.alertService.presentGenericError()
                    return
                }
                
                guard let id = verificationID else { return }
                
                self?.verificationID = id
                self?.receivedVerificationID = true
            }
        }
        
        private func signIn() {
            container.firebaseAuthService.signInWithCode(code: verificationCode, verificationId: verificationID) { [weak self] (authDataResult, error) in
                self?.isLoading = false
                
                if let error = error {
                    print("Error: ", error.localizedDescription)
                    self?.container.alertService.presentGenericError()
                    self?.container.firebaseAuthService.signOutUser()
                    return
                }
                self?.getToken()
                self?.container.appState[\.userData.user] = authDataResult?.user
            }
        }
        
        private func getToken() {
            container.firebaseAuthService.getUserIDToken { [weak self] userToken in
                guard let token = userToken else {
                    self?.container.alertService.presentGenericError()
                    return
                }
                self?.container.appState[\.userData.token] = token
                self?.mainViewModel.isUserLoggedIn = true
            }
        }
    }
}
