//
//  DetailViewController.swift
//  My Music
//
//  Created by Sinisa Vukovic on 06/05/2017.
//  Copyright © 2017 Sinisa Vukovic. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var albumNameLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var albumImage: UIImageView!
    
    var album:Album?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let album = album {
            albumNameLabel.text = album.name
            artistLabel.text = album.artist
            downloadImageFrom(url: album.imageUrl)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        album = nil
    }

    func downloadImageFrom(url:String) {
        let _url = NSURL(string: url)! as URL
        let dataTask = URLSession.shared.dataTask(with: _url) { [weak self]
            data, response, error in
            if error == nil {
                if let  data = data, let image = UIImage(data: data) {
                    self?.albumImage.image = image
                }
            } else {
                self?.albumImage.image = #imageLiteral(resourceName: "wavelength")
            }
        }
        dataTask.resume()
    }
}
