//
//  Utils.swift
//  WorldBeers
//
//  Created by Nicola Marogna on 16/02/22.
//

import Foundation
import UIKit

func check_abv_ibu(value: Double?) -> (String) {
    if (value != nil) {
        return "\(value!)"
    }
        return "N/A"
}

func setStepSlider(sender: UISlider, step: Float) {
    let roundedValue = round(sender.value / step) * step
    sender.value = roundedValue
}


