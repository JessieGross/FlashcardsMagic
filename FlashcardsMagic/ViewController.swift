//
//  ViewController.swift
//  FlashcardsMagic
//
//  Created by Jessie G on 10/12/18.
//  Copyright © 2018 Jessie Gross. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var frontLabel: UILabel!
    @IBOutlet weak var backLabel: UILabel!
    @IBOutlet weak var thinkEmoji: UILabel!
    @IBOutlet weak var card: UIView!
    
    @IBOutlet weak var btnOptionOne: UIButton!
    @IBOutlet weak var btnOptionTwo: UIButton!
    @IBOutlet weak var btnOptionThree: UIButton!
    
    
    
    // func that automatically gets called by iOS as soon as the app is opened.
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // round the corners of the card by rounding the labels
        card.layer.cornerRadius = 20.0
        frontLabel.layer.cornerRadius = 20.0
        backLabel.layer.cornerRadius = 20.0
        btnOptionOne.layer.cornerRadius = 20.0
        btnOptionTwo.layer.cornerRadius = 20.0
        btnOptionThree.layer.cornerRadius = 20.0
        
        // clip the labels
        frontLabel.clipsToBounds = true
        backLabel.clipsToBounds = true
        
        // add shadow to to the card.
        card.layer.shadowRadius = 15.0
        card.layer.shadowOpacity = 10.2
        
        // button borders
        btnOptionOne.layer.borderWidth = 3.0
        btnOptionOne.layer.borderColor = #colorLiteral(red: 0.05793678676, green: 0.8387394096, blue: 1, alpha: 1)
        btnOptionTwo.layer.borderWidth = 3.0
        btnOptionTwo.layer.borderColor = #colorLiteral(red: 0.05793678676, green: 0.8387394096, blue: 1, alpha: 1)
        btnOptionThree.layer.borderWidth = 3.0
        btnOptionThree.layer.borderColor = #colorLiteral(red: 0.05793678676, green: 0.8387394096, blue: 1, alpha: 1)
        
    }
    
    // A func that will get called automatically on this controller and it will get called right before doing the presentation.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigationController = segue.destination as! UINavigationController
        let creationController = navigationController.topViewController as! CreationViewController
        creationController.flashcardsController = self
        
        // Updates this func with the initial values instead of setting the text field's text directly.
        
        if segue.identifier == "EditSegue" {
            creationController.initialQuestion = frontLabel.text
            creationController.initialAnswer = backLabel.text
        }
    }

    @IBAction func didTapOnFlashcard(_ sender: Any) {
        // When the card, frontLabel, is tapped hide it from the user to reveal the back of card, backLabel.
        if frontLabel.isHidden == false {
            frontLabel.isHidden = true
            thinkEmoji.isHidden = true
        }
        else {
            frontLabel.isHidden = false
            thinkEmoji.isHidden = false
        }
    }
    
    @IBAction func didTapOptionOne(_ sender: Any) {
        btnOptionOne.isHidden = true
    }
    
    @IBAction func didTapOptionTwo(_ sender: Any) {
        frontLabel.isHidden = true
        thinkEmoji.isHidden = true
        btnOptionOne.isHidden = true
        btnOptionThree.isHidden = true
    }
    
    @IBAction func didTapOptionThree(_ sender: Any) {
        btnOptionThree.isHidden = true
    }
    
    func updateFlashcard(question: String, answer: String, extraAnswerOne: String?, extraAnswerTwo: String?) {
        frontLabel.text = question
        backLabel.text = answer
        
        // shuffle the answer choices
        // var choices = [answer, extraAnswerOne, extraAnswerTwo]
        // choices.shuffle()
        // btnOptionOne.setTitle(choices[0], for: .normal)
        // btnOptionTwo.setTitle(choices[1], for: .normal)
        // btnOptionThree.setTitle(choices[2], for: .normal)
        
        // Set the title on the 3 buttons to show the multiple choices
        btnOptionOne.setTitle(extraAnswerTwo, for: .normal)
        btnOptionTwo.setTitle(answer, for: .normal)
        btnOptionThree.setTitle(extraAnswerOne, for: .normal)
    }
    
}

