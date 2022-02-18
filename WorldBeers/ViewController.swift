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
        
        Task{
            await getData()
        }
    }
    
    func getData() async{
        DispatchQueue.main.async {
            self.activityIndicatorView.startAnimating()
        }
        
        do{
            try await self.beerVM.getFirstBeers()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            print(error)
        }
        
        DispatchQueue.main.async {
            self.activityIndicatorView.stopAnimating()
        }
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
        //debugPrint(pages)
        let req_beer = (beerVM.searchText != "") ? "&beer_name=\(beerVM.searchText)" : ""
        let lastElement = (beerVM.pagination * beerVM.page) - 1
//        if indexPath.row == lastElement && !beerVM.pages.contains(beerVM.page+1) {
//            self.af_request(url: "https://api.punkapi.com/v2/beers?per_page=\(self.pagination)&page=\(beerVM.page+1)\(req_beer)", structure: [Beer].self, completion: {more in
//            self.items.append(contentsOf: more)
//            self.page += 1
//            self.pages.append(self.page)
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//            }
//            })
//        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        beerVM.searchText = searchText
        
        if searchText.isEmpty {
            self.searchBarView.resignFirstResponder()
//            self.af_request(url: "https://api.punkapi.com/v2/beers?per_page=\(self.pagination)", structure: [Beer].self, completion: {res in
//                self.items = res
//                self.page = 1
//                self.pages = [1]
//                DispatchQueue.main.async {
//                    self.tableView.reloadData()
//                }
//            })
            return
        }

        beerVM.debounce_timer?.invalidate()
        beerVM.debounce_timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
            //print ("https://api.punkapi.com/v2/beers?beer_name="+searchText)
//            self.af_request(
//                url: "https://api.punkapi.com/v2/beers?per_page=\(self.pagination)&beer_name="+searchText,
//                structure: [Beer].self,
//                completion: { res in
//                    self.page = 1
//                    self.pages = [1]
//                    self.items = res
//                    DispatchQueue.main.async {
//                        self.tableView.reloadData()
//                    }
//                }
//           )
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as! BeerDetail
        let beerChoosed = beerVM.items[self.tableView.indexPathForSelectedRow!.row]
        controller.beer = beerChoosed
    }
    
//    func af_request<T: Decodable>(url: String,
//                                  structure: [T].Type,
//                                  completion: @escaping ([T]) -> Void) {
//        activityIndicatorView.startAnimating()
//        AF.request(url).responseDecodable(of: structure) {  response in
//            switch response.result {
//                case .success:
//                completion(response.value ?? [])
//                case .failure(let error):
//                        print("\n Failure: \(error.localizedDescription)")
//                }
//            self.activityIndicatorView.stopAnimating()
//        }
//    }
}
