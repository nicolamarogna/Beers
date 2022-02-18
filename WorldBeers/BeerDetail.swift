//
//  BeerDetail.swift
//  WorldBeers
//
//  Created by Nicola Marogna on 16/02/22.
//


import UIKit
import SDWebImage

class BeerDetail: UIViewController {

    @IBOutlet weak var beerImageView: UIImageView!
    @IBOutlet weak var beerDesc: UITextView!
    @IBOutlet weak var lblAbv: UILabel!
    @IBOutlet weak var lblIbu: UILabel!

    var beer: Beer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(beer)
        self.title = beer?.name
        let url = URL(string: beer?.image_url ?? "")
        self.beerImageView.sd_setImage(with: url)
        beerDesc.text = beer?.description ?? ""

        lblAbv.text! += check_abv_ibu(value: beer?.abv)
        lblIbu.text! += check_abv_ibu(value: beer?.ibu)

    }


    
}

