//
//  LoginSignupView.swift
//  LoginSignupView
//
//  Created by Hao Qin on 8/15/21.
//

import SwiftUI
import Combine

enum AuthState {
  case signUp
  case signIn
}

struct LoginSignupView: View {
  @State private var authState: AuthState = .signIn
  @State private var username = ""
  @State private var email = ""
  @State private var password = ""
  
  @State private var validationError = false
  @State private var requestError = false
  @State private var requestErrorText = ""
  @State var networkOperation: AnyCancellable?
  
  private var isComleted: Bool {
    switch authState {
    case .signUp:
      return username.count > 0 && email.count > 0 && password.count > 0
    case .signIn:
      return username.count > 0 && password.count > 0
    }
  }
  
  var body: some View {
    VStack(spacing: 55) {
      AppTitle()
      
      let columns: [GridItem] = [
        GridItem(.adaptive(minimum: 100, maximum: 120), spacing: 8, alignment: .leading),
        GridItem(.flexible())
      ]
      
      LazyVGrid(columns: columns) {
        Text("Username")
        TextField("Username", text: $username)
          .disableAutocorrection(true)
          .textContentType(.username)
          .autocapitalization(.none)
        
        if authState == .signUp {
          Text("Email")
          TextField("Email", text: $email)
            .disableAutocorrection(true)
            .textContentType(.emailAddress)
            .autocapitalization(.none)
            .keyboardType(.emailAddress)
        }
        
        Text("Password")
        SecureField("Password", text: $password)
          .textContentType(.password)
          .autocapitalization(.none)
      }
      .textFieldStyle(.roundedBorder)
      .alert(isPresented: $validationError) {
        if authState == .signUp {
          return Alert(
            title: Text("Please complete the username, email, and password fields"),
            dismissButton: .cancel(Text("OK")))
        } else {
          return Alert(
            title: Text("Please enter your username and password"),
            dismissButton: .cancel(Text("OK")))
        }
      }
      
      VStack(spacing: 8) {
        Button {
          doAuth()
        } label: {
          Spacer()
          
          Text(authState == .signIn ? "Sign In" : "Sign Up")
            .bold()
            .foregroundColor(.white)
          
          Spacer()
        }
        .padding([.top, .bottom], 10)
        .background(Color.accentGreen.opacity(isComleted ? 1 : 0.2))
        .clipShape(Capsule())
        .alert(isPresented: $requestError) {
          Alert(title: Text(requestErrorText),
                message: Text("Please try again"),
                dismissButton: .cancel(Text("OK")))
        }
        
        Button {
          withAnimation { toggleState() }
        } label: {
          Spacer()
          
          Text(authState == .signIn ? "Sign Up" : "Sign In")
            .bold()
            .foregroundColor(.accentGreen)
          
          Spacer()
        }
        .padding([.top, .bottom], 10)
        .overlay(Capsule().stroke(Color.accentGreen ,lineWidth: 2))
      }
      .padding(.horizontal, 50)
      .accentColor(.green)
      
      Spacer()
        .frame(minHeight: 0, maxHeight: 200)
    }
    .padding(.horizontal)
  }
  
  private func toggleState() {
    authState = (authState == .signIn ? .signUp : .signIn)
  }
  
  private func doAuth() {
    networkOperation?.cancel()
    switch authState {
    case .signUp:
      doSignUp()
    case .signIn:
      doSignIn()
    }
  }
  
  private func doSignIn() {
    guard username.count > 0 && password.count > 0 else {
      validationError = true
      return
    }
    
    let client = APIClient()
    let request = SignInUserRequest(username: username, password: password)
    networkOperation = client.publisherForRequest(request)
      .sink(receiveCompletion: { result in
        handleResult(result)
      }, receiveValue: { _ in })
  }
  
  private func doSignUp() {
    guard username.count > 0 && password.count > 0 && email.count > 0 else {
      validationError = true
      return
    }
    
    let client = APIClient()
    let request = SignUpUserRequest(username: username, email: email, password: password)
    networkOperation = client.publisherForRequest(request)
      .sink(receiveCompletion: { result in
        handleResult(result)
      }, receiveValue: { _ in })
  }
  
  private func handleResult(_ result: Subscribers.Completion<Error>) {
    if case .failure(let error) = result {
      switch error {
      case APIError.requestFailed(let statusCode):
        requestErrorText = "Status code: \(statusCode)"
      case APIError.postProcessingFailed(let innerError):
        requestErrorText = "Error: \(String(describing: innerError))"
      default:
        requestErrorText = "An error occurred: \(String(describing: error))"
      }
    } else {
      requestErrorText = ""
      networkOperation = nil
    }
    requestError = requestErrorText.count > 0
  }
}

struct LoginSignupView_Previews: PreviewProvider {
  static var previews: some View {
    LoginSignupView()
  }
}
