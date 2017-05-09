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
    var album: AlbumModel?
    var albumImage: UIImage?
    var tracks: [TrackModel] = [] {
        didSet {
            album?.set(tracks: tracks)
            for track in tracks {
                if let duration = Double(track.trackDuration) {
                    let formatedDuration = Utils.timeString(time: duration)
                    track.set(duration: formatedDuration)
                }
            }
            tableView.reloadData()
        }
    }
    
    private var context: NSManagedObjectContext?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
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
        apiService.downloadInfo(albumName: album.name, forArtist: album.artist) { [weak self] (albumId) in
            self?.saveButton.isEnabled = true
            self?.activityIndicator.isHidden = true
            self?.activityIndicator.stopAnimating()
            self?.tracks = apiService.arrayOfTracks
            if let id = albumId {
                album.set(id: id)
                print(id)
            }
        }
    }
    
    @IBAction func saveAlbum(_ sender: UIBarButtonItem) {  
        if albumDataCorrect {
            if let context = context {
                context.perform {[weak self] in
                    if let image = self?.albumImage {
                        let imageData:NSData? = UIImagePNGRepresentation(image) as NSData?                         
                        if let data = imageData, let album = self?.album {
                            Album.addNewAlbumToDatabase(albumModel: album, with: data, context: context) { [weak self] (saved) in
                                if saved {
                                    self?.saveButton.title = "Saved"
                                    Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self?.goBackToSearch), userInfo: nil, repeats: false)
                                }
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
    
    private var albumDataCorrect:Bool {
        //TODO: Check if data is correct and if not issue alert
        return true
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
