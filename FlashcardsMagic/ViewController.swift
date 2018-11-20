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
    var extraAnswerOne: String?
    var extraAnswerTwo: String?
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
    
    // Button to remember what the correct answer is.
    var correctAnswerButton: UIButton!
    
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
            updateFlashcard(question: "How old is the universe?", answer: "13.8 billion years", extraAnswerOne: "4.5 billion years", extraAnswerTwo: "2,018 years", isExisting: false)
        } else { // Update info from the saved cards
            updateLabels()
            updateNextPrevButtons()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Fist start with the flashcard invisible and slightly smaller in size
        card.alpha = 0.0
        card.transform = CGAffineTransform.identity.scaledBy(x: 0.75, y: 0.75)
        
        // Fist start with the multiple choice buttons invisible and slightly smaller in size
        btnOptionOne.alpha = 0.0
        btnOptionOne.transform = CGAffineTransform.identity.scaledBy(x: 0.75, y: 0.75)
        btnOptionTwo.alpha = 0.0
        btnOptionTwo.transform = CGAffineTransform.identity.scaledBy(x: 0.75, y: 0.75)
        btnOptionThree.alpha = 0.0
        btnOptionThree.transform = CGAffineTransform.identity.scaledBy(x: 0.75, y: 0.75)
        
        // Animation
        UIView.animate(withDuration: 0.6, delay: 0.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.6, options: [], animations: {
            self.card.alpha = 1.0
            self.card.transform = CGAffineTransform.identity
            
            self.btnOptionOne.alpha = 1.0
            self.btnOptionOne.transform = CGAffineTransform.identity
            self.btnOptionTwo.alpha = 1.0
            self.btnOptionTwo.transform = CGAffineTransform.identity
            self.btnOptionThree.alpha = 1.0
            self.btnOptionThree.transform = CGAffineTransform.identity
        })
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
        flipFlashcard()
    }
    
    func flipFlashcard() {
        // Code that was in didTapOnFlashcard was moved here.
        
        UIView.transition(with: card, duration: 0.3, options: .transitionFlipFromBottom, animations: {
            // Note: Need explicit "self." when referencing an IBOutlet
            if self.frontLabel.isHidden == false {
                self.frontLabel.isHidden = true
                self.thinkEmoji.isHidden = true
            }
            else {
                self.frontLabel.isHidden = false
                self.thinkEmoji.isHidden = false
            }
        })
    }
    
    // A func that animates the next card by animating the current card out
    func animateCardOut() {
        
        // Animate to the left side of the screen
        UIView.animate(withDuration: 0.3, animations: {
            self.card.transform = CGAffineTransform.identity.translatedBy(x: -300.0, y: 0.0)
        }, completion: { finished in
            
            // Update labels
            self.updateLabels()
            
            // Run other animation
            self.animateCardIn()
            
        })
    }
    
    func frontLabelCheck() {
        // If the current flashcard has the answer (backLabel) revealed and the user taps on the next button, then the question (frontLabel) of the next card should appear. Otherwise, the answer of the next card will be shown.
        if frontLabel.isHidden == true {
            frontLabel.isHidden = false
            thinkEmoji.isHidden = false
        }
    }
    
    // A func that animates the next card in
    func animateCardIn() {
        
        // Show the front label (question) if it is hidden.
        frontLabelCheck()
        
        // Start on the right side (don't animate this)
        card.transform = CGAffineTransform.identity.translatedBy(x: 300.0, y: 0.0)
        
        // Animate card going back to its original position
        UIView.animate(withDuration: 0.3) {
            self.card.transform = CGAffineTransform.identity
        }
    }
    
    // A func that animates the previous card by animating the current card out
    func animateCardOut2() {
        
        // Animate to the right side of the screen
        UIView.animate(withDuration: 0.3, animations: {
            self.card.transform = CGAffineTransform.identity.translatedBy(x: 300.0, y: 0.0)
        }, completion: { finished in
            
            // Update labels
            self.updateLabels()
            
            // Run other animation
            self.animateCardIn2()
            
        })
    }
    
    // A func that animates the previous card in
    func animateCardIn2() {
        
        // Show the front label (question) if it is hidden.
        frontLabelCheck()
        
        // Start on the right side (don't animate this)
        card.transform = CGAffineTransform.identity.translatedBy(x: -300.0, y: 0.0)
        
        // Animate card going back to its original position
        UIView.animate(withDuration: 0.3) {
            self.card.transform = CGAffineTransform.identity
        }
    }
    
    @IBAction func didTapOptionOne(_ sender: Any) {
        // If correct answer flip flashcard, else disable button and show front label.
        if btnOptionOne == correctAnswerButton {
            flipFlashcard()
        }
        else {
            
            frontLabel.isHidden = false
            btnOptionOne.isHidden = false
        }
    }
    
    @IBAction func didTapOptionTwo(_ sender: Any) {
        // If correct answer flip flashcard, else disable button and show front label.
        if btnOptionTwo == correctAnswerButton {
            flipFlashcard()
        }
        else {
            frontLabel.isHidden = false
            btnOptionTwo.isHidden = false
        }
        
    }
    
    @IBAction func didTapOptionThree(_ sender: Any) {
        // If correct answer flip flashcard, else disable button and show front label.
        if btnOptionThree == correctAnswerButton {
            flipFlashcard()
        }
        else {
            frontLabel.isHidden = false
            btnOptionThree.isHidden = false
        }
    }
    
    @IBAction func didTapOnPrev(_ sender: Any) {
        
        // Decrease current index
        currentIndex = currentIndex - 1
        
        // Update labels
        //updateLabels()
        
        // Update buttons
        updateNextPrevButtons()
        
        // Animate the next card
        animateCardOut2()
    }
    
    @IBAction func didTapOnNext(_ sender: Any) {
        
        // Increase current index
        currentIndex = currentIndex + 1
        
        // Update labels
        //updateLabels()
        
        // Update buttons
        updateNextPrevButtons()
        
        // Animate the next card
        animateCardOut()
    }
    
    @IBAction func didTapOnDelete(_ sender: Any) {
        
        // Proceed in the deletion process if there is more than one flashcards
        if flashcards.count > 1 {
            // Show confirmation
            let alert = UIAlertController(title: "Delete flashcard", message: "Are you sure you want to delete it? 😨", preferredStyle: .actionSheet)

            let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { action in

                if self.flashcards.count > 1 {
                    self.deleteCurrentFlashCard()

                }
            }

            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

            present(alert, animated: true)

            alert.addAction(deleteAction)
            alert.addAction(cancelAction)
        } else { // otherwise do not allow deletion of your only card

            let alert2 = UIAlertController(title: "Delete flashcard", message: "Cannot delete your only card.😐", preferredStyle: .alert)

            let okAction = UIAlertAction(title: "Ok", style: .default)

            alert2.addAction(okAction)
            present(alert2, animated: true)
        }
        
    }
    
    func deleteCurrentFlashCard() {
        
        // Delete current flashcard
        flashcards.remove(at: currentIndex)
        
        // Special case: Check if last card was deleted
        if currentIndex > flashcards.count - 1 {
            currentIndex = flashcards.count - 1
        }
        
        print("🙈 We have now \(flashcards.count) flashcards")
        print("🙊 Index \(flashcards.count - 1)")
        
        // Update the labels and the next and prev buttons
        updateNextPrevButtons()
        updateLabels()
        
        // Update array of flashcards to the disk
        saveAllFlashcardsToDisk()
    }
    
    func updateFlashcard(question: String, answer: String, extraAnswerOne: String?, extraAnswerTwo: String?, isExisting: Bool) {
        
        // defines and assigns the flashcard variable to be the Flashcard struct type.
        let flashcard = Flashcard(question: question, answer: answer, extraAnswerOne: extraAnswerOne, extraAnswerTwo: extraAnswerTwo)
        
        if isExisting {
            
            // Replace existing flashcard
            flashcards[currentIndex] = flashcard
            
        } else {
            
            // Adding flashcard in the flashcards array
            flashcards.append(flashcard)
            
            // Logging to the console
            print("➕ Added new flashcard ")
            print("🐶 We have now \(flashcards.count) flashcards")
            
            // Update current index
            currentIndex = flashcards.count - 1
            print("🦁 Our current index is \(currentIndex)")
        }
        
        // Set the title on the 3 buttons to show the multiple choices
        btnOptionOne.setTitle(extraAnswerTwo, for: .normal)
        btnOptionTwo.setTitle(answer, for: .normal)
        btnOptionThree.setTitle(extraAnswerOne, for: .normal)
        
        // Reset the front label and buttons to appear everytime the user edits the flashcards
        btnOptionOne.isHidden = false
        btnOptionThree.isHidden = false
        frontLabel.isHidden = false
        thinkEmoji.isHidden = false
        
        // Update buttons
        updateNextPrevButtons()
        
        // Update labels
        updateLabels()
        
        // Save to disk
        saveAllFlashcardsToDisk()
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
        
        // Update buttons
        let buttons = [btnOptionOne, btnOptionTwo, btnOptionThree].shuffled()
        
        let answers = [currentFlashcard.answer, currentFlashcard.extraAnswerOne, currentFlashcard.extraAnswerTwo].shuffled()
        
        for (button, answer) in zip(buttons, answers) {
            // Set the tile of this random button with a random answer
            button?.setTitle(answer, for: .normal)
            
            // If this is the correct answer save the button
            if answer == currentFlashcard.answer {
                correctAnswerButton = button
            }
        }
    
    }
    
    func saveAllFlashcardsToDisk() {

        // From flashcard array to dictionary array
        let dictionaryArray = flashcards.map { (card) -> [String: String] in
            return ["question": card.question, "answer": card.answer, "extraAnswerOne": card.extraAnswerOne!, "extraAnswerTwo": card.extraAnswerTwo!]
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
                return Flashcard(question: dictionary["question"]!, answer: dictionary["answer"]!, extraAnswerOne: dictionary["extraAnswerOne"], extraAnswerTwo: dictionary["extraAnswerTwo"])
            }
            
            // Put all these cards in our flashcards array
            flashcards.append(contentsOf: savedCards)
            
        }
    }
    
}

