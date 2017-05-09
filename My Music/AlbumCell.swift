//
//  AlbumCollectionViewCell.swift
//  My Music
//
//  Created by Sinisa Vukovic on 05/05/2017.
//  Copyright © 2017 Sinisa Vukovic. All rights reserved.
//

import UIKit
import Alamofire
import CoreData

class AlbumCell: UICollectionViewCell {
    
    var cacheManager = ImageCache.shared
    var request: Request?
    
    @IBOutlet weak var albumImage: UIImageView!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var dimmedView: UIView!
    
    func updateAppearanceFor(_ album: AlbumModel?, animated: Bool = true) {
        reset()
        DispatchQueue.main.async {
            if animated {
                UIView.animate(withDuration: 0.5) {
                    self.display(album)
                }
            } else {
                self.display(album)
            }
        }
    }
    
    func reset() {
        albumImage.image = nil
        request?.cancel()
        artistLabel.isHidden = true
    }
    
    override func prepareForReuse() {
        display(nil)
    }
    
    private func display(_ album:AlbumModel?) {
        if let album = album {
            dimmCell(album: album)
            loadImage(album: album)
            albumImage.isHidden = false
            artistLabel.isHidden = false
            loadingIndicator.isHidden = true
            loadingIndicator.stopAnimating()
            artistLabel.text = album.name
        }
        else {
            dimmedView.isHidden = true
            loadingIndicator.isHidden = false
            loadingIndicator.startAnimating()
            albumImage.isHidden = true
            artistLabel.isHidden = true
            albumImage.image = nil
            artistLabel.text = ""
        }
    }
    
    private func loadImage(album: AlbumModel) {
        if let image = cacheManager.cachedImage(for: album.imageUrl) {
            albumImage.image = image
            return
        }
        downloadImage(album: album)
    }
    
    private func downloadImage(album: AlbumModel) {
        request = cacheManager.retrieveImage(for: album.imageUrl, completion: {[weak self](image) in
            self?.populate(with: image)
        })
    }
    
    private func populate(with image: UIImage) {
        loadingIndicator.isHidden = true
        loadingIndicator.stopAnimating()
        albumImage.image = image
    }
    private func dimmCell(album: AlbumModel) {
        if let delegate = UIApplication.shared.delegate as? AppDelegate{
             let context = delegate.persistentContainer.viewContext
            if Album.alreadyInDatabase(album: album, context: context) {
                dimmedView.isHidden = false
                self.isUserInteractionEnabled = false
            }
        }
    }
}
