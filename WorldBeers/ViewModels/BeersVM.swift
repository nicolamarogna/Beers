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
    var ABVval: Double? = 0
    var ABVvalMinor: Bool = false
    var IBUval: Double? = 0
    var IBUvalMinor: Bool = false

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
    
    func getBeersFromName(req: String?, completion: @escaping () -> Void) {
        let query = (req?.trimmingCharacters(in: .whitespacesAndNewlines).count)! > 0 ? "&beer_name=\(req!)" : ""

        let queryABV = (ABVval != 0 && ABVvalMinor) ? "&abv_lt=\(ABVval!)" : "&abv_gt=\(ABVval!)"
        let queryIBU = (IBUval != 0 && IBUvalMinor) ? "&ibu_lt=\(IBUval!)" : "&ibu_gt=\(IBUval!)"

        self.apiService.af_request(url: "\(baseUrl)?per_page=\(self.pagination)\(query)\(queryABV)\(queryIBU)",
                                   structure: [Beer].self, completion: { res in
            self.items = res
            self.page = 1
            self.pages = [1]
            completion()
        })
    }
    
    func getMoreBeers(req: String?, completion: @escaping () -> Void) {
        
        self.apiService.af_request(url: "\(baseUrl)?per_page=\(self.pagination)&page=\(self.page+1)\(req!)",
                                   structure: [Beer].self, completion: { res in
            self.items.append(contentsOf: res)
            self.page += 1
            self.pages.append(self.page)
            completion()
        })

    }
    
}


