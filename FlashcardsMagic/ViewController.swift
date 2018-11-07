//
//  ViewController.swift
//  FlashcardsMagic
//
//  Created by Jessie G on 10/12/18.
//  Copyright © 2018 Jessie Gross. All rights reserved.
//

import UIKit

// This struct enables the object flashcard to be declared as a 'Flashcard' struct type with two properties 'question' and 'answer'.
struct Flashcard {
    var question: String
    var answer: String
}

class ViewController: UIViewController {
    
    @IBOutlet weak var frontLabel: UILabel!
    @IBOutlet weak var backLabel: UILabel!
    @IBOutlet weak var thinkEmoji: UILabel!
    @IBOutlet weak var card: UIView!
    
    @IBOutlet weak var btnOptionOne: UIButton!
    @IBOutlet weak var btnOptionTwo: UIButton!
    @IBOutlet weak var btnOptionThree: UIButton!
    
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    
    // Array to store many flashcards. Do not confuse it with flashcard (singular) which is a Struct variable.
    var flashcards = [Flashcard]()
    
    // Current flashxard index
    var currentIndex = 0
    
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
        
        // Read saved flashcards
        readSavedFlashcards()
        
        // Add initial or default flashcard if needed
        if flashcards.count == 0 {
            updateFlashcard(question: "How old is the universe?", answer: "13.8 billion years", extraAnswerOne: "4.5 billion years", extraAnswerTwo: "2,018 years")
        } else { // Update info from the saved cards
            updateLabels()
            updateNextPrevButtons()
        }
    }
    
    // A func that will get called automatically on this controller and it will get called right before doing the presentation.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // The destination of the segue is the Navigation Controller
        let navigationController = segue.destination as! UINavigationController
        
        // The Navigation Controller only contains a Creation View Controller
        let creationController = navigationController.topViewController as! CreationViewController
        
        // Set the flashcardsController property to self
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
    
    @IBAction func didTapOnPrev(_ sender: Any) {
        
        // Decrease current index
        currentIndex = currentIndex - 1
        
        // Update labels
        updateLabels()
        
        // Update buttons
        updateNextPrevButtons()
    }
    
    @IBAction func didTapOnNext(_ sender: Any) {
        
        // Increase current index
        currentIndex = currentIndex + 1
        
        // Update labels
        updateLabels()
        
        // Update buttons
        updateNextPrevButtons()
    }
    
    
    func updateFlashcard(question: String, answer: String, extraAnswerOne: String?, extraAnswerTwo: String?) {
        // defines and assignes the flashcard variable to be the Flashcard struct type.
        let flashcard = Flashcard(question: question, answer: answer)
        
        //frontLabel.text = flashcard.question
        //backLabel.text = flashcard.answer
        
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
        
        // Reset the front label and buttons to appear everytime the user edits the flashcards
        btnOptionOne.isHidden = false
        btnOptionThree.isHidden = false
        frontLabel.isHidden = false
        thinkEmoji.isHidden = false
        
        // Adding flashcard in the flashcards array
        flashcards.append(flashcard)
        
        // Logging to the console
        print("➕ Added new flashcard ")
        print("🐶 We have now \(flashcards.count) flashcards")
        
        // Update current index
        currentIndex = flashcards.count - 1
        print("🦁 Our current index is \(currentIndex)")
        
        // Update buttons
        updateNextPrevButtons()
        
        // Update labels
        updateLabels()
    }
    
    func updateNextPrevButtons() {
        // Disable next button if at the end
        if currentIndex == flashcards.count - 1 {
            nextButton.isEnabled = false
        } else {
            nextButton.isEnabled = true
        }
        
        // Disable prev button if at the beginning
        if currentIndex == 0 {
            prevButton.isEnabled = false
        } else {
            prevButton.isEnabled = true
        }
    }
    
    func updateLabels() {
        // Get current flashcard
        let currentFlashcard = flashcards[currentIndex]
        
        // Update labels
        frontLabel.text = currentFlashcard.question
        backLabel.text = currentFlashcard.answer
    }
    
    func saveAllFlashcardsToDisk() {

        // From flashcard array to dictionary array
        let dictionaryArray = flashcards.map { (card) -> [String: String] in
            return ["question": card.question, "answer": card.answer]
        }
        
        // Save array on disk using UserDefaults
        UserDefaults.standard.set(dictionaryArray, forKey: "flashcards")
        
        // Log it
        print("🎉 Flashcards saved to UserDefaults")
    }
    
    func readSavedFlashcards() {
        
        // Read dictionary array from disk (if any)
        if let dictionaryArray = UserDefaults.standard.array(forKey: "flashcards") as? [[String: String]] {
            
            // From dictionary array to flashcard array
            let savedCards = dictionaryArray.map { dictionary -> Flashcard in
                return Flashcard(question: dictionary["question"]!, answer: dictionary["answer"]!)
            }
            
            // Put all these cards in our flashcards array
            flashcards.append(contentsOf: savedCards)
            
        }
    }
    
}

