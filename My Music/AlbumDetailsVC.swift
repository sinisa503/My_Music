//
//  AlbumDetailsVCViewController.swift
//  My Music
//
//  Created by Sinisa Vukovic on 06/05/2017.
//  Copyright © 2017 Sinisa Vukovic. All rights reserved.
//

import UIKit
import CoreData

class AlbumDetailsVC: UIViewController {
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var album: ObjAlbum?
    var albumImage: UIImage?
    var tracks: [ObjTrack] = [] {
        didSet {
            album?.set(tracks: tracks)
            for track in tracks {
                if let duration = Double(track.duration!) {
                    let formatedDuration = Utils.timeString(time: duration)
                    track.duration = formatedDuration
                }
            }
            tableView.reloadData()
        }
    }
    
    private var context: NSManagedObjectContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        saveButton.isEnabled = false
        activityIndicator.startAnimating()
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            context = appDelegate.persistentContainer.viewContext
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureController()
    }
    //Download more info for selected album
    private func configureController() {
        if let album = album {
            navigationItem.title = album.artist?.name
            nameLabel.text = album.name
            downloadTracks(for: album)
        }
        if let image = albumImage {
            albumImageView.image = image
        }
    }
    
    private func downloadTracks(for album:ObjAlbum) {
        let apiService = ApiService()
        apiService.downloadInfo(albumName: album.name!, forArtist: (album.artist?.name)!) { [weak self] (completed) in
            if completed {
                self?.saveButton.isEnabled = true
                self?.activityIndicator.isHidden = true
                self?.activityIndicator.stopAnimating()
                self?.tracks = apiService.arrayOfTracks
            }else {
                print("Not completed!")
            }
        }
    }
    
    @IBAction func saveAlbum(_ sender: UIBarButtonItem) {
        if let context = context {
            context.perform {[weak self] in
                if let image = self?.albumImage {
                    let imageData:NSData? = UIImagePNGRepresentation(image) as NSData?
                    if let data = imageData, let album = self?.album {
                        Album.addNewAlbumToDatabase(albumModel: album, with: data, context: context) { [weak self] (saved) in
                            if saved {
                                self?.saveButton.title = "Saved"
                                Timer.scheduledTimer(timeInterval: 1.0, target: self!, selector: #selector(self?.goBackToSearch), userInfo: nil, repeats: false)
                            }
                        }
                    }
                }
            }
        }
    }
    
    @objc private func goBackToSearch() {
        navigationController?.popViewController(animated: true)
    }
}

extension AlbumDetailsVC : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: CellConstant.SEARCH_DETAIL_TRACKS_CELL) {
            cell.textLabel?.text = tracks[indexPath.row].name
            cell.detailTextLabel?.text = "\(tracks[indexPath.row].duration ?? "00.00")"
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
