//
//  LoginView.swift
//  
//
//  Created by Alsey Coleman Miller on 4/8/23.
//

import Foundation
import SwiftUI
import Swarm

struct LoginView <Content: View>: View {
    
    @EnvironmentObject
    var store: Store
    
    let content: Content
    
    @Binding
    var isPresented: Bool
    
    @Binding
    var error: String?
    
    @State
    private var username: String = ""
    
    @State
    private var password: String = ""
    
    @State
    var task: Task<Void, Never>?
    
    init(
        isPresented: Binding<Bool>,
        error: Binding<String?>,
        content: () -> Content
    ) {
        self._isPresented = isPresented
        self._error = error
        self.content = content()
    }
    
    var body: some View {
        content
        .alert("Login", isPresented: _isPresented) {
            TextField("Username", text: $username)
                //.keyboardType(.asciiCapable)
                .textContentType(.username)
            SecureField("Password", text: $password)
                //.keyboardType(.asciiCapable)
                .textContentType(.password)
            Button("Cancel", role: .cancel) {
                self.task?.cancel()
                self.isPresented = false
            }
            Button("OK") {
                self.task = Task { await login() }
            }
        }
        .onAppear {
            self.username = store.username ?? ""
        }
    }
}

extension LoginView {
    
    func login() async {
        defer { self.password = "" }
        do {
            try await store.login(username: username.lowercased(), password: password)
        }
        catch {
            store.log("Unable to login. \(error)")
            self.error = error.localizedDescription
        }
    }
}
