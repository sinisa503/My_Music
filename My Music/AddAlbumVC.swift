//
//  MainViewController.swift
//  My Music
//
//  Created by Sinisa Vukovic on 04/05/2017.
//  Copyright © 2017 Sinisa Vukovic. All rights reserved.
//

import UIKit

class AddAlbumVC: UIViewController {
    
    let loadingQueue = OperationQueue()
    var loadingOperations = [IndexPath : DataLoadOperation]()
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collection: UICollectionView!
    fileprivate var selectedAlbum:AlbumModel?
    fileprivate var selectedImage:UIImage?
    fileprivate var albumArray:[AlbumModel?] = [] {
        didSet {
            collection.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collection.prefetchDataSource = self
        
    }
    
    @IBAction func dismissController(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let albumDetailVC = segue.destination as? AlbumDetailsVC {
            albumDetailVC.album = selectedAlbum
            albumDetailVC.albumImage = selectedImage
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

extension AddAlbumVC: UICollectionViewDelegate {
    
    //MARK: UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedAlbum = albumArray[indexPath.item]
        if let albumCell = collectionView.cellForItem(at: indexPath) as? AlbumCell {
            selectedImage = albumCell.albumImage.image
        }
        performSegue(withIdentifier: "goToAlbumDetails" , sender: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        searchBar.resignFirstResponder()
        guard let cell = cell as? AlbumCell else { return }
        
        // How should the operation update the cell once the data has been loaded?
        let updateCellClosure: (AlbumModel?) -> () = { [unowned self] (album) in
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

extension AddAlbumVC:  UICollectionViewDataSource {
    
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

extension AddAlbumVC: UICollectionViewDelegateFlowLayout, UICollectionViewDataSourcePrefetching {

    //MARK: UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let insets:CGFloat = 2.0
        let numberOfCellPerRow = 2
        let numberOfCellPerColumn = 3
        let width = (collection.frame.width / CGFloat(numberOfCellPerRow)) - (insets * CGFloat(numberOfCellPerRow))
        let height = (collection.frame.height / CGFloat(numberOfCellPerColumn)) - (insets * CGFloat(numberOfCellPerColumn))
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let insets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        return insets
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

extension AddAlbumVC: UISearchBarDelegate {
    //MARK: UISearchBar Delegate
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let apiService = ApiService()
        
        if let artist = searchBar.text {
            apiService.downloadTopAlbumsFor(artist: artist) {[weak self] (completed) in
                if completed && apiService.arrayOfAlbums.count > 0 {
                    self?.albumArray = apiService.arrayOfAlbums
                }else {
                    self?.issueAlert(title: "Not found", message: "Try different search")
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
