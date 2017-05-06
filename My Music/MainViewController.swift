//
//  MainViewController.swift
//  My Music
//
//  Created by Sinisa Vukovic on 04/05/2017.
//  Copyright © 2017 Sinisa Vukovic. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    let loadingQueue = OperationQueue()
    var loadingOperations = [IndexPath : DataLoadOperation]()
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collection: UICollectionView!
    fileprivate var selectedAlbum:Album?
    fileprivate var albumArray:[Album?] = [] {
        didSet {
            collection.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collection.prefetchDataSource = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAlbumDetail" {
            if let detailVC = segue.destination as? DetailViewController {
                if let album = selectedAlbum {
                    detailVC.album = album
                }
            }
        }
    }
    
    fileprivate func issueAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        searchBar.resignFirstResponder()
    }
}

extension MainViewController: UICollectionViewDelegate {
    
    //MARK: UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedAlbum = albumArray[indexPath.item]
        performSegue(withIdentifier: "showAlbumDetail" , sender: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        searchBar.resignFirstResponder()
        guard let cell = cell as? AlbumCell else { return }
        
        // How should the operation update the cell once the data has been loaded?
        let updateCellClosure: (Album?) -> () = { [unowned self] (album) in
            cell.updateAppearanceFor(album, animated: true)
            self.loadingOperations.removeValue(forKey: indexPath)
        }
        
        // Try to find an existing data loader
        if let dataLoader = loadingOperations[indexPath] {
            // Has the data already been loaded?
            if let album = dataLoader.album {
                cell.updateAppearanceFor(album, animated: false)
                loadingOperations.removeValue(forKey: indexPath)
            } else {
                // No data loaded yet, so add the completion closure to update the cell once the data arrives
                dataLoader.loadingCompleteHandler = updateCellClosure
            }
        } else {
            // Need to create a data loaded for this index path
            if let album = albumArray[indexPath.item] {
                let dataLoader = DataLoadOperation(album)
                // Provide the completion closure, and kick off the loading operation
                dataLoader.loadingCompleteHandler = updateCellClosure
                loadingQueue.addOperation(dataLoader)
                loadingOperations[indexPath] = dataLoader
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // If there's a data loader for this index path we don't need it any more. Cancel and dispose
        if let dataLoader = loadingOperations[indexPath] {
            dataLoader.cancel()
            loadingOperations.removeValue(forKey: indexPath)
        }
    }
}

extension MainViewController:  UICollectionViewDataSource {
    
    //MARK: UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albumArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? AlbumCell {
            cell.updateAppearanceFor(nil, animated: false)
            return cell
        }else {
            return UICollectionViewCell()
        }
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSourcePrefetching {

    //MARK: UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellSpaceing:CGFloat = 2.0
        let numberOfCellPerRow = 2
        let width = (collection.frame.width / CGFloat(numberOfCellPerRow)) - (cellSpaceing * CGFloat(numberOfCellPerRow))
        
        return CGSize(width: width, height: width)
    }
    
    //MARK: UICollectionViewPrefetching
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if let _ = loadingOperations[indexPath] {
                return
            }
            
            if let album = albumArray[indexPath.item] {
                let dataLoader = DataLoadOperation(album)
                loadingQueue.addOperation(dataLoader)
                loadingOperations[indexPath] = dataLoader
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if let dataLoader = loadingOperations[indexPath] {
                dataLoader.cancel()
                loadingOperations.removeValue(forKey: indexPath)
            }
        }
    }
}

extension MainViewController: UISearchBarDelegate {
    //MARK: UISearchBar Delegate
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let apiService = ApiService()
        
        if let artist = searchBar.text {
            apiService.downloadTopAlbumsFor(artist: artist) {[weak self] in
                if apiService.arrayOfAlbums.count > 0 {
                    self?.albumArray = apiService.arrayOfAlbums
                }
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            albumArray = []
        }
    }
}
