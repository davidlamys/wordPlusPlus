//
//  PlayerViewModel.swift
//  wordPlusPlus
//
//  Created by David Lam on 23/10/16.
//  Copyright © 2016 David Lam. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
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

struct PlayerViewModel {
    
    var playState: PlayState = .pause
    var playMode: PlayMode = .repeatAll
    
    var indexForWord = 0
    var volume : Float = 1.0
    
    let words =  TextParser.parseText()
    
    let speechSynthesizer = AVSpeechSynthesizer()
    
    var currentWordSignal : PublishSubject<String> = PublishSubject<String>()
    
    mutating func updatePlayState() {
        switch self.playState {
        case .play:
            self.playState = .pause
        case .pause:
            self.playState = .play
            currentWord = words[self.indexForWord]
        }
    }
    
    var currentWord : String = "" {
        didSet {
            let speechUtterance = AVSpeechUtterance(string: currentWord)
            speechUtterance.volume = volume
            speechSynthesizer.speak(speechUtterance)
            currentWordSignal.onNext(currentWord)
        }
    }
    
    mutating func nextWord() {
        guard self.playState == .play else {
            return
        }
        self.indexForWord = self.indexForWord + 1
        if self.indexForWord > self.words.count {
            self.indexForWord = 0
        }
        currentWord = words[self.indexForWord]
    }
}

