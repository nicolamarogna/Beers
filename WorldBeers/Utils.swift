//
//  Utils.swift
//  WorldBeers
//
//  Created by Nicola Marogna on 16/02/22.
//

import Foundation

func check_abv_ibu(value: Decimal?) -> (String) {
    if (value != nil) {
        return "\(value!)"
    }
        return "N/A"
}

