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
            reload: reload,
            logout: logout
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
    
    func logout() {
        self.value = .loading
        let oldTask = self.task
        Task {
            await oldTask?.value
            do {
                try await store.logout()
            }
            catch {
                store.log("Unable to logout")
            }
        }
    }
}

extension ProfileView {
    
    struct StateView: View {
        
        let value: Value
        
        let reload: () -> ()
        
        let logout: () -> ()
        
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
                    ErrorView(error: error, retry: reload, logout: logout)
                )
            case .result(let userProfile):
                return AnyView(
                    ResultView(result: userProfile, logout: logout)
                )
            }
        }
    }
    
    struct ResultView: View {
        
        let result: UserProfile
        
        let logout: () -> ()
        
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
                Section {
                    Button(action: logout) {
                        VStack(alignment: .center) {
                            Text("Logout")
                                .foregroundColor(.red)
                        }
                    }
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
        
        let logout: () -> ()
        
        var body: some View {
            VStack(alignment: .center, spacing: 20) {
                Text(verbatim: "⚠️ " + error)
                Button(action: retry) {
                    Text("Retry")
                }
                Spacer()
                Button(action: logout) {
                    VStack(alignment: .center) {
                        Text("Logout")
                            .foregroundColor(.red)
                    }
                }
            }
            .padding(20)
        }
    }
}

#if DEBUG
struct ProfileView_Previews: PreviewProvider {
    
    static let profile = try! JSONDecoder.swarm.decode(UserProfile.self, from: Data(#"{"dt":1680809045,"lt":31.0737,"ln":-115.8783,"al":15,"sp":0,"hd":0,"gj":83,"gs":1,"bv":4060,"tp":40,"rs":-104,"tr":-112,"ts":-9,"td":1680808927,"hp":165,"vp":198,"tf":96682}"#.utf8))
    
    static var previews: some View {
        Group {
            NavigationView {
                ProfileView.StateView(value: .result(profile), reload: { }, logout: { })
            }
        }
    }
}
#endif
