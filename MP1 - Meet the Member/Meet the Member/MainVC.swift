//
//  MainVC.swift
//  Meet the Member
//
//  Created by Michael Lin on 1/18/21.
//

import Foundation
import UIKit

class MainVC: UIViewController {
    
    // Create a property for our timer, we will initialize it in viewDidLoad
    var timer: Timer?
    
    // MARK: Stuff I added
    var runCount: Int = 0
    var longestStreak: Int = 0
    var currStreak: Int = 0
    var score: Int = 0
    var lastThree: [String] = ["", "", ""]
    
    // MARK: STEP 8: UI Customization
    // Customize your imageView and buttons. Run the app to see how they look.
    
    let imageView: UIImageView = {
        let view = UIImageView()
        
        // MARK: >> Your Code Here <<
    
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let buttons: [UIButton] = {
        // Creates 4 buttons, each representing a choice.
        // Use ..< or ... notation to create an iterable range
        // with step of 1. You can manually create these using the
        // stride() method.
        return (0..<4).map { index in
            let button = UIButton()

            // Tag the button its index
            button.tag = index
            button.backgroundColor = .blue
            
            // MARK: >> Your Code Here <<
            
            button.translatesAutoresizingMaskIntoConstraints = false
            
            return button
        }
        
    }()
    
    let scoreLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    
    let pauseButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.setTitle("Pause", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: STEP 12: Stats Button
    // Follow the examples you've learned so far, initialize a
    // stats button used for going to the stats screen, add it
    // as a subview inside the viewDidLoad and set up the
    // constraints. Finally, connect the button's with the @objc
    // function didTapStats.
    
    // MARK: >> Your Code Here <<
    
    let statButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("Stats", for: .normal)
        button.backgroundColor = .red
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        
        scoreLabel.text = "Score: " + String(self.score)
        
        // Create a timer that calls timerCallback() every one second
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerCallback), userInfo: nil, repeats: true)
        
        // If you don't like the default presentation style,
        // you can change it to full screen too! This way you
        // will have manually to call
        // dismiss(animated: true, completion: nil) in order
        // to go back.
        //
        // modalPresentationStyle = .fullScreen
        
        // MARK: STEP 7: Adding Subviews and Constraints
        // Add imageViews and buttons to the root view. Create constraints
        // for the layout. Then run the app with ⌘+r. You should see the image
        // for the first question as well as the four options.
        
        // MARK: >> Your Code Here <<
        
