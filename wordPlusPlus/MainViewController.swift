//
//  MainViewController.swift
//  wordPlusPlus
//
//  Created by David Lam on 6/10/16.
//  Copyright © 2016 David Lam. All rights reserved.
//

import UIKit
import AVFoundation
import RandomColorSwift
import DynamicColor
import RxSwift
import RxCocoa

enum PlayState {
    case play
    case pause
}

enum PlayMode {
    case repeatAll
    case repeatOne
    case shuffle
    
    mutating func toggle() {
        switch self {
        case .repeatAll:
            self = .repeatOne
        case .repeatOne:
            self = .shuffle
        case .shuffle:
            self = .repeatAll
        }
    }
    
    func iconForState() -> UIImage? {
        switch self {
        case .repeatAll:
            return #imageLiteral(resourceName: "ic_play_arrow")
        case .repeatOne:
            return #imageLiteral(resourceName: "ic_repeat_one")
        case .shuffle:
            return #imageLiteral(resourceName: "ic_shuffle")
        }
    }
}

struct ViewModel {
    
    var playState: PlayState = .pause
    var playMode: PlayMode = .repeatAll
    
    var indexForWord = 0
 
}

class MainViewController: UIViewController {

    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet var swipeGestureRecognizer: UISwipeGestureRecognizer!
    @IBOutlet var tapGestureRecognizer: UITapGestureRecognizer!
    let words =  TextParser.parseText()
    
    func myFrom<E>(sequence: [E]) -> Observable<E> {
        return Observable.create { observer in
            for element in sequence {
                observer.on(.next(element))
            }
            
            observer.on(.completed)
            return Disposables.create()
        }
    }
    
    
    
    let speechSynthesizer = AVSpeechSynthesizer()
    
    var currentWord : String = "" {
        didSet {
            let speechUtterance = AVSpeechUtterance(string: currentWord)
//            speechUtterance.voice = AVSpeechVoice()
            speechSynthesizer.speak(speechUtterance)
            textLabel.text = currentWord
            let newColor = randomColor(luminosity: Luminosity.bright)
            textLabel.textColor = newColor
            self.view.backgroundColor = newColor.complemented()
        }
    }

    var viewModel = ViewModel()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        speechSynthesizer.delegate = self
        
        setupAudioSession()
        setupGestureRecognizer()
        textLabel.text = "Tap to start"
        speechSynthesizer.continueSpeaking()
        
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
    
    fileprivate func createStreamFromWords() -> Observable<String> {
        return Observable.create { observer in
            for word in self.words {
                observer.on(.next(word))
            }
            observer.on(.completed)
            return Disposables.create()
        }
    }
    
    fileprivate func setupGestureRecognizer() {
        tapGestureRecognizer.addTarget(self, action: #selector(self.updatePlayState))
        swipeGestureRecognizer.direction = UISwipeGestureRecognizerDirection.up
        swipeGestureRecognizer.addTarget(self, action: #selector(self.didRecieveSwipe(gestRecognizer:)))
    }
    
    func updatePlayState() {
        switch viewModel.playState {
        case .play:
            viewModel.playState = .pause
            textLabel.text = "Tap to resume"
        case .pause:
            viewModel.playState = .play
            currentWord = words[viewModel.indexForWord]
        }
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
    
    func nextWord() {
        guard viewModel.playState == .play else {
            return
        }
        viewModel.indexForWord = viewModel.indexForWord + 1
        if viewModel.indexForWord > words.count {
            viewModel.indexForWord = 0
        }
        currentWord = words[viewModel.indexForWord]

    }

}

// MARK: - SpeechSynthesizer Delegate

extension MainViewController: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        nextWord()
    }
}

