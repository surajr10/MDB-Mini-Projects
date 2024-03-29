//
//  StatsVC.swift
//  Meet the Member
//
//  Created by Michael Lin on 1/18/21.
//

import UIKit

class StatsVC: UIViewController {
    
    // MARK: STEP 13: StatsVC Data
    // When we are navigating between VCs (e.g MainVC -> StatsVC),
    // since MainVC doesn't directly share its instance properties
    // with other VCs, we often need a mechanism of transferring data
    // between view controllers. There are many ways to achieve
    // this, and I will show you the two most common ones today. After
    // carefully reading these two patterns, pick one and implement
    // the data transferring for StatsVC.
    
    // Method 1: Implicit Unwrapped Instance Property
    var dataWeNeedExample1: String!
    //
    // Check didTapStats in MainVC.swift on how to use it.
    //
    // Explanation: This method is fairly straightforward: you
    // declared a property, which will then be populated after
    // the VC is instantiated. As long as you remember to
    // populate it after each instantiation, the implicit forced
    // unwrap will not result in a crash.
    //
    // Pros: Easy, no boilerplate required
    //
    // Cons: Poor readability. Imagine if another developer wants to
    // use this class, unless it's been well-documented, they would
    // have no idea that this variable needs to be populated.
    
    // Method 2: Custom initializer
//    var dataWeNeedExample2: String
//    init(data: String) {
//        dataWeNeedExample2 = data
//        super.init(nibName: nil, bundle: nil)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    //
    // Check didTapStats in MainVC.swift on how to use it.
    //
    // Explanation: This method creates a custom initializer which
    // takes in the required data. This pattern results in a cleaner
    // initialization and is more readable. Compared with method 1
    // which first initialize the data to nil then populate, in this
    // method the data is directly initialized in the init so there's
    // no need for unwrapping of any kind.
    //
    // Pros: Clean. Null safe.
    //
    // Cons: Doesn't work with interface builder (storyboard)
    
    // MARK: >> Your Code Here <<
    
    var longestStreak: Int
    var lastThree: [String] = []
    
    init(streak: Int, results: [String]) {
        longestStreak = streak
        for result in results {
            lastThree.append(result)
        }
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    // MARK: STEP 14: StatsVC UI
    // You know the drill. Initialize the UI components, add subviews,
    // and create constraints.
    //
    // Note: You cannot use self inside these closures because they
    // happens before the instance is fully initialized. If you want
    // to use self, do it in viewDidLoad.
    
    // MARK: >> Your Code Here <<
    
    let streakLabel: UILabel = {
        let label = UILabel()
        label.textColor = .green
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    let lastThreeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .blue
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let backButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Back", for: .normal)
        
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        streakLabel.text = "Your longest streak of correct answers is: " + String(longestStreak)
        
        lastThreeLabel.text = "Your last three answers have been: " + lastThree[0] + ", " + lastThree[1] + ", " + lastThree[2]
        

        
        view.addSubview(streakLabel)
        
        NSLayoutConstraint.activate([
            streakLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            streakLabel.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: -200),
            streakLabel.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: 200)
        ])
        
        view.addSubview(lastThreeLabel)
        
        NSLayoutConstraint.activate([
            lastThreeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 200),
            lastThreeLabel.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: -200),
            lastThreeLabel.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: 200)
        ])
        
        
        view.addSubview(backButton)
        
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            backButton.trailingAnchor.constraint(equalTo: view.leadingAnchor, constant: 100)
        ])
        
        backButton.addTarget(self, action: #selector(didTapBack(_:)), for: .touchUpInside)
        // MARK: >> Your Code Here <<
    }
    
    @objc func didTapBack(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
    }
}