        view.addSubview(scoreLabel)
        
        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25),
            scoreLabel.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 25),
            scoreLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50)
        ])
        
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            imageView.bottomAnchor.constraint(equalTo:view.centerYAnchor, constant: 0)
        ])
        
        view.addSubview(buttons[0])
        
        NSLayoutConstraint.activate([
            buttons[0].topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant:50),
            buttons[0].leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            buttons[0].trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -10)
        ])
        view.addSubview(buttons[1])
        NSLayoutConstraint.activate([
            buttons[1].topAnchor.constraint(equalTo: view.centerYAnchor, constant:150),
            buttons[1].leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            buttons[1].trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -10)
        ])
        view.addSubview(buttons[2])
        NSLayoutConstraint.activate([
            buttons[2].topAnchor.constraint(equalTo: view.centerYAnchor, constant:50),
            buttons[2].leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 10),
            buttons[2].trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)
        ])
        view.addSubview(buttons[3])
        NSLayoutConstraint.activate([
            buttons[3].topAnchor.constraint(equalTo: view.centerYAnchor, constant:150),
            buttons[3].leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 10),
            buttons[3].trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)
        ])
        

        
        getNextQuestion()
        
        // MARK: STEP 10: Adding Callback to the Buttons
        // Use addTarget to connect the didTapAnswer function to the four
        // buttons touchUpInside event.
        //
        // Challenge: Try not to use four separate statements. There's a
        // cleaner way to do this, see if you can figure it out.
        
        // MARK: >> Your Code Here <<
        for n in 0...3 {
            buttons[n].addTarget(self, action: #selector(didTapAnswer(_:)), for: .touchUpInside)
        }
        
        // MARK: STEP 12: Stats Button
        // Follow instructions at :49
        
        // MARK: >> Your Code Here <<
        view.addSubview(statButton)
        
        NSLayoutConstraint.activate([
            statButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
//            statButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 670),
            statButton.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 50),
            statButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50)
        ])
        
        statButton.addTarget(self, action: #selector(didTapStats(_:)), for: .touchUpInside)
        
        
        view.addSubview(pauseButton)
        
        NSLayoutConstraint.activate([
            pauseButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25),
            pauseButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            pauseButton.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -50)
        ])
        
        pauseButton.addTarget(self, action: #selector(didTapPause(_:)), for: .touchUpInside)
    }
    
    // What's the difference between viewDidLoad() and
    // viewWillAppear()? What about viewDidAppear()?
    override func viewWillAppear(_ animated: Bool) {
        // MARK: STEP 15: Resume Game
        // Restart the timer when view reappear.
        
        // MARK: >> Your Code Here <<
        if let a = self.timer {
            self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.timerCallback), userInfo: nil, repeats: true)
        }
        runCount = 0
        
    }
    
    func getNextQuestion() {
        // MARK: STEP 5: Connecting to the Data Model
        // Read the QuestionProvider class in Utils.swift. Get an instance of
        // QuestionProvider.Question and use a *guard let* statement to conditionally
        // assign it to a constant named question. Return if the guard let
        // condition failed.
        //
        // After you are done, take a look at what's in the
        // QuestionProvider.Question type. You will need that for the
        // following steps.
        
        // MARK: >> Your Code Here <<
        guard let question = QuestionProvider.shared.getNextQuestion(),
              QuestionProvider.shared.namesToDisplay.count > 0 else {
            return
        }
        
        // MARK: STEP 6: Data Population
        // Populate the imageView and buttons using the question object we obtained
        // above.
        
        // MARK: >> Your Code Here <<
        imageView.image = question.image
        for n in 0...3 {
            buttons[n].setTitle(question.choices[n], for: .normal)
            buttons[n].accessibilityLabel = nil
            buttons[n].addTarget(self, action: #selector(didTapAnswer(_:)), for: .touchUpInside)
        }
        for n in 0...3 {
            if buttons[n].currentTitle == question.answer {
                buttons[n].accessibilityLabel = "answer"
            }
        }
//        self.runCount = 0
    }
    
    // This function will be called every one second
    @objc func timerCallback() {
        // MARK: STEP 11: Timer's Logic
        // Complete the callback for the one-second timer. Add instance
        // properties and/or methods to the class if necessary. Again,
        // the instruction here is intentionally vague, so read the spec
        // and take some time to plan. you may need
        // to come back and rework this step later on.
        
        // MARK: >> Your Code Here <<
        runCount += 1
        if runCount == 6 {
            self.timer?.invalidate()
            self.timer = nil
            currStreak = 0
            self.lastThree.append("Wrong")
            if self.lastThree.count > 3 {
                self.lastThree.remove(at: 0)
            }
            

            for button in buttons {
                if button.accessibilityLabel == "answer" {
                
                    
                    UIView.animate(withDuration: 1.0, delay: 0.0, animations: {
                    
                        button.backgroundColor = .green
                        
                        
                    }, completion: nil)
                    UIView.animate(withDuration: 1.0, delay: 0.0, animations: {
                    
                        button.backgroundColor = .blue
                        
                    }, completion: nil)
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {

                self.getNextQuestion()
                self.runCount = 0
                if self.timer == nil {
                    self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.timerCallback), userInfo: nil, repeats: true)
                }

                
            }
            
            
//            UIView.animate(withDuration: 2.0, delay: 2.0, animations:  {
//
//                self.getNextQuestion()
//            }, completion: nil)
//            runCount = 0
        }
        
    }
    
    @objc func didTapAnswer(_ sender: UIButton) {
        // MARK: STEP 9: Buttons' Logic
        // Add logic for the 4 buttons. Take some time to plan what
        // you are gonna write. The 4 buttons should be able to share
        // the same callback. Add instance properties and/or methods
        // to the class if necessary. The instruction here is
        // intentionally vague as I'd like you to decide what you
        // have to do based on the spec. You may need to come back
        // and rework this step later on.
        //
        // Hint: You can use `sender.tag` to identify which button is tapped
        
        // MARK: >> Your Code Here <<
        
        self.timer?.invalidate()
        self.timer = nil
//        for n in 0...3 {
//            buttons[n].removeTarget(self, action: #selector(didTapAnswer(_:)), for: .touchUpInside)
//        }
        let button = buttons[sender.tag]
        let buttonTitle = button.titleLabel!.text
        let compareImage = UIImage(named: buttonTitle!.lowercased().replacingOccurrences(of: " ", with: ""))
        
        if imageView.image!.isEqual(compareImage) {
            UIView.animate(withDuration: 1.0, delay: 0.0, animations: {
            
                button.backgroundColor = .green
                
                
            }, completion: nil)
            UIView.animate(withDuration: 1.0, delay: 0.0, animations: {
            
                button.backgroundColor = .blue
                
            }, completion: nil)
            self.currStreak += 1
            self.longestStreak = max(self.currStreak, self.longestStreak)
            self.lastThree.append("Correct")
            if self.lastThree.count > 3 {
                self.lastThree.remove(at: 0)
            }
            self.score += 1
            scoreLabel.text = "Score: " + String(self.score)
        } else {
            for button1 in buttons {
                if button1.accessibilityLabel == "answer" {
                    UIView.animate(withDuration: 1.0, delay: 0.0, animations: {
                        
                        button.backgroundColor = .red
                        button1.backgroundColor = .green
                        
                    }, completion: nil)
                    UIView.animate(withDuration: 1.0, delay: 0.0, animations: {
                    
                        button.backgroundColor = .blue
                        button1.backgroundColor = .blue
                    }, completion: nil)
                }
            }
            
            
            
            self.currStreak = 0
            self.lastThree.append("Wrong")
            if self.lastThree.count > 3 {
                self.lastThree.remove(at: 0)
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {

            self.getNextQuestion()
            self.runCount = 0
            if self.timer == nil {
                self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.timerCallback), userInfo: nil, repeats: true)
            }
        }
    }
    
    @objc func didTapStats(_ sender: UIButton) {
        
        self.timer?.invalidate()
        self.timer = nil
        runCount = 0
        
        let vc = StatsVC(streak: longestStreak, results: lastThree)
        
        vc.dataWeNeedExample1 = "Hello"
        
        vc.modalPresentationStyle = .fullScreen
        
        // MARK: STEP 13: StatsVC Data
        // Follow instructions in StatsVC. You also need to invalidate
        // the timer instance to pause game before going to StatsVC.
        
        // MARK: >> Your Code Here <<
        
        
        present(vc, animated: true, completion: nil)
    }
    
    @objc func didTapPause(_ sender: UIButton) {
        
        if sender.currentTitle == "Pause" {
            self.timer?.invalidate()
            self.timer = nil
            runCount = 0
            pauseButton.setTitle("Resume", for: .normal)
        } else {
            pauseButton.setTitle("Pause", for: .normal)
            score = 0
            scoreLabel.text = "Score: " + String(score)
            if self.timer == nil {
                self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerCallback), userInfo: nil, repeats: true)
            }
            runCount = 0
        }
    }
    
    // MARK: STEP 16:
    // Read the spec again and run the app. Did you cover everything
    // mentioned in it? Play around it for a bit, see if you can
    // uncover any bug. Is there anything else you want to add?
}
