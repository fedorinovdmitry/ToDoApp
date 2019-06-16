//
//  APIClient.swift
//  ToDoApp
//
//  Created by Дмитрий Федоринов on 11/06/2019.
//  Copyright © 2019 FedorinovDmitry. All rights reserved.
//

import Foundation


enum NetworkError: Error {
    case emptyData
}
protocol URLSessionProtocol {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol {}

class APIClient {
    lazy var urlSession: URLSessionProtocol  = URLSession.shared
    
    func login(withName name: String,
               password: String,
               completionHandler: @escaping (String?, Error?) -> Void) {
    
        //набор допустимых символов определяется urlQueryAllowed
        let allowedCharaters = CharacterSet.urlQueryAllowed
        guard let name = name.addingPercentEncoding(withAllowedCharacters: allowedCharaters),
            let password = password.addingPercentEncoding(withAllowedCharacters: allowedCharaters) else { return }
        
        let query = "name=\(name)" + "&" + "password=\(password)"
        
        guard let url = URL(string: "https://todoapp.com/login?\(query)") else {
            return
        }
        
        urlSession.dataTask(with: url) { (data, responce, error) in
            
            guard error == nil else {
                return completionHandler(nil, error)
            }
            
            do {
                guard let data = data else {
                    completionHandler(nil, NetworkError.emptyData)
                    return
                }
                let dictionary = try JSONSerialization.jsonObject(with: data, options: []) as! [String : String]
                
                let token = dictionary["token"]
                completionHandler(token, nil)
            } catch {
                completionHandler(nil, error)
            }
            
            
        }.resume()
    }
}

