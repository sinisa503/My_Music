//
//  AlbumCollectionViewCell.swift
//  My Music
//
//  Created by Sinisa Vukovic on 05/05/2017.
//  Copyright © 2017 Sinisa Vukovic. All rights reserved.
//

import UIKit
import Alamofire

class AlbumCell: UICollectionViewCell {
    
    @IBOutlet weak var albumImage: UIImageView!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    var album:Album?
    
    func updateAppearanceFor(_ album: Album?, animated: Bool = true) {
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
    
    override func prepareForReuse() {
        display(nil)
    }
    
    private func display(_ album:Album?) {
        if let album = album {
            albumImage.isHidden = false
            artistLabel.isHidden = false
            loadingIndicator.isHidden = true
            loadingIndicator.stopAnimating()
            downloadImageFrom(url: album.imageUrl)
            artistLabel.text = album.name
        }else {
            loadingIndicator.isHidden = false
            loadingIndicator.startAnimating()
            albumImage.isHidden = true
            artistLabel.isHidden = true
            albumImage.image = nil
            artistLabel.text = ""
        }
    }
    
    private func downloadImageFrom(url:String) {
    let _url = NSURL(string: url)! as URL
    let dataTask = URLSession.shared.dataTask(with: _url) { [weak self]
        data, response, error in
        if error == nil {
            if let  data = data, let image = UIImage(data: data) {
                self?.albumImage.image = image
            }
        } else {
            self?.display(nil)
        }
    }
    dataTask.resume()
    }
}
