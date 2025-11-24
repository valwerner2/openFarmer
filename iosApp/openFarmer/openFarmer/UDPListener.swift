//
//  UDPListener.swift
//  openFarmer
//
//  Created by Valentin Werner on 04.10.25.
//

import Network
import Foundation
internal import Combine

enum DuctFanMode: Int, CaseIterable, Identifiable, Decodable, Encodable{
    case humDown = 0
    case humUp
    case tempDown
    case tempUp
    case slave
    
    var id: Int { self.rawValue }
    
    var label: String {
        switch self {
        case .humDown: return "Humidity Down"
        case .humUp: return "Humidity Up"
        case .tempDown: return "Temperature Down"
        case .tempUp: return "Temperature Up"
        case .slave: return "Slave"
        }
    }
}

struct DuctFan: Codable, Identifiable{
    let ip: String
    let mac: String
    let purpose: String
    var name: String
    var info: DuctFanInfo
    
    var id: String { mac }
    
    struct DuctFanInfo: Codable {
        var currentTemp: Double
        var currentHum: Double
        var currentSpeed: Int
        var currentTargetTemp: Double
        var currentTargetHum: Double
        var currentMode: DuctFanMode
        var targetTempDay: Double
        var targetTempNight: Double
        var targetHumDay: Double
        var targetHumNight: Double
        var startNightTime: Int
        var startDayTime: Int
        var startQuietTime: Int
        var startLoudTime: Int
        var maxSpeedLoud: Int
        var maxSpeedQuiet: Int
        var isDayTime: Bool
        var isLoudTime: Bool
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
    
    /*
    init() {
            let exampleFan = DuctFan(
                ip: "192.168.1.42",
                mac: "AA:BB:CC:DD:EE:FF",
                purpose: "Indoor climate control",
                name: "Living Room Fan",
                info: DuctFan.DuctFanInfo(
                    currentTemp: 22.5,
                    currentHum: 45.0,
                    currentSpeed: 22,
                    currentTargetTemp: 23.0,
                    currentTargetHum: 50.0,
                    currentMode: DuctFanMode.tempDown,
                    targetTempDay: 23.0,
                    targetTempNight: 20.0,
                    targetHumDay: 50.0,
                    targetHumNight: 55.0,
                    startNightTime: 22,
                    startDayTime: 6,
                    startQuietTime: 20,
                    startLoudTime: 8,
                    maxSpeedLoud: 100,
                    maxSpeedQuiet: 50,
                    isDayTime: true,
                    isLoudTime: false
                )
            )

            self.ductFans = [exampleFan.mac: exampleFan]
        }
    */
    
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
