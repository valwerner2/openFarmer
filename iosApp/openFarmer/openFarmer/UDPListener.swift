//
//  UDPListener.swift
//  openFarmer
//
//  Created by Valentin Werner on 04.10.25.
//
/*
import Foundation
import Network
import Combine

// MARK: - Device Model
struct DeviceModel: Identifiable, Decodable {
    let id = UUID()
    let name: String
    let ip: String
    let mac: String
    let purpose: String
    var showInDashboard: Bool = false

    enum CodingKeys: String, CodingKey {
        case name, ip, mac, purpose
    }
}

@MainActor
final class UDPListener: ObservableObject {
    @Published var devices: [DeviceModel] = []
    private var listener: NWListener?
    private let port: NWEndpoint.Port
    private var currentConnection: NWConnection?
    
    init(port: UInt16) {
        self.port = NWEndpoint.Port(rawValue: port)!
        setupListener()
    }
    
    private func setupListener() {
        do {
            let params = NWParameters.udp
            params.allowFastOpen = true
            params.allowLocalEndpointReuse = true
            params.prohibitExpensivePaths = false
            params.requiredInterfaceType = .wifi
            
            listener = try NWListener(using: params, on: port)
            setupStateHandler()
            setupConnectionHandler()
            
            print("🚀 Starting UDP listener on port \(port)")
            listener?.start(queue: .main)
            
        } catch {
            print("❌ Failed to create listener:", error)
        }
    }
    
    private func setupStateHandler() {
        listener?.stateUpdateHandler = { [weak self] state in
            switch state {
            case .ready:
                print("✅ UDP Listener ready on port \(self?.port ?? 0)")
            case .failed(let error):
                print("❌ Listener failed:", error)
                // Use Task to call MainActor method
                Task { @MainActor in
                    self?.restartListener()
                }
            case .waiting(let error):
                print("⏳ Listener waiting:", error)
            default:
                break
            }
        }
    }
    
    private func setupConnectionHandler() {
        listener?.newConnectionHandler = { [weak self] connection in
            print("🔗 New UDP datagram received")
            
            // Use Task to call MainActor method
            Task { @MainActor in
                self?.currentConnection?.cancel()
                self?.currentConnection = connection
                self?.handleConnection(connection)
            }
        }
    }
    
    private func handleConnection(_ connection: NWConnection) {
        connection.stateUpdateHandler = { [weak self] state in
            switch state {
            case .ready:
                print("📡 Connection ready for receiving")
                Task { @MainActor in
                    self?.receive(on: connection)
                }
            case .failed(let error):
                print("❌ Connection failed:", error)
                connection.cancel()
                Task { @MainActor in
                    self?.currentConnection = nil
                }
            case .cancelled:
                print("🔴 Connection cancelled")
                Task { @MainActor in
                    self?.currentConnection = nil
                }
            default:
                break
            }
        }
        connection.start(queue: .main)
    }
    
    private func receive(on connection: NWConnection) {
        connection.receiveMessage { [weak self] (data, context, isComplete, error) in
            // This completion handler runs on the connection's queue (main)
            if let error = error {
                print("⚠️ Receive error:", error)
                connection.cancel()
                Task { @MainActor in
                    self?.currentConnection = nil
                }
                return
            }
            
            guard let data = data, !data.isEmpty else {
                print("📭 Empty data received")
                connection.cancel()
                Task { @MainActor in
                    self?.currentConnection = nil
                }
                return
            }
            
            print("📦 Received \(data.count) bytes")
            Task { @MainActor in
                self?.processReceivedData(data)
            }
            
            // For UDP, we cancel after receiving one message
            connection.cancel()
            Task { @MainActor in
                self?.currentConnection = nil
            }
        }
    }
    
    private func processReceivedData(_ data: Data) {
        do {
            let device = try JSONDecoder().decode(DeviceModel.self, from: data)
            if !devices.contains(where: { $0.mac == device.mac }) {
                devices.append(device)
                print("✅ Added device: \(device.name) at \(device.ip)")
            }
        } catch {
            print("⚠️ Failed to decode DeviceModel:", error)
            if let text = String(data: data, encoding: .utf8) {
                print("Raw data:", text)
            }
        }
    }
    
    private func restartListener() {
        print("🔄 Restarting listener...")
        currentConnection?.cancel()
        currentConnection = nil
        listener?.cancel()
        listener = nil
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.setupListener()
        }
    }
    
    func stopListening() {
        currentConnection?.cancel()
        currentConnection = nil
        listener?.cancel()
        listener = nil
    }
    
    deinit {
        Task{@MainActor in
            stopListening()
        }
    }
}
*/
