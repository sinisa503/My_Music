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
        let sortDesc = NSSortDescriptor(key: SortDescriptor.ARTIST, ascending: true)
        request.sortDescriptors = [sortDesc]
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            let context = delegate.persistentContainer.viewContext
            fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: "artist", cacheName: "albumsCashe")
            
            do {
                try fetchedResultsController?.performFetch()
                collection.reloadData()
            } catch let error {
                print("Error fetching from CoreData: \(error.localizedDescription)")
            }
        }
    }
    
}

extension MainVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let album = fetchedResultsController?.object(at: indexPath) {
            selectedAlbum = album
            performSegue(withIdentifier: SegueiConstant.SHOW_ALBUM_DETAIL_FROM_CORE_DATA, sender: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let sectionHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeader", for: indexPath) as! SectionHeaderView
        
        if let album = fetchedResultsController?.object(at: indexPath) {
            sectionHeaderView.title = album.artist
        }
        return sectionHeaderView
    }
}

extension MainVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let numberOfAlbums = fetchedResultsController?.sections?.count ?? 0
        if numberOfAlbums > 0 {
            noAlbumsLabel.isHidden = true
        }
        
        if let sections = fetchedResultsController?.sections {
            let currentSection = sections[section]
            return currentSection.numberOfObjects
        }else {
            return 0
        }
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return fetchedResultsController?.sections?.count ?? 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellConstant.MAIN_VC_CELL, for: indexPath) as? MainCell {
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
        
        let insets:CGFloat = 5.0
        let numberOfCellPerRow = CGFloat(2.0)
        let numberOfCellPerColumn = CGFloat(3.0)
        let width = collectionView.frame.width / numberOfCellPerRow - (insets * numberOfCellPerRow)
        let height = collectionView.frame.height / numberOfCellPerColumn - (insets * numberOfCellPerColumn)
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let insets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        return insets
    }
}
