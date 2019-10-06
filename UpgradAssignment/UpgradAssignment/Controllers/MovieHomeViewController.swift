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
    var homeViewModel = HomeViewModel()
    var moviewItems = [Movie]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetup()
    }
    
    func initialSetup() {
        title = "Popular Movies"
        searchBar.delegate = self
        let cellNib = UINib(nibName: MovieCellIdentifier, bundle: nil)
        collectionView.register(cellNib, forCellWithReuseIdentifier: MovieCellIdentifier)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "ActivityCell")
        homeViewModel.callMostPopularMoviesData()
        listenToReloadClosure()
    }
    
    func listenToReloadClosure(){
        homeViewModel.reloadCollectionView = {
            DispatchQueue.main.async {
                if self.homeViewModel.pageNo == 1 {
                    self.collectionView.reloadData()
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
            }
        }
    }
    
    @IBAction func sortButtonPressed(_ sender: Any) {
    }
}

extension MovieHomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.homeViewModel.movieItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCellIdentifier, for: indexPath) as! MovieCollectionViewCell
        cell.populateData(item: homeViewModel.movieItems[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == (homeViewModel.movieItems.count-5)
        {
            homeViewModel.callMostPopularMoviesData()
        }
    }
}

extension MovieHomeViewController: UICollectionViewDelegateFlowLayout {
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
    }
}
