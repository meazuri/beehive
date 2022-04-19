//
//  LoginViewController.swift
//  Hive
//
//  Created by seintsan on 19/4/22.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    override func viewDidLoad() {
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        configureUI()
    }
    
    // MARK: - UI
    func configureUI()  {
        //spacing
        stackView.setCustomSpacing(CGFloat(40.0), after: welcomeLabel)
        stackView.setCustomSpacing(CGFloat(50), after: emailTextField)
        stackView.setCustomSpacing(CGFloat(70), after: passwordTextField)
        
        print("stackViewWidth ",stackView.frame.width)

        //textField Style
        emailTextField.addBottomBorder()
        passwordTextField.addBottomBorder()
        
        //buttom rounded border
        loginButton.layer.cornerRadius = 5
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
