//
//  AlbumDetailsVCViewController.swift
//  My Music
//
//  Created by Sinisa Vukovic on 06/05/2017.
//  Copyright © 2017 Sinisa Vukovic. All rights reserved.
//

import UIKit

class AlbumDetailsVC: UIViewController {
    
    var album: AlbumModel?
    var albumImage: UIImage?
    var tracks: [TrackModel] = [] {
        didSet {
            for track in tracks {
                if let duration = Double(track.trackDuration) {
                    let formatedDuration = Utils.timeString(time: duration)
                    track.set(duration: formatedDuration)
                }
            }
            tableView.reloadData()
        }
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureController()
    }
    
    private func configureController() {
        if let album = album {
            navigationItem.title = album.artist
            nameLabel.text = album.name
            downloadTracks(for: album)
        }
        if let image = albumImage {
            albumImageView.image = image
        }
    }
    
    private func downloadTracks(for album:AlbumModel) {
        let apiService = ApiService()
        apiService.downloadInfo(albumName: album.name, forArtist: album.artist) { [weak self] in
            self?.tracks = apiService.arrayOfTracks
        }
    }
}

extension AlbumDetailsVC: UITableViewDelegate {
    
}

extension AlbumDetailsVC : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell") {
            cell.textLabel?.text = tracks[indexPath.row].trackName
            cell.detailTextLabel?.text = "\(tracks[indexPath.row].trackDuration)"
            return cell
        }else {
            return UITableViewCell()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
}
