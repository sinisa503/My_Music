//
//  MainCell.swift
//  My Music
//
//  Created by Sinisa Vukovic on 08/05/2017.
//  Copyright © 2017 Sinisa Vukovic. All rights reserved.
//

import UIKit

class MainCell: UICollectionViewCell {
    
    @IBOutlet weak var albumImage: UIImageView!
    @IBOutlet weak var albumlabel: UILabel!
    
    
    func configureCell(album: Album) {
        if let image = UIImage(data: album.image! as Data) {
            albumImage.image = image
        }
        
        albumlabel.text = album.name
    }
    
}
