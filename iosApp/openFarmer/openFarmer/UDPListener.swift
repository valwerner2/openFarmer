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
        let startQuietTime: Int
        let startLoudTime: Int
        let maxSpeedLoud: Int
        let maxSpeedQuiet: Int
        let isDayTime: Bool
        let isLoudTime: Bool
    }
}

func convertJSONToDuctFan(jsonString: String) -> DuctFan? {
    print("convertJSONToDuctFan")
    
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

import Foundation
import Network

class UDPListener: ObservableObject {
    @Published var isListening = false
    @Published var lastMessage: String = ""
    
    @Published var ductFans: [String : DuctFan] = [:]
    
    private var socketFD: Int32 = -1
    private var queue: DispatchQueue?
    
    
    func startListening() {
        guard socketFD < 0 else { return }

        socketFD = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP)
        guard socketFD >= 0 else {
            print("Failed to create socket")
            return
        }

        // Allow address reuse
        var reuse: Int32 = 1
        setsockopt(socketFD, SOL_SOCKET, SO_REUSEADDR, &reuse, socklen_t(MemoryLayout<Int32>.size))

        // Bind to port 4210
        var addr = sockaddr_in()
        addr.sin_family = sa_family_t(AF_INET)
        addr.sin_port = in_port_t(4210).bigEndian
        addr.sin_addr = in_addr(s_addr: INADDR_ANY.bigEndian)

        let bindResult = withUnsafePointer(to: &addr) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                bind(socketFD, $0, socklen_t(MemoryLayout<sockaddr_in>.size))
            }
        }

        guard bindResult == 0 else {
            perror("bind failed")
            close(socketFD)
            socketFD = -1
            return
        }

        print("UDP socket bound to 0.0.0.0:4210")
        queue = DispatchQueue(label: "udp-listener")
        isListening = true

        queue?.async { [weak self] in
            self?.receiveLoop()
        }
    }

    private func receiveLoop() {
        var buffer = [UInt8](repeating: 0, count: 2048)

        while isListening {
            let bytesRead = recv(socketFD, &buffer, buffer.count, 0)

            if bytesRead > 0 {
                let data = Data(buffer[0..<bytesRead])
                let message = String(data: data, encoding: .utf8) ?? "<binary>"

                DispatchQueue.main.async {
                    self.lastMessage = message
                    if let newFan = convertJSONToDuctFan(jsonString: message){
                        self.ductFans[newFan.mac] = newFan
                    }
                }

                print("Received UDP.")
            }
        }
    }

    func stopListening() {
        isListening = false

        if socketFD >= 0 {
            close(socketFD)
            socketFD = -1
        }
    }
}
