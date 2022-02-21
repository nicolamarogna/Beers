//
//  ViewController.swift
//  WorldBeers
//
//  Created by Nicola Marogna on 16/02/22.
//

import UIKit
import Alamofire
import SDWebImage

class BeerViewCell: UITableViewCell{
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var imgBeer: UIImageView!
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet var searchBarView: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    private var beerVM: BeerVM!
    
    override func viewDidLoad()  {
        super.viewDidLoad()
        navigationItem.titleView = searchBarView
        tableView.delegate = self
        tableView.dataSource = self
        searchBarView.delegate = self
        tableView.rowHeight = 100
        self.beerVM = BeerVM()
                
        getData(funcName: beerVM.getMoreBeers, req: "")
    }
    
    
    
    func dispatch(obj: (@escaping () -> Void)) {
        DispatchQueue.main.async {
            obj()
        }
    }
    
    func getData(funcName: (String?, @escaping () -> Void) -> () , req: String?) {
        self.dispatch(obj: self.activityIndicatorView.startAnimating)
        funcName(req!) {
            self.dispatch(obj: self.tableView.reloadData)
        }
        self.dispatch(obj: self.activityIndicatorView.stopAnimating)
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.beerVM.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! BeerViewCell

        cell.title.text = beerVM.items[indexPath.row].name
        
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
