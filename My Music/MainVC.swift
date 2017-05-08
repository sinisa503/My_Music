//
//  MainVC.swift
//  My Music
//
//  Created by Sinisa Vukovic on 06/05/2017.
//  Copyright © 2017 Sinisa Vukovic. All rights reserved.
//

import UIKit
import CoreData

class MainVC: UIViewController {
    
    fileprivate var fetchedResultsController: NSFetchedResultsController<Album>?
    fileprivate var selectedAlbum:Album?
    
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var noAlbumsLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collection.dataSource = self
        collection.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        instatiateFRC()
        collection.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navigationController = segue.destination as? UINavigationController {
            if let detailsVC = navigationController.viewControllers.first as? DetailViewController{
                if let album = selectedAlbum {
                    detailsVC.album = album
                }
            }
        }
    }
    
    private func instatiateFRC() {
        let request: NSFetchRequest<Album> = Album.fetchRequest()
        let sortDesc = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sortDesc]
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            let context = delegate.persistentContainer.viewContext
            fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: "albumsCashe")
            
            do {
                try fetchedResultsController?.performFetch()
                if let albums = fetchedResultsController?.fetchedObjects {
                    for album in albums {
                        print(album.name)
                    }
                }
                
                collection.reloadData()
            } catch let error {
                print(error)
            }
        }
    }
    
}

extension MainVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let album = fetchedResultsController?.object(at: indexPath) {
            selectedAlbum = album
            performSegue(withIdentifier: "showAlbum", sender: nil)
        }
    }
}

extension MainVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let numberOfAlbums = fetchedResultsController?.fetchedObjects?.count ?? 0
        if numberOfAlbums > 0 {
            noAlbumsLabel.isHidden = true
        }
        return numberOfAlbums
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell2", for: indexPath) as? MainCell {
            if let album = fetchedResultsController?.object(at: indexPath) {
                cell.configureCell(album: album)
            }
            return cell
        }else {
            return UICollectionViewCell()
        }
    }
}

extension MainVC: UICollectionViewDelegateFlowLayout {
    
    //MARK: UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let insets:CGFloat = 10.0
        let numberOfCellPerRow = 2
        let numberOfCellPerColumn = 3
        let width = (collection.frame.width / CGFloat(numberOfCellPerRow)) - (insets * CGFloat(numberOfCellPerRow))
        let height = (collection.frame.height / CGFloat(numberOfCellPerColumn)) - (insets * CGFloat(numberOfCellPerColumn))
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let insets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return insets
    }
}
