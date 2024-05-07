//
//  AudioPlayer.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 03/09/21.
//

import Foundation
import AVFoundation

protocol JukeboxDelegate {
    func jukeboxDidFinishPlaying()
}

class Jukebox: NSObject, AVAudioPlayerDelegate {
    
    static var audioPlayer = AVAudioPlayer()
    var jukeboxDelegate: JukeboxDelegate?
    
    func playBackgroundMusic() {
        guard let url = Bundle.main.url(forResource: "WelcomeToLuvo", withExtension: "mp3") else {
            print("url not found")
            return
        }
        
        do {
            /// this codes for making this app ready to takeover the device audio
            try AVAudioSession.sharedInstance().setCategory(.soloAmbient, mode: .default, options: .duckOthers)    //.playback - Continues to play audio on silent and lock screen.
            try AVAudioSession.sharedInstance().setActive(true)
            
            /// change fileTypeHint according to the type of your audio file (you can omit this)
            /// for iOS 11 onward, use :            
            Jukebox.audioPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            Jukebox.audioPlayer.delegate = self
            // no need for prepareToPlay because prepareToPlay is happen automatically when calling play()
            Jukebox.audioPlayer.numberOfLoops = 0
            Jukebox.audioPlayer.play()
        } catch let error as NSError {
            print("error: \(error.localizedDescription)")
        }
    }
    
    func stopBackgroundMusic() {
        Jukebox.audioPlayer.stop()
        do {
            try AVAudioSession.sharedInstance().setActive(false)
            debugPrint("audio stopped playing --->")
        } catch let error as NSError {
            debugPrint("stopBackgroundMusic Error - \(error)")
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        debugPrint("audio did finish playing --->")
        self.jukeboxDelegate?.jukeboxDidFinishPlaying()
    }
    
}
