//
//  ProfileView.swift
//  SwarmApp
//
//  Created by Alsey Coleman Miller on 4/8/23.
//

import Foundation
import SwiftUI
import Swarm

struct ProfileView: View {
    
    @EnvironmentObject
    private var store: Store
    
    @State
    private var value: Value = .loading
    
    @State
    private var task: Task<Void, Never>?
    
    var body: some View {
        StateView(
            value: value,
            reload: reload
        )
        .onAppear {
            reload()
        }
        .onDisappear {
            task?.cancel()
        }
    }
}

extension ProfileView {
    
    enum Value {
        
        case loading
        case error(String)
        case result(UserProfile)
    }
    
    func reload() {
        self.value = .loading
        let oldTask = self.task
        task = Task {
            await oldTask?.value
            do {
                let profile = try await store.userProfile()
                self.value = .result(profile)
            }
            catch is CancellationError { }
            catch {
                self.value = .error(error.localizedDescription)
            }
        }
    }
}

extension ProfileView {
    
    struct StateView: View {
        
        let value: Value
        
        let reload: () -> ()
        
        var body: some View {
            content
                .navigationTitle("Profile")
        }
        
        var content: some View {
            switch value {
            case .loading:
                return AnyView(
                    LoadingView()
                )
            case .error(let error):
                return AnyView(
                    ErrorView(error: error, retry: reload)
                )
            case .result(let userProfile):
                return AnyView(
                    ResultView(result: userProfile)
                )
            }
        }
    }
    
    struct ResultView: View {
        
        let result: UserProfile
        
        var body: some View {
            List {
                Section {
                    SubtitleRow(
                        title: Text("Username"),
                        subtitle: Text(verbatim: result.username)
                    )
                }
                Section {
                    if result.role != .user {
                        SubtitleRow(
                            title: Text("Role"),
                            subtitle: Text(verbatim: result.role.description)
                        )
                    }
                    SubtitleRow(
                        title: Text("Email"),
                        subtitle: Text(verbatim: result.email)
                    )
                    SubtitleRow(
                        title: Text("Country"),
                        subtitle: Text(verbatim: result.country)
                    )
                    SubtitleRow(
                        title: Text("Billing"),
                        subtitle: Text(verbatim: result.billingType.description)
                    )
                }
            }
        }
    }
    
    struct LoadingView: View {
        
        var body: some View {
            VStack {
                Text("Loading")
                ProgressView()
                    .progressViewStyle(.circular)
            }
            .padding(20)
        }
    }
    
    struct ErrorView: View {
        
        let error: String
        
        let retry: () -> ()
        
        var body: some View {
            VStack(alignment: .center, spacing: 20) {
                Text(verbatim: "⚠️ " + error)
                Button(action: retry) {
                    Text("Retry")
                }
            }
            .padding(20)
        }
    }
}

