//
//  HTTPClient.swift
//  openFarmer
//
//  Created by Valentin Werner on 24.11.25.
//


import Foundation

struct HTTPClient {
    func send(url: String, key: String, value: String) {
        // Your endpoint URL
        guard let url = URL(string: url) else {
            print("Invalid URL")
            return
        }
        
        // Create the request
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Create JSON data
        let json: [String: Any] = [key: value]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: json)
            request.httpBody = jsonData
            
            // Create the task
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error: \(error)")
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    print("Invalid response")
                    return
                }
                
                print("Status code: \(httpResponse.statusCode)")
                
                if let data = data, let responseString = String(data: data, encoding: .utf8) {
                    print("Response: \(responseString)")
                }
            }
            
            // Start the task
            task.resume()
            
        } catch {
            print("Error creating JSON: \(error)")
        }
    }
}
