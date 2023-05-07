//
//  LoginView.swift
//  
//
//  Created by Alsey Coleman Miller on 4/8/23.
//

import Foundation
import SwiftUI
import Swarm

struct LoginView: View {
    
    @EnvironmentObject
    private var store: Store
    
    @Environment(\.presentationMode)
    private var presentationMode
    
    @State
    private var username: String = ""
    
    @State
    private var password: String = ""
    
    @State
    private var error: String?
    
    @State
    private var task: Task<Void, Never>?
    
    var body: some View {
        VStack(alignment: .center, spacing: 25) {
            TextField("Username", text: $username)
            SecureField("Password", text: $password)
            loginButton
            if task != nil {
                ProgressView()
                    .progressViewStyle(.circular)
            }
            if let error = self.error {
                Text(verbatim: "⚠️" + error)
            }
        }
        .padding(.all)
        .frame(minWidth: 250)
        .onAppear {
            self.username = store.username ?? ""
        }
        .onDisappear {
            task?.cancel()
            task = nil
        }
        .toolbar {
            #if os(iOS)
            ToolbarItemGroup(placement: .navigationBarLeading) {
                cancelButton
            }
            #elseif os(macOS)
            #endif
        }
    }
}

private extension LoginView {
    
    func login() {
        task?.cancel()
        task = Task {
            do {
                try await store.login(
                    username: username,
                    password: password
                )
                dismiss()
            }
            catch is CancellationError {
                
            }
            catch {
                self.task = nil
                self.error = error.localizedDescription
                store.log("Unable to login. \(error.localizedDescription)")
            }
        }
    }
    
    var canLogin: Bool {
        username.isEmpty == false &&
        password.isEmpty == false &&
        task == nil
    }
    
    var cancelButton: some View {
        Button("Cancel") {
            self.dismiss()
        }
    }
    
    var loginButton: some View {
        Button("Login") {
            login()
        }
        .disabled(!canLogin)
    }
    
    func dismiss() {
        self.presentationMode.wrappedValue.dismiss()
    }
}

#if DEBUG && os(iOS)
struct LoginView_Previews: PreviewProvider {
    
    static var previews: some View {
        Text("Background").sheet(isPresented: .constant(true)) {
            NavigationView {
                LoginView()
            }
        }
        .environmentObject(Store())
    }
}
#endif
