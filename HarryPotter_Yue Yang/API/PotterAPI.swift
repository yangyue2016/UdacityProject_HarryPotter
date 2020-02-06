//
//  PotterAPI.swift
//  HarryPorter_Yue Yang
//
//  Created by MacAir11 on 2020/1/22.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation

class PotterAPI {
    
    private init() {}
    static let shared = PotterAPI()
    
    static let apiKey = "$2a$10$4AZsY282arYvJz24eZOiMuUlRk6RXRqVgeK6rihMOIf.1wVDqNtLq"
    
    private let urlSession = URLSession.shared
    
    enum Endpoints {
        static let base = "https://www.potterapi.com/v1/"
        static let apiKeyParam = "?key=\(PotterAPI.apiKey)"
        
        case getRandomHouse
        case getHouses
        case getHouse(String)
        case getCharacter(String)
        
        var stringValue: String {
            switch self {
            case .getRandomHouse: return Endpoints.base + "sortingHat"
            case .getHouses: return Endpoints.base + "houses" + Endpoints.apiKeyParam
            case .getHouse(let houseID): return Endpoints.base + "houses" + "/\(houseID)" + Endpoints.apiKeyParam
            case .getCharacter(let characterID): return Endpoints.base + "characters" + "/\(characterID)" + Endpoints.apiKeyParam
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }

    func getRandomHouse(completion: @escaping (Bool, Error?) -> Void) {
        //let movieURL = PotterAPI.Endpoints.getRandomHouse.url
        print(PotterAPI.Endpoints.getRandomHouse.url)
        URLSession.shared.dataTask(with: PotterAPI.Endpoints.getRandomHouse.url) { (data, response, error) in
            if let error = error {
                completion(false, error)
                return
            }
            
            guard let data = data else {
                completion(false, error)
                return
            }
            
            print("data:", data)
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                
                print("json:", json)
                completion(true, nil)
                
            }catch{
                
                print(error)
                completion(false, error)
            }
            
        }.resume()
    }
    
    func getHouses(completion: @escaping(_ houses: [[String: Any]]?, _ error: Error?) -> ()) {
        let request = URLRequest(url: PotterAPI.Endpoints.getHouses.url)
        urlSession.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                let error = NSError(domain: dataErrorDomain, code: DataErrorCode.networkUnavailable.rawValue, userInfo: nil)
                completion(nil, error)
                return
            }
            
            do {
                guard let output = try? JSONSerialization.jsonObject(with: data, options: []) as! [[String: Any]] else {
                    throw NSError(domain: dataErrorDomain, code: DataErrorCode.wrongDataFormat.rawValue, userInfo: nil)
                }
                completion(output, nil)
            } catch {
                completion(nil, error)
            }
            
            }.resume()
        
    }
    
    
    func getHouse(houseID:String, completion: @escaping(_ house: NSArray?, _ error: Error?) -> ()) {
        let request = URLRequest(url: PotterAPI.Endpoints.getHouse(houseID).url)
        urlSession.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                let error = NSError(domain: dataErrorDomain, code: DataErrorCode.networkUnavailable.rawValue, userInfo: nil)
                completion(nil, error)
                return
            }
            
            do {
                guard let output = try? JSONSerialization.jsonObject(with: data, options: []) as! NSArray else {
                    throw NSError(domain: dataErrorDomain, code: DataErrorCode.wrongDataFormat.rawValue, userInfo: nil)
                }
                completion(output, nil)
            } catch {
                completion(nil, error)
            }
            
            }.resume()
        
    }
    
    func getCharacter(characterID:String, completion: @escaping(_ character: [String: Any]?, _ error: Error?) -> ()) {
        let request = URLRequest(url: PotterAPI.Endpoints.getCharacter(characterID).url)
        urlSession.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                let error = NSError(domain: dataErrorDomain, code: DataErrorCode.networkUnavailable.rawValue, userInfo: nil)
                completion(nil, error)
                return
            }
            
            do {
                guard let output = try? JSONSerialization.jsonObject(with: data, options: []) as! [String: Any] else {
                    throw NSError(domain: dataErrorDomain, code: DataErrorCode.wrongDataFormat.rawValue, userInfo: nil)
                }
                completion(output, nil)
            } catch {
                completion(nil, error)
            }
            
            }.resume()
        
    }
}
