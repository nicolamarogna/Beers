//
//  BeersVM.swift
//  WorldBeers
//
//  Created by Nicola Marogna on 17/02/22.
//

import Foundation

class BeerVM: NSObject {
    
    private var apiService: APIService!
    var items:[Beer] = []
    var debounce_timer:Timer?
    var page: Int = 1
    var pages:[Int] = [1]
    var pagination: Int = 25
    var searchText: String = ""

    var bindBeerVMToController : (() -> ()) = { }
    
    private(set) var empData : [Beer]! {
        didSet {
            self.bindBeerVMToController()
        }
    }

    override init() {
        super.init()
        self.apiService = APIService()
    }
    
    
     
     
    
    func getFirstBeers() async throws -> [Beer] {
        try await withUnsafeThrowingContinuation { continuation in

            self.apiService.af_request(url: "https://api.punkapi.com/v2/beers?per_page=\(self.pagination)",
                                       structure: [Beer].self, completion: { res in
                self.items = res
                continuation.resume(returning: res)
                return
            })
        }
        
    }
    /*
    func getFirstBeers() -> [Beer] {
        self.apiService.af_request(url: "https://api.punkapi.com/v2/beers?per_page=\(self.pagination)", structure: [Beer].self, completion: { (res) -> [Beer] in
            self.items = res
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            return res
        })
        return res
    }
    */
    
}
