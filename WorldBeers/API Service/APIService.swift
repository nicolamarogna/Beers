//
//  APIService.swift
//  WorldBeers
//
//  Created by Nicola Marogna on 17/02/22.
//

import Foundation
import Alamofire

class APIService: NSObject {
    
    func af_request<T: Decodable>(url: String,
                                  structure: [T].Type,
                                  completion: @escaping ([T]) -> Void) {
        //self.activityIndicatorView.startAnimating()
        AF.request(url).responseDecodable(of: structure) {  response in
            switch response.result {
                case .success:
                completion(response.value ?? [])
                case .failure(let error):
                        print("\n Failure: \(error.localizedDescription)")
                }
            //self.activityIndicatorView.stopAnimating()
        }
    }

}
