//
//  CreationViewController.swift
//  FlashcardsMagic
//
//  Created by Jessie G on 10/21/18.
//  Copyright © 2018 Jessie Gross. All rights reserved.
//

import UIKit
// CreationViewController is a subset 
class CreationViewController: UIViewController {

    // To allow access to the flashcards view controller
    var flashcardsController: ViewController!
    
    @IBOutlet weak var questionTextField: UITextField!
    @IBOutlet weak var answerTextField: UITextField!
    
    @IBOutlet weak var extraAnsOneTextField: UITextField!
    @IBOutlet weak var extraAnsTwoTextField: UITextField!
    
    var initialQuestion: String? // '?' allows nil in the string otherwise you are saying that there is something in the string with '!'
    var initialAnswer: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        questionTextField.text = initialQuestion
        answerTextField.text = initialAnswer
    }
    // Dismisses this current view controller to revert back to the previous one.
    @IBAction func didTapOnCancel(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func didTapOnDone(_ sender: Any) {
        // Get the text in the question text field
        let questionText = questionTextField.text
        
        // Get the text in the answer text field
        let answerText = answerTextField.text
        
        let extraAnsOneText = extraAnsOneTextField.text
        
        let extraAnsTwoText = extraAnsTwoTextField.text
        
        // Check if empty
        if questionText == nil || answerText == nil || questionText!.isEmpty || answerText!.isEmpty {
            let alert = UIAlertController(title: "Missing text!", message: "You need to enter both a question and an answer.", preferredStyle: .alert)
            
            present(alert, animated: true)
            
            let okAction = UIAlertAction(title: "Ok", style: .default)
            alert.addAction(okAction)
        }
        else {
            // Call the function to update the flashcard
            flashcardsController.updateFlashcard(question: questionText!, answer: answerText!, extraAnswerOne: extraAnsOneText, extraAnswerTwo: extraAnsTwoText)
            
            // Dismiss
            dismiss(animated: true)
            
        }
      
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
