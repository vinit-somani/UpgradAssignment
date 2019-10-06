//
//  MovieHomeViewController.swift
//  UpgradAssignment
//
//  Created by AiTechnology on 10/5/19.
//  Copyright © 2019 vinit.somani. All rights reserved.
//

import UIKit

class MovieHomeViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var activity: UIActivityIndicatorView!

    
    @IBOutlet weak var noDatalabel: UILabel!
    
    
    var homeViewModel = HomeViewModel()
    var moviewItems = [Movie]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetup()
    }
    
    
//MARK:- initial setup for the homeViewController
    func initialSetup() {
        title = "Popular Movies"
        searchBar.delegate = self
        self.noDatalabel.isHidden = true
        let cellNib = UINib(nibName: MovieCellIdentifier, bundle: nil)
        collectionView.register(cellNib, forCellWithReuseIdentifier: MovieCellIdentifier)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "ActivityCell")
        getMostPopularData()
        listenToReloadClosure()
    }
    
    func getMostPopularData() {
        activity.startAnimating()
        homeViewModel.callMostPopularMoviesData()
    }
    
    
//MARK:- closure for listening the reloading calls
    func listenToReloadClosure(){
        homeViewModel.reloadCollectionView = { [weak self] in
            guard let self = self else {
                return
            }
            DispatchQueue.main.async {
                    if self.homeViewModel.pageNo == 1 || self.homeViewModel.currentSortType != nil {
                        self.collectionView.reloadData()
                        self.homeViewModel.currentSortType = nil
                    }
                    else {
                        let numberOfItems = self.collectionView.numberOfItems(inSection: 0)
                        var indexPaths = [IndexPath]()
                        for index in numberOfItems...(self.homeViewModel.movieItems.count-1) {
                            let indexPathItem = IndexPath.init(item: index, section: 0)
                            indexPaths.append(indexPathItem)
                        }
                        self.collectionView.insertItems(at: indexPaths)
                    }
                
                    self.activity.stopAnimating()
            }
        }
        
        homeViewModel.reloadCollectionViewForSearch = { [weak self] in
            guard let self = self else {
                return
            }
             DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    self.activity.stopAnimating()
             }
        }
    }
    
    @IBAction func sortButtonPressed(_ sender: Any) {
        
        let alertview = UIAlertController.init(title: nil, message: "Sort Movie", preferredStyle: .actionSheet)
        alertview.addAction(UIAlertAction.init(title: SortType.popularity.name, style: .default, handler: { (action) in
            DispatchQueue.main.async {
                self.sortMoviesInModel(sortBy: .popularity)
            }
        }))
        
        alertview.addAction(UIAlertAction.init(title: SortType.rating.name, style: .default, handler: { (action) in
            DispatchQueue.main.async {
                self.sortMoviesInModel(sortBy: .rating)
            }
        }))
        
        alertview.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: { (action) in
        }))
        
        self.present(alertview, animated: true, completion: nil)
    }
    
//MARK:- calling sorting in view model
    func sortMoviesInModel(sortBy: SortType) {
        activity.startAnimating()
        self.collectionView.contentOffset = CGPoint.zero
        self.homeViewModel.sortMoviesBy(sortType: sortBy)
    }
}

//MARK:- collection view delegates
extension MovieHomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = (searchBar.text?.count ?? 0) > 0 ? self.homeViewModel.searchItems.count: self.homeViewModel.movieItems.count
        self.noDatalabel.isHidden = count > 0 ? true : false
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCellIdentifier, for: indexPath) as! MovieCollectionViewCell
        let movieModel = self.homeViewModel.searchItems.count > 0 ? self.homeViewModel.searchItems[indexPath.row] : homeViewModel.movieItems[indexPath.row]
        cell.populateData(item: movieModel)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.view.endEditing(true)
        let model = homeViewModel.movieItems[indexPath.row]
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "MovieDetailVC") as? MovieDetailViewController{
            vc.movieModel = model
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if self.homeViewModel.searchItems.count > 0 {
            
        }
        else if indexPath.row == (homeViewModel.movieItems.count-5)
        {
           getMostPopularData()
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize.init(width: moviewCellWidth, height: movieCellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 10, left: 12, bottom: 10, right: 12)
    }
}

//MARK:- Searchbar Delegate
extension MovieHomeViewController : UISearchBarDelegate
{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0 {
            self.homeViewModel.searchItems.removeAll()
            self.collectionView.reloadData()
            self.view.endEditing(true)
        }
        if searchText.count > 1 {
            self.homeViewModel.filterMoviesBy(text: searchText)
        }
    }
}
