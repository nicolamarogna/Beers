//
//  BeersVM.swift
//  WorldBeers
//
//  Created by Nicola Marogna on 17/02/22.
//

import Foundation

let baseUrl = "https://api.punkapi.com/v2/beers"

class BeerVM: NSObject {
    
    private var apiService: APIService!
    var items:[Beer] = []
    var debounce_timer:Timer?
    var page: Int = 0
    var pages:[Int] = [0]
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
    
    func getBeersFromName(req: String) async throws -> [Beer] {
        try await withUnsafeThrowingContinuation { continuation in
            
            let query = req.trimmingCharacters(in: .whitespacesAndNewlines).count > 0 ? "&beer_name=\(req)" : ""
            
            self.apiService.af_request(url: "\(baseUrl)?per_page=\(self.pagination)\(query)",
                                       structure: [Beer].self, completion: { res in
                self.items = res
                self.page = 1
                self.pages = [1]
                continuation.resume(returning: res)
                return
            })
        }
    }

    func getMoreBeers(req: String?) async throws -> [Beer] {
        try await withUnsafeThrowingContinuation { continuation in
            self.apiService.af_request(url: "\(baseUrl)?per_page=\(self.pagination)&page=\(self.page+1)\(req!)",
                                       structure: [Beer].self, completion: { res in
                self.items.append(contentsOf: res)
                self.page += 1
                self.pages.append(self.page)
                continuation.resume(returning: res)
                return
            })
        }
    }

}
