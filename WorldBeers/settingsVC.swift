//
//  settingsVC.swift
//  WorldBeers
//
//  Created by Nicola Marogna on 28/02/22.
//

import UIKit

class SettingsVC: UIViewController, UIAdaptivePresentationControllerDelegate {

    @IBOutlet weak var sliderABV: UISlider!
    @IBOutlet weak var sliderIBU: UISlider!
    @IBOutlet weak var lblSliderABV: UILabel!
    @IBOutlet weak var lblSliderIBU: UILabel!

    @IBOutlet weak var ABVMinMaj: UISegmentedControl!
    @IBOutlet weak var IBUMinMaj: UISegmentedControl!
        
    var presenting: ViewController?
    
    @IBAction func changeABV(_ sender: UISlider) {
        setStepSlider(sender: sender, step: 0.50)
        lblSliderABV.text = String(format:"%.2f", sender.value)
    }
    
    @IBAction func changeIBU(_ sender: UISlider) {
        setStepSlider(sender: sender, step: 1)
        lblSliderIBU.text = String(format:"%.2f", sender.value)
    }

    @IBAction func dismissView(_ sender: Any) {
        self.dismiss(animated: true, completion:{
            self.presenting?.dismissView(sliderABV: self.sliderABV, sliderIBU: self.sliderIBU, ABVMinMaj: self.ABVMinMaj, IBUMinMaj: self.IBUMinMaj)
        })
    }
    
    @IBAction func resetFilters() {
        sliderIBU.value = 0
        sliderABV.value = 0
        lblSliderABV.text = "0.00"
        lblSliderIBU.text = "0.00"
    }
    
    
}

