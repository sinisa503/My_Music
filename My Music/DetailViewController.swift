//
//  DetailViewController.swift
//  My Music
//
//  Created by Sinisa Vukovic on 06/05/2017.
//  Copyright © 2017 Sinisa Vukovic. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var albumNameLabel: UILabel!

    @IBOutlet weak var albumImage: UIImageView!
    
    var album:Album?
    fileprivate var tracks:[Track] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let album = album {
            albumNameLabel.text = album.name
            navigationItem.title = album.artist
            if let image = UIImage(data: (album.image as Data?)!){
                albumImage.image = image
            }
        }
        if let tracks = album?.tracks {
            for track in tracks {
                self.tracks.append(track as! Track)
            }
        }
    }
    @IBAction func goToSavedAlbums(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func deleteAlbum(_ sender: UIBarButtonItem) {
        issueAlert(title: "Delete album?", message: "Are you sure you want to delete this album?")
    }
    
    private func issueAlert(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Delete", style: .default, handler: {[weak self] (action) in
            if let album = self?.album {
                Album.deleteAlbumFromDatabase(album: album, deleted: {[weak self] (deleted) in
                    if deleted {
                        print("Album has bein deleted")
                        self?.dismiss(animated: true, completion: nil)
                    }else {
                        print("Album has not bein deleted")
                    }
                })
            }
        } ))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension DetailViewController : UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tracks = album?.tracks {
            return tracks.count
        }else {
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: CellConstant.CORE_DATA_DETAIL_TABLE_CELL) {
            let track = tracks[indexPath.item]
            cell.textLabel?.text = track.name
            if let durStr = track.duration {
                if let duration = Double(durStr) {
                    cell.detailTextLabel?.text = Utils.timeString(time: duration)
                }
            }
            return cell
        }else {
            return UITableViewCell()
        }
    }
}

