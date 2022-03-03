//
//  ViewController.swift
//  WorldBeers
//
//  Created by Nicola Marogna on 16/02/22.
//

import UIKit
import Alamofire
import SDWebImage
import BadgeSwift

class BeerViewCell: UITableViewCell{
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var imgBeer: UIImageView!
    @IBOutlet weak var lblABV: UILabel!
    @IBOutlet weak var lblIBU: UILabel!
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UIAdaptivePresentationControllerDelegate {
    
    @IBOutlet var searchBarView: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    private var beerVM: BeerVM!
    private var settingVC: SettingsVC!
    
    var filtersButton: UIButton?
    let badge = BadgeSwift()
    var badgeIsShowed = false

    override func viewDidLoad()  {
        super.viewDidLoad()
        navigationItem.titleView = searchBarView
        tableView.delegate = self
        tableView.dataSource = self
        searchBarView.delegate = self
        filtersButton = searchBarView.value(forKey: "cancelButton") as? UIButton
        filtersButton?.setTitle("Filtri", for: .normal)
        
        badge.textColor = .white
        badge.alpha = 0.0
        searchBarView.addSubview(badge)

        settingVC = (self.storyboard?.instantiateViewController(withIdentifier: "settingsVC"))! as? SettingsVC

        tableView.rowHeight = 80
        self.beerVM = BeerVM()

        filtersButton?.tintColor = .systemBlue
        getData(funcName: beerVM.getMoreBeers, req: "")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.badge.frame = CGRect(x:self.filtersButton!.frame.origin.x+self.filtersButton!.frame.size.width,y:15,width: 10, height: 10)

    }
        
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        settingVC.presentationController?.delegate = self
        settingVC.presenting = self
        self.present(settingVC, animated: true, completion: nil)
    }

    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        let modal = presentationController.presentedViewController as! SettingsVC
        
        self.dismissView(
            sliderABV: modal.sliderABV,
            sliderIBU: modal.sliderIBU,
            ABVMinMaj: modal.ABVMinMaj,
            IBUMinMaj: modal.IBUMinMaj
        )
 
    }
    
    func dismissView(
        sliderABV: UISlider,
        sliderIBU: UISlider,
        ABVMinMaj: UISegmentedControl,
        IBUMinMaj: UISegmentedControl
    ){
        beerVM.ABVval = Double(String(format:"%.2f", Double(sliderABV.value)))
        beerVM.IBUval = Double(String(format:"%.2f", Double(sliderIBU.value)))
       
        beerVM.ABVvalMinor = (ABVMinMaj.selectedSegmentIndex == 1) ? true : false
        beerVM.IBUvalMinor = (IBUMinMaj.selectedSegmentIndex == 1) ? true : false
        
        (beerVM.ABVval != 0 || beerVM.IBUval != 0)
        ? (!badgeIsShowed) ? showBadge(true) : nil
        : (badgeIsShowed) ? showBadge(false) : nil

        self.getData(funcName: self.beerVM.getBeersFromName, req: beerVM.searchText)
    }

    func showBadge(_ show: Bool) {
        badge.alpha = show ? 0.0 : 1.0
        UIView.animate(withDuration: 1, delay: 0.5, options: .curveEaseIn, animations: {
            self.badge.alpha = show ? 1.0 : 0.0
            }, completion: nil)
        self.badgeIsShowed = show
    }
    
    func dispatch(cb: (@escaping () -> Void)) {
        DispatchQueue.main.async {
            cb()
        }
    }
    
    func getData(funcName: (String?, @escaping () -> Void) -> () , req: String?) {
        self.dispatch(cb: self.activityIndicatorView.startAnimating)
        funcName(req!) {
            self.dispatch(cb: self.tableView.reloadData)
        }
        self.dispatch(cb: self.activityIndicatorView.stopAnimating)
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.beerVM.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! BeerViewCell

        cell.title.text = beerVM.items[indexPath.row].name
        cell.lblABV.text = "ABV: "+check_abv_ibu(value: beerVM.items[indexPath.row].abv)
        cell.lblIBU.text = "IBU: "+check_abv_ibu(value: beerVM.items[indexPath.row].ibu)

        let url = URL(string: beerVM.items[indexPath.row].image_url ?? "")
        cell.imgBeer.sd_setImage(with: url)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let req_beer = (beerVM.searchText != "") ? "&beer_name=\(beerVM.searchText)" : ""
        let lastElement = (beerVM.pagination * beerVM.page) - 1
        if indexPath.row == lastElement && !beerVM.pages.contains(beerVM.page+1) {
            getData(funcName: self.beerVM.getMoreBeers, req: req_beer)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        beerVM.searchText = searchText
        
        if searchText.isEmpty {
            self.searchBarView.resignFirstResponder()
            getData(funcName: self.beerVM.getBeersFromName, req: "")
            return
        }

        beerVM.debounce_timer?.invalidate()
        beerVM.debounce_timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
            self.getData(funcName: self.beerVM.getBeersFromName, req: searchText)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as! BeerDetail
        let beerChoosed = beerVM.items[self.tableView.indexPathForSelectedRow!.row]
        controller.beer = beerChoosed
    }
    
}
