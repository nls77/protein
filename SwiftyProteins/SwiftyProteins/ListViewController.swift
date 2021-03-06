//
//  ListViewController.swift
//  SwiftyProteins
//
//  Created by Nicolas BOULIOL on 4/27/17.
//  Copyright © 2017 Nicolas BOULIOL. All rights reserved.
//

import UIKit

class ListViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchDisplayDelegate {

    var searchResult:[String] = []
    var searchActive : Bool = false
    var currentLigand : String?
    @IBOutlet weak var listOfLiguands: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
//    let searchController = UISearchController(searchResultsController: nil)
//    @IBOutlet weak var searchText: UISearchBar!

    var dic = [String : Any?]()
    
    var liguands : [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("ViewDidLoad + loadLiguands")
        loadLiguands()
        
        listOfLiguands.delegate = self
        listOfLiguands.dataSource = self
        searchBar.delegate = self

        let viewCtrls = self.navigationController?.viewControllers
        let count = viewCtrls?.count
        if count != nil && count! > 1 {
            if let loginCtrl = viewCtrls?[count! - 2] as? ViewController {
                loginCtrl.loginButton.isEnabled =  true
                loginCtrl.touchIdButton.isEnabled = true
            }
        }
        

        
//        searchController.searchResultsUpdater = self
//        searchController.dimsBackgroundDuringPresentation = false
//        definesPresentationContext = true
//        listOfLiguands.tableHeaderView = searchController.searchBar
        
    }

    
    @IBAction func unwindSegue(segue: UIStoryboardSegue){
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
//        searchBar.showsCancelButton = false
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (searchActive) {
            if searchResult.count == 0 {
                return self.liguands.count
            } else {
                return self.searchResult.count
            }
        } else {
            return self.liguands.count
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (searchActive) {
            if searchResult.count == 0 {
                self.currentLigand = liguands[indexPath.row]
            } else {
                self.currentLigand = searchResult[indexPath.row]
            }
        } else {
            self.currentLigand = liguands[indexPath.row]
        }
        performSegue(withIdentifier: "segueToProtein", sender: self)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        searchResult = liguands.filter({ (text) -> Bool in
            let tmp: NSString = text as NSString
            let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            return range.location != NSNotFound
        })
        if(searchResult.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.listOfLiguands.reloadData()
    }
    
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = listOfLiguands.dequeueReusableCell(withIdentifier: "liguandCell", for: indexPath) as! ligandTableViewCell
        let activityView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activityView.color = UIColor.random()
        activityView.center = CGPoint(x:(cell.ligMage.frame.size.width / 2),y: (cell.ligMage.frame.size.height / 2))
        activityView.startAnimating()
        cell.ligMage.addSubview(activityView)
        
//        cell.tuple = (useri?.projects![indexPath.row]["project"]["name"].string, useri?.projects?[indexPath.row]["final_mark"].int)
        if (searchActive) {
            if searchResult.count == 0 {
                cell.ligName.text = liguands[indexPath.row]
                let lig = liguands[indexPath.row]
                let firstChar = lig.characters.first!
                let url = "https://cdn.rcsb.org/images/ligands/\(firstChar)/\(lig)/\(lig)-large.png"
                cell.ligMage.downloadedFrom(url: URL.init(string: url)!, activityView: activityView)
            } else {
//                print(searchResult, searchResult.count)
//                print(indexPath.row)
                cell.ligName.text = searchResult[indexPath.row]
                let lig = searchResult[indexPath.row]
                let firstChar = lig.characters.first!
                let url = "https://cdn.rcsb.org/images/ligands/\(firstChar)/\(lig)/\(lig)-large.png"
                cell.ligMage.downloadedFrom(url: URL.init(string: url)!, activityView: activityView)
            }
        } else {
            cell.ligName.text = liguands[indexPath.row]
            let lig = liguands[indexPath.row]
            let firstChar = lig.characters.first!
            let url = "https://cdn.rcsb.org/images/ligands/\(firstChar)/\(lig)/\(lig)-large.png"
            cell.ligMage.downloadedFrom(url: URL.init(string: url)!, activityView: activityView)
        }
        return cell
        
    }
    
    func loadLiguands()
    {
        
        if let filepath = Bundle.main.path(forResource: "ligands", ofType: "txt")
        {
            do
            {
                let contents = try String(contentsOfFile: filepath)
                let lines = contents.components(separatedBy: "\n")
                self.liguands = lines
                self.listOfLiguands.reloadData()
            }
            catch
            {
                print("contents could not be loaded")
            }
        }
        else
        {
            print("error : not found")
        }
        
    }
    
    
//    func filterContentForSearchText(searchText: String) {
////        // Filter the array using the filter method
////        if self.cacas == nil {
////            self.searchResult = nil
////            return
////        }
//        self.searchResult = self.cacas.filter({( caca: String) -> Bool in
//            // to start, let's just search by name
//            return caca.lowercased().range(of: searchText.lowercased()) != nil
//        })
//    }
    
//    func searchDisplayController(_ controller: UISearchDisplayController, shouldReloadTableForSearch searchString: String?) -> Bool {
//        self.filterContentForSearchText(searchText: searchString!)
//        return true
//    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "segueToProtein" {
            if let dest = segue.destination as? ProteinViewController {
//                searchActive = false
                dest.ligVal = self.currentLigand!
            }
        }
    }
 

}

