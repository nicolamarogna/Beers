//
//  Beer.swift
//  WorldBeers
//
//  Created by Nicola Marogna on 17/02/22.
//

import Foundation

struct Beer: Decodable {
    let name: String
    let image_url: String?
    let description: String?
    let abv: Decimal?
    let ibu: Decimal?
}
