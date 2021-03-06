//
//  MainController.swift
//  29Day
//
//  Created by 杜维欣 on 16/4/5.
//  Copyright © 2016年 Nododo. All rights reserved.
//

import UIKit

private let reuseIdentifier  = "featured"
private let cellIdentifier  = "tableCell"

let screenH = UIScreen.mainScreen().bounds.size.height
let screehW = UIScreen.mainScreen().bounds.size.width
var mainTable: UITableView!
var customSearchController: CustomSearchController!
var blurView: BlurView!


class MainController: UICollectionViewController, UISearchResultsUpdating, UITableViewDelegate, UITableViewDataSource, UISearchControllerDelegate, CustomSearchControllerDelegate {

    func updateSearchResultsForSearchController(searchController: UISearchController) {
        print("\(customSearchController.searchBar.text)")
    }
    

    
    @IBAction func touchToSearch(sender: UIBarButtonItem) {
        self.navigationController?.navigationBar.addSubview(customSearchController.customSearchBar)
        customSearchController.customSearchBar.becomeFirstResponder()
       view.bringSubviewToFront(blurView)
    }

    
    @IBAction func toggle(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            self.view.bringSubviewToFront(self.collectionView!)
        case 1:
            self.view.bringSubviewToFront(mainTable)
        default:
            print("")
        }
    }
    
    
     var movieArray: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView?.backgroundColor = UIColor.blackColor()
        blurView = BlurView.init(frame: self.view.bounds)
        view.insertSubview(blurView, belowSubview: collectionView!)
        makeData()
        setupTable()
        setupSearch()
    }
    
    func setupSearch() {
        customSearchController = CustomSearchController(searchResultsController: nil, searchBarFrame: CGRectMake(0.0, 0.0, 100, 44), searchBarFont: UIFont(name: "Futura", size: 16.0)!, searchBarTextColor: UIColor.orangeColor(), searchBarTintColor: UIColor.blackColor())
        customSearchController.customSearchBar.placeholder = "Search in this awesome bar..."
        customSearchController.customDelegate = self;
        
    }
    
    func setupTable() {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            mainTable = UITableView.init(frame: CGRectMake(0, 64, screehW, screenH - 64));
            mainTable.backgroundColor = UIColor.blackColor()
            mainTable.registerNib(UINib.init(nibName: "ChartsTableCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
            mainTable.delegate = self
            mainTable.dataSource = self
            dispatch_async(dispatch_get_main_queue(), {
                self.view.insertSubview(mainTable, belowSubview: self.collectionView!)
            })
        }
    }
    
    //MARK: tableView
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let movie = movieArray[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! ChartsTableCell
        cell.numberLabel.text = movie.movieName
        cell.photoView.image = UIImage(named: movie.movieName)
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 88
    }

    func makeData() {
        for i in 1...9 {
            let str = String(format: "%d", i)
            let movie = Movie.init(name: str, pic: str)
            movieArray.append(movie)
        }
        movieArray.appendContentsOf(movieArray)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return movieArray.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
       
        let movie = movieArray[indexPath.row]
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! FeaturedCell
            cell.avatarView.image = UIImage(named: movie.moviePic)
            cell.nameLabel.text = movie.movieName
            return cell

    }

    override func  collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "header", forIndexPath: indexPath)
        return header

    }

    
    // MARK: CustomSearchControllerDelegate functions
    
    func didStartSearching() {
        dispatch_async(dispatch_get_main_queue()) {
            customSearchController.searchResultsController?.view.hidden = false
        }
    }
    
    
    func didTapOnSearchButton() {
    }
    
    
    func didTapOnCancelButton() {
       customSearchController.customSearchBar.resignFirstResponder()
        customSearchController.customSearchBar.removeFromSuperview()
        view.sendSubviewToBack(blurView)
    }
    
    
    func didChangeSearchText(searchText: String) {
        let resultArray = movieArray.filter { (movie) -> Bool in
            return movie.movieName.containsString(searchText)
        }
        blurView.resultArray = resultArray
    }
}
