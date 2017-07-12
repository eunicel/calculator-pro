//
//  ViewController.swift
//  Calculator Pro
//
//  Created by Eunice Lin on 7/8/17.
//  Copyright © 2017 Eunice Lin. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    var ref: DatabaseReference!
    
    let text = UITextField(frame: CGRect(x: 10.0, y: 200.0, width: 250.0, height: 30.0))
    let messages = UILabel(frame: CGRect(x: 10.0, y: 300.0, width: 340.0, height: 400.0))

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()

        
        text.borderStyle = UITextBorderStyle.line

        // Set up send button
        let buttonFrame = CGRect(x: 270.0, y: 200.0, width: 80.0, height: 30.0)
        let button = UIButton(frame: buttonFrame)
        button.backgroundColor = UIColor.green
        button.setTitle("Send", for: .normal)
        button.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)

        self.view.addSubview(text)
        self.view.addSubview(button)
        getMessages()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func buttonClicked(_ sender: AnyObject?) {

        // Send post request to Firebase
        ref.child("messages/").setValue(self.text.text)
        self.sendSuccessMessage()
    }
    
    func getMessages() {
        print("getMessages")
        ref.observe(DataEventType.value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            print(value)
            let message = value?["messages"] as? String ?? ""
            print("blah")
            print(message)
            self.displayMessage(message)
        }) { (error) in
            print("!!!!!!!!!!!!!!!!!!!!!!!!!!!")
            print(error.localizedDescription)
        }
    }
    
    func displayMessage(_ message: String) {
        if let insideText = messages.text {
            messages.text = insideText + "\n" + message
        } else {
            messages.text = message
        }
        self.view.addSubview(messages)
    }

    func sendSuccessMessage() {
        let sentFrame = CGRect(x: 120.0, y: 150.0, width: 160.0, height: 30.0)
        let sent = UILabel(frame: sentFrame)
        sent.text = "Message sent!"
        sent.textColor = UIColor.cyan
        self.view.addSubview(sent)
    }
    
    func sendFailureMessage() {
        let sentFrame = CGRect(x: 120.0, y: 150.0, width: 160.0, height: 30.0)
        let sent = UILabel(frame: sentFrame)
        sent.text = "Message failed :("
        sent.textColor = UIColor.red
        self.view.addSubview(sent)
    }

}

