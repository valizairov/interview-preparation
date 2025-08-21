/*
 Each class should have one reason to change
 Create a music app that downloads tracks and plays them
 Do not mix network UI or playback logic
 */


import Foundation
import AVFoundation
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true


// Only fetches the track
class TrackFetcher {
    func fetchTrack(url: URL, completion: @escaping @Sendable (Data?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard error == nil else {
                print("Error fetching track: ", error!)
                completion(nil)
                return
            }
            completion(data)
        }
        task.resume()
    }
}


// Only plays the tracks
@MainActor
class TrackPlayer {
    private var player: AVAudioPlayer?
    
    func playTrack(data: Data) {
        do {
            player = try AVAudioPlayer(data: data)
            player?.play()
        } catch {
            print("Error playing track: ", error)
        }
    }
    
    func stop() {
        player?.stop()
    }
    
    // For testing
    var isPlayerInitialized: Bool {
        return player != nil
    }
}


// Put everything together
let fetcher = TrackFetcher()
let player = TrackPlayer()

//if let url = URL(string: "https://www.backstreetboys.com/downloads/albums/millenium/i-want-it-that-way.mp3") {
if let url = Bundle.main.url(forResource: "i-want-it-that-way", withExtension: "m4a") {
    fetcher.fetchTrack(url: url) { data in
        guard let song = data else {
            print("Failed to fetch the track")
            return
        }
        Task { @MainActor in
            player.playTrack(data: song)
            print("Playing song ...")
        }
    }
}


// Unit Testing
func testTrackPlayer() {
    Task { @MainActor in
        let player = TrackPlayer()
        if let url = Bundle.main.url(forResource: "mock_song", withExtension: "mp3") {
            do {
                let data = try Data(contentsOf: url)
                player.playTrack(data: data)
                assert(player.isPlayerInitialized, "Player should be initialized")
            } catch {
                assertionFailure("Failed to load a song")
            }
        }
    }
}
