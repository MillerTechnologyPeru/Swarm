//
//  ScanCodeView.swift
//  SwarmApp
//
//  Created by Alsey Coleman Miller on 5/7/23.
//

import Foundation
import SwiftUI
import Swarm
#if os(iOS)
import CodeScanner
#endif

struct ScanCodeView: View {
    
    @EnvironmentObject
    private var store: Store
    
    @State
    private var state: ScanState = .camera
    
    @State
    private var task: Task<Void, Never>?
    
    let result: (Result) -> ()
    
    var body: some View {
        stateView
            .navigationTitle("Scan")
            .onDisappear {
                retry()
            }
    }
}

extension ScanCodeView {
    
    enum Result {
        
        case registered(DeviceInformation)
    }
}

private extension ScanCodeView {
    
    func retry() {
        task?.cancel()
        task = nil
        self.state = .camera
    }
    
    #if os(iOS)
    func scanResult(_ result: Swift.Result<ScanResult, ScanError>) {
        switch result {
        case let .success(scanResult):
            self.scanResult(scanResult.string)
        case let .failure(error):
            self.state = .error(error.localizedDescription)
        }
    }
    #endif
    
    func scanResult(_ string: String) {
        guard let code = try? QRCode(from: string) else {
            self.state = .error("Invalid QR Code")
            return
        }
        self.state = .loading(code)
        // load value
        self.task = Task {
            do {
                let result = try await self.process(code)
                self.state = .camera
                self.result(result)
            } catch {
                self.store.log("Unable to process QR code. \(error.localizedDescription)")
                self.state = .error(error.localizedDescription)
            }
        }
    }
    
    func process(_ code: QRCode) async throws -> Result {
        #if os(iOS) && targetEnvironment(simulator) && DEBUG
        return .registered(mockDevice)
        #else
        let device = try await store.register(code)
        return .registered(device)
        #endif
    }
    
    var stateView: some View {
        switch state {
        case .camera:
            #if os(iOS) && !targetEnvironment(simulator)
            return AnyView(CameraView(completion: scanResult))
            #elseif DEBUG
            return AnyView(
                Button(action: {
                    let code = try! QRCode(authenticationCode: "12345").encode()
                    scanResult(code)
                }, label: {
                    Image(systemSymbol: .qrcode)
                        .font(.system(size: 50))
                        .foregroundColor(.gray)
                })
                .buttonStyle(.plain)
            )
            #else
            return AnyView(Text("Use iOS device to scan."))
            #endif
        case let .loading(code):
            return AnyView(
                LoadingView(
                    code: code
                )
            )
        case let .error(error):
            return AnyView(
                ErrorView(
                    error: error,
                    retry: retry
                )
            )
        }
    }
}

extension ScanCodeView {
    
    enum ScanState {
        case camera
        case loading(QRCode)
        case error(String)
    }
}

extension ScanCodeView {
    
    #if os(iOS)
    struct CameraView: View {
        
        let completion: ((Swift.Result<ScanResult, ScanError>) -> ())
        
        @State
        private var isActive = false
        
        var body: some View {
            content
            .onAppear {
                isActive = true
            }
            .onDisappear {
                isActive = false
            }
        }
        
        private var content: some View {
            if isActive {
                return AnyView(
                    CodeScannerView(codeTypes: [.qr], scanMode: .manual, completion: completion)
                )
            } else {
                return AnyView(
                    Image(systemSymbol: .cameraFill)
                )
            }
        }
    }
    #endif
    
    struct LoadingView: View {
        
        let code: QRCode
        
        var body: some View {
            VStack(alignment: .center, spacing: 16) {
                Text("Registering device")
                ProgressView()
                    .progressViewStyle(.circular)
            }
        }
    }
    
    struct ErrorView: View {
        
        let error: String
        
        let retry: () -> ()
        
        var body: some View {
            VStack(alignment: .center, spacing: 16) {
                Image(systemSymbol: .exclamationmarkOctagonFill)
                    .symbolRenderingMode(.multicolor)
                Text("Error")
                Text(verbatim: error)
                Button(action: retry) {
                    Text("Retry")
                }
            }
        }
    }
}

#if DEBUG

extension ScanCodeView {
    
    var mockDevice: DeviceInformation {
        let responseJSON = #"""
            [
              {
                "deviceType": 1,
                "deviceId": 1234,
                "deviceName": "My Swarm Device",
                "comments": "Tracker",
                "hiveCreationTime": "2022-10-04T18:46:02",
                "hiveFirstheardTime": "2023-03-26T14:30:51",
                "hiveLastheardTime": "2023-04-06T20:00:35",
                "firmwareVersion": "v3.0.1",
                "hardwareVersion": "",
                "lastTelemetryReportPacketId": 53906350,
                "lastHeardByDeviceType": 3,
                "lastHeardByDeviceId": 1530,
                "counter": 0,
                "dayofyear": 0,
                "lastHeardCounter": 98,
                "lastHeardDayofyear": 96,
                "lastHeardByGroundstationId": 248872,
                "status": 0,
                "twoWayEnabled": false,
                "dataEncryptionEnabled": true,
                "metadata": {
                  "device:type": "Other"
                }
              }
            ]
            """#
        let device = try! JSONDecoder.swarm.decode([DeviceInformation].self, from: Data(responseJSON.utf8)).first!
        return device
    }
}

#endif
