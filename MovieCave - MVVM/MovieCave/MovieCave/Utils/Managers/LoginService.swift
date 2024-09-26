//
//  LoginService.swift
//  MovieCave
//
//  Created by Admin on 24.10.23.
//

import Foundation

class LoginService {
    
    private var apiKey: String = "b71a8f3c1d33a24a6e9b6d06b8f4f245"
    private var sessionID: String?

    func createSessionWithLogIn(with username: String, and password: String) {
        let headers = [
            "accept": "application/json",
            "content-type": "application/json",
            "Authorization": Links.staticBearer
        ]
        
        let parameters = [
          "username": username,
          "password": password,
          "request_token": "6a307cac3c5f593de841e6b8560af7c85c50389d"
        ] as [String : String]

        let request = NSMutableURLRequest(url: NSURL(string: "https://api.themoviedb.org/3/authentication/token/validate_with_login")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        do {
            let postData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            request.httpBody = postData as Data
        } catch {
            print("Error catching postData form parameters")
        }
        
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest) { data, response, error in
            if (error != nil) {
                print(error as Any)
            } else {
                let httpResponse = response as? HTTPURLResponse
                print("\(httpResponse)")
            }
        }
        
        dataTask.resume()
    }
    
    func login(username: String, password: String, completion: @escaping (Error?) -> Void) {
        // Create a request to get a request token
        let tokenRequestURL = URL(string: "https://api.themoviedb.org/3/authentication/token/new?api_key=\(apiKey)")!
        
        URLSession.shared.dataTask(with: tokenRequestURL) { [weak self] (data, response, error) in
            guard let self = self else { return }
            
            if let error = error {
                completion(error)
                return
            }
            
            // Parse the request token from the response
            if let data = data,
               let tokenResponse = try? JSONDecoder().decode(TokenResponse.self, from: data),
               let requestToken = tokenResponse.requestToken {
                
                // Create a request to authenticate the user
                let authenticationURL = URL(string: "https://api.themoviedb.org/3/authentication/token/validate_with_login?api_key=\(self.apiKey)")!
                let body = LoginRequestBody(username: username, password: password, requestToken: requestToken)
                
                var request = URLRequest(url: authenticationURL)
                request.httpMethod = "POST"
                request.httpBody = try? JSONEncoder().encode(body)
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                
                URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
                    guard let self = self else { return }
                    
                    if let error = error {
                        completion(error)
                        return
                    }
                    
                    // Parse the session ID from the response
                    if let data = data,
                       let sessionResponse = try? JSONDecoder().decode(SessionResponse.self, from: data),
                       let sessionID = sessionResponse.sessionID {
                        
                        self.sessionID = sessionID
                        completion(nil)
                    } else {
                        let error = NSError(domain: "LoginError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to parse session ID"])
                        completion(error)
                    }
                }.resume()
            } else {
                let error = NSError(domain: "LoginError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to parse request token"])
                completion(error)
            }
        }.resume()
    }

    func logout(completion: @escaping (Error?) -> Void) {
        guard let sessionID = sessionID else {
            let error = NSError(domain: "LogoutError", code: 0, userInfo: [NSLocalizedDescriptionKey: "User is not logged in"])
            completion(error)
            return
        }
        
        // Create a request to delete the session
        let logoutURL = URL(string: "https://api.themoviedb.org/3/authentication/session?api_key=\(apiKey)")!
        var request = URLRequest(url: logoutURL)
        request.httpMethod = "DELETE"
        request.httpBody = try? JSONEncoder().encode(SessionDeleteBody(sessionID: sessionID))
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { [weak self] (_, response, error) in
            guard let self = self else { return }
            
            if let error = error {
                completion(error)
                return
            }
            
            self.sessionID = nil
            completion(nil)
        }.resume()
    }
}

struct TokenResponse: Codable {
    let success: Bool
    let expiresAt: String
    let requestToken: String?

    private enum CodingKeys: String, CodingKey {
        case success
        case expiresAt = "expires_at"
        case requestToken = "request_token"
    }
}

struct LoginRequestBody: Codable {
    let username: String
    let password: String
    let requestToken: String

    private enum CodingKeys: String, CodingKey {
        case username
        case password
        case requestToken = "request_token"
    }
}

struct SessionResponse: Codable {
    let success: Bool
    let sessionID: String?

    private enum CodingKeys: String, CodingKey {
        case success
        case sessionID = "session_id"
    }
}

struct SessionDeleteBody: Codable {
    let sessionID: String

    private enum CodingKeys: String, CodingKey {
        case sessionID = "session_id"
    }
}
