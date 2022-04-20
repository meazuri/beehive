//
//  LoginViewController.swift
//  Hive
//
//  Created by seintsan on 19/4/22.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

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
        passwordTextField.delegate = self
        
        //buttom rounded border
        loginButton.layer.cornerRadius = 5
    }
    @IBAction func login(_ sender: Any) {
        
        let username :String = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        let loginRequest = LoginRequest(username: username, password: password)
        
        DataRepository.shared.login(parameters: loginRequest,completion: { (result ) in
            
            switch result {
            case .success(let loginResponse) :
                
                print(loginResponse.token)
                UserSession.shared.token = loginResponse.token
                DispatchQueue.main.async {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let productsViewController = storyboard.instantiateViewController(identifier: "ProductNavigationController")
                    let sceneDelegate = UIApplication.shared.connectedScenes
                            .first!.delegate as! SceneDelegate
                    sceneDelegate.window?.rootViewController = productsViewController
                }
            
            case .failure(let error):
                print(error)
            }
            
        
        })
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField == self.passwordTextField) {
            textField.resignFirstResponder()
            
            return false;
        }
        return true;

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
