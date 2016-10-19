//
//  SettingsViewController.swift
//  wordPlusPlus
//
//  Created by David Lam on 12/10/16.
//  Copyright © 2016 David Lam. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

final class SettingsViewController: UIViewController {
    @IBAction func didClickDone(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    var languageDictionary = [String: String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLanguageDictionary()
        
    }
    
    fileprivate func setupLanguageDictionary() {
        let voices = AVSpeechSynthesisVoice.speechVoices()
        let languages = voices.filter { $0.language.contains("en")}
                                .map{ $0.language}
        let currentLocale = Locale.current
        languages.forEach { (language) in
            languageDictionary[language] = currentLocale.localizedString(forLanguageCode: language)
        }
        print(languageDictionary)
    }
    
    /*
     NSArray *voices = [AVSpeechSynthesisVoice speechVoices];
     NSArray *languages = [voices valueForKey:@"language"];
     
     NSLocale *currentLocale = [NSLocale autoupdatingCurrentLocale];
     NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
     for (NSString *code in languages)
     {
     dictionary[code] = [currentLocale displayNameForKey:NSLocaleIdentifier value:code];
     }
     _languageDictionary = dictionary;
     */
}
