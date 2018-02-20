//
//  ViewController.swift
//  MovieQuiz
//
//  Created by Jair Guedes Ferreira Neto on 13/2/18.
//  Copyright © 2018 Pay Back $istemas. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var viSoundBar: UIView!
    @IBOutlet weak var slMusic: UISlider!
    @IBOutlet var btOptions: [UIButton]!
    @IBOutlet weak var ivQuiz: UIImageView!
    @IBOutlet weak var viTimer: UIView!
    
    var quizManager: QuizManager!
    var quizPlayer: AVAudioPlayer!
    var playerItem: AVPlayerItem!
    var bgMusicPlayer: AVPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playBgMusic()
        viSoundBar.isHidden = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        quizManager = QuizManager()
        getNewQuiz()
        startTime()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! GameOverViewController
        vc.score = quizManager.score
    }
    
    func playBgMusic() {
        let musicUrl = Bundle.main.url(forResource: "MarchaImperial", withExtension: "mp3")!
        playerItem = AVPlayerItem(url: musicUrl)
        bgMusicPlayer = AVPlayer(playerItem: playerItem)
        bgMusicPlayer.volume = 0.1
        bgMusicPlayer.play()
        bgMusicPlayer.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, 1), queue: nil) { (time) in
            let percent = time.seconds / self.playerItem.duration.seconds
            self.slMusic.setValue(Float(percent), animated: true)
        }
        
    }
    
    func startTime() {
        viTimer.frame = view.frame
        UIView.animate(withDuration: 60.0, delay: 0, options: .curveLinear, animations: {
            self.viTimer.frame.size.width = 0
            self.viTimer.frame.origin.x = self.view.center.x
        }) { (success) in
            self.gameOver()
        }
    }
    
    func gameOver() {
        performSegue(withIdentifier: "gameOverSegue", sender: nil)
        quizPlayer.stop()
    }
    
    @IBAction func playQuiz() {
        guard let round = quizManager.round else {return}
        ivQuiz.image = #imageLiteral(resourceName: "movieSound")
        if let url = Bundle.main.url(forResource: "quote\(round.quiz.number)", withExtension: "mp3") {
            do {
                self.quizPlayer = try AVAudioPlayer(contentsOf: url)
                self.quizPlayer.volume = 1
                self.quizPlayer.delegate = self
                self.quizPlayer.play()
                
            }catch {
                
            }
        }
    }
    
    func getNewQuiz() {
        let round = quizManager.generateRandomQuiz()
        for i in 0 ..< round.options.count {
            btOptions[i].setTitle(round.options[i].name, for: .normal)
            
        }
        playQuiz()
    }

    @IBAction func checkAnwser(_ sender: UIButton) {
        quizManager.checkAnswer(answer: sender.title(for: .normal)!)
        getNewQuiz()
    }
    @IBAction func changeMusicTime(_ sender: UISlider) {
        bgMusicPlayer.seek(to: CMTimeMakeWithSeconds(Double(sender.value) * playerItem.duration.seconds, 1))
    }
    @IBAction func changeMusicStatus(_ sender: UIButton) {
        if bgMusicPlayer.timeControlStatus == .paused {
            bgMusicPlayer.play()
            sender.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
        }else {
            bgMusicPlayer.pause()
            sender.setImage(#imageLiteral(resourceName: "play"), for: .normal)
        }
    }
    @IBAction func showHideSoundBar(_ sender: UIButton) {
        viSoundBar.isHidden = !viSoundBar.isHidden
    }
}

extension ViewController: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        ivQuiz.image = #imageLiteral(resourceName: "movieSoundPause")
    }
}
