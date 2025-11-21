//
//  UDPListener.swift
//  openFarmer
//
//  Created by Valentin Werner on 04.10.25.
//

import Network
import Foundation
internal import Combine

struct DuctFan: Codable, Identifiable{
    let ip: String
    let mac: String
    let purpose: String
    let name: String
    let info: DuctFanInfo
    
    var id: String { mac }
    
    struct DuctFanInfo: Codable {
        let currentTemp: Double
        let currentHum: Double
        let currentSpeed: Int
        let currentTargetTemp: Double
        let currentTargetHum: Double
        let currentMode: Int
        let targetTempDay: Double
        let targetTempNight: Double
        let targetHumDay: Double
        let targetHumNight: Double
        let startNightTime: Int
        let startDayTime: Int
        let maxSpeedDay: Int
        let maxSpeedNight: Int
        let isDayTime: Bool
    }
}

func convertJSONToDuctFan(jsonString: String) -> DuctFan? {
    guard let jsonData = jsonString.data(using: .utf8) else {
        print("Failed to convert string to data")
        return nil
    }
    
    do {
        let decoder = JSONDecoder()
        let ductFan = try decoder.decode(DuctFan.self, from: jsonData)
        return ductFan
    } catch {
        print("Error decoding JSON: \(error)")
        return nil
    }
}

class UDPListener: ObservableObject {
    private var listener: NWListener?
    private var connection: NWConnection?
    
    // Add @Published properties to conform to ObservableObject
    @Published var isListening = false
    @Published var lastMessage: String = ""
    @Published var ductFans: [DuctFan] = []
    
    func startListening() {
        do {
            // Create UDP listener on port 4210
            let parameters = NWParameters.udp
            parameters.requiredLocalEndpoint = NWEndpoint.hostPort(
                host: .ipv4(.any),
                port: 4210
            )
            
            listener = try NWListener(using: parameters)
            
            listener?.stateUpdateHandler = { [weak self] state in
                switch state {
                case .ready:
                    print("UDP Listener is ready on port 4210")
                    DispatchQueue.main.async {
                        self?.isListening = true
                    }
                case .failed(let error):
                    print("Listener failed with error: \(error)")
                    DispatchQueue.main.async {
                        self?.isListening = false
                    }
                case .cancelled:
                    print("Listener cancelled")
                    DispatchQueue.main.async {
                        self?.isListening = false
                    }
                default:
                    break
                }
            }
            
            listener?.newConnectionHandler = { [weak self] newConnection in
                self?.setupConnection(newConnection)
            }
            
            listener?.start(queue: .main)
            
        } catch {
            print("Failed to create listener: \(error)")
        }
    }
    
    private func setupConnection(_ connection: NWConnection) {
        self.connection = connection
        
        connection.stateUpdateHandler = { state in
            switch state {
            case .ready:
                print("Connection ready")
                self.receiveMessage()
            case .failed(let error):
                print("Connection failed: \(error)")
            case .cancelled:
                print("Connection cancelled")
            default:
                break
            }
        }
        
        connection.start(queue: .main)
    }
    
    private func receiveMessage() {
        connection?.receiveMessage { [weak self] (data, context, isComplete, error) in
            guard let self = self else { return }
            
            if let data = data, !data.isEmpty {
                if let message = String(data: data, encoding: .utf8) {
                    print("Received UDP message: \(message)")
        
                    // Update published properties on main thread
                    DispatchQueue.main.async {
                        self.lastMessage = message
                        if let newFan = convertJSONToDuctFan(jsonString: message){
                            self.ductFans.append(newFan)
                        }
                    }
                } else {
                    print("Received \(data.count) bytes of data")
                }
            }
            
            if let error = error {
                print("Receive error: \(error)")
                return
            }
            
            // Continue listening for next message
            self.receiveMessage()
        }
    }
    
    func stopListening() {
        listener?.cancel()
        connection?.cancel()
        DispatchQueue.main.async {
            self.isListening = false
        }
    }
}
