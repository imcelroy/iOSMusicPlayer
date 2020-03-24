//
//  GenreButtonScreen.swift
//  MusicPlayer
//
//  Created by ianmcelroy on 3/22/20.
//  Copyright © 2020 Ian McElroy. All rights reserved.
//

import UIKit
import MediaPlayer
//import MarqueeLabel

class GenreButtonScreen: UIViewController {
    
    var musicPlayer = MPMusicPlayerController.systemMusicPlayer

    override func viewDidLoad() {
        super.viewDidLoad()


    }


    @IBAction func genreButtonTapped(_ sender: UIButton) {
        
            MPMediaLibrary.requestAuthorization{  (status) in
                if status == .authorized {
                    DispatchQueue.main.async { [weak self] in
                    self?.playGenre(genre: sender.currentTitle!)
                }
            }
                
        }
    }
    
    
    @IBAction func pauseButtonTapped(_ sender: UIButton) {
        DispatchQueue.main.async { [weak self] in
            if self?.musicPlayer.playbackState == MPMusicPlaybackState.paused{
                print(String(format: "current song name = %@ ", (self?.musicPlayer.nowPlayingItem)?.title ?? "no name"))
                self?.musicPlayer.play()
                self?.updateCurrentSongDisplay()
            } else{
                print(String(format: "current song name = %@ ", (self?.musicPlayer.nowPlayingItem)?.title ?? "no name"))
                self?.musicPlayer.pause()
                self?.updateCurrentSongDisplay()
            }
        }
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        DispatchQueue.main.async { [weak self] in
            let song = self?.musicPlayer.nowPlayingItem?.title
            var newSong = self?.musicPlayer.nowPlayingItem?.title
            
            self?.musicPlayer.skipToNextItem()
            self?.musicPlayer.play()
            
            while newSong == song{
                print(String(format: "current song name = %@ ", song ?? "no name"))
                print(String(format: "new song name = %@ ", newSong ?? "no name"))
                newSong = self?.musicPlayer.nowPlayingItem?.title
            }
            print(String(format: "current song name = %@ ", song ?? "no name"))
            print(String(format: "new song name = %@ ", newSong ?? "no name"))
            self?.updateCurrentSongDisplay()
        }
    }
    
    @IBAction func previousButtonTapped(_ sender: UIButton) {
        
        DispatchQueue.main.async { [weak self] in
            let song = self?.musicPlayer.nowPlayingItem?.title
            var newSong = self?.musicPlayer.nowPlayingItem?.title
            
            self?.musicPlayer.skipToPreviousItem()
            self?.musicPlayer.play()
            
            if self?.musicPlayer.indexOfNowPlayingItem != 0{
                while newSong == song{
                    print(String(format: "current song name = %@ ", song ?? "no name"))
                    print(String(format: "new song name = %@ ", newSong ?? "no name"))
                    newSong = self?.musicPlayer.nowPlayingItem?.title
                }
                print(String(format: "current song name = %@ ", song ?? "no name"))
                print(String(format: "new song name = %@ ", newSong ?? "no name"))
                self?.updateCurrentSongDisplay()
            }
        }
    }
    
    func playGenre(genre: String){
        DispatchQueue.main.async { [weak self] in
            self?.musicPlayer.stop()
            
            let query = MPMediaQuery()
            let predicate = MPMediaPropertyPredicate(value: genre, forProperty: MPMediaItemPropertyGenre)
            
            query.addFilterPredicate(predicate)
            
            self?.musicPlayer.setQueue(with: query)
            self?.musicPlayer.shuffleMode = .songs
            self?.musicPlayer.play()
            
            self?.updateCurrentSongDisplay()
        }
    }
    
    @IBOutlet weak var albumCoverImage: UIImageView!

    @IBOutlet weak var songLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var albumLabel: UILabel!
    
    
    
    func updateCurrentSongDisplay() {
        DispatchQueue.main.async { [weak self] in
            //update cover
            let song = self?.musicPlayer.nowPlayingItem
            
            self?.albumCoverImage.image = song?.artwork?.image(at: CGSize(width: 200, height: 200))
            
            self?.albumCoverImage.startAnimating()

            //update song title
            self?.songLabel.text = song?.title

            //update song artist
            self?.artistLabel.text = song?.albumArtist
            
            
            //update song album
            self?.albumLabel.text = song?.albumTitle
            
        }
    }

}
