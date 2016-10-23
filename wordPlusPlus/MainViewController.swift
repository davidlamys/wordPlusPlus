//
//  MainViewController.swift
//  wordPlusPlus
//
//  Created by David Lam on 6/10/16.
//  Copyright © 2016 David Lam. All rights reserved.
//

import UIKit
import RandomColorSwift
import AVFoundation
import DynamicColor
import RxSwift
import RxCocoa



class MainViewController: UIViewController {

    @IBOutlet weak var volumeControlSlider: UISlider!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet var swipeGestureRecognizer: UISwipeGestureRecognizer!
    @IBOutlet var tapGestureRecognizer: UITapGestureRecognizer!
    
    let disposeBag = DisposeBag()

    var viewModel = PlayerViewModel()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.speechSynthesizer.delegate = self
        
        setupAudioSession()
        setupGestureRecognizer()
        textLabel.text = "Tap to start"
        viewModel.speechSynthesizer.continueSpeaking()
        
        _ = volumeControlSlider.rx.value.asControlProperty()
        .subscribe(onNext: { (sliderValue) in
            self.viewModel.volume = sliderValue
        }).addDisposableTo(self.disposeBag)
        
        _ = viewModel.currentWordSignal.subscribe(onNext: { (newWord) in
            let newColor = randomColor(luminosity: Luminosity.bright)
            self.textLabel.textColor = newColor
            self.view.backgroundColor = newColor.complemented()
            
            self.textLabel.text = newWord
        })
        
    }
    
    fileprivate func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, mode: AVAudioSessionModeSpokenAudio, options: AVAudioSessionCategoryOptions.mixWithOthers)
            try AVAudioSession.sharedInstance().setActive(true)
        }
        catch {
            NSLog("error found")
        }
    }
    
    fileprivate func setupGestureRecognizer() {
        tapGestureRecognizer.addTarget(self, action: #selector(self.updatePlayState))
        swipeGestureRecognizer.direction = UISwipeGestureRecognizerDirection.up
        swipeGestureRecognizer.addTarget(self, action: #selector(self.didRecieveSwipe(gestRecognizer:)))
    }
    
    func didRecieveSwipe(gestRecognizer: UISwipeGestureRecognizer) {
        switch gestRecognizer.direction {
        case UISwipeGestureRecognizerDirection.left:
            NSLog("to the left")
        case UISwipeGestureRecognizerDirection.right:
            NSLog("to the right")
        default:
            NSLog("i don't really care")
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updatePlayState() {
        self.viewModel.updatePlayState()
        switch self.viewModel.playState {
        case .play:
            break
        case .pause:
            textLabel.text = "Tap to resume"
        }

    }

}

// MARK: - SpeechSynthesizer Delegate

extension MainViewController: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        viewModel.nextWord()
    }
}
