//
//  ViewController.swift
//  Booking
//
//  Created by Mac on 14/04/24.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
            self.postApiCall()
        }
    }
    func postApiCall() {
        
        let params = [
            "email" : "pankaj@digitalflake.com",
            "password" : "pankaj@123"]
        
        guard let url = URL(string: "https://demo0413095.mockable.io/digitalflake/api/login")
        else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody =  try? JSONSerialization.data(withJSONObject: params)
        
        let session = URLSession.shared.dataTask(with: request) {
            data, response, error in
            if let error = error {
                print("Error = \(error.localizedDescription)")
            }
            else {
                let jsonRes = try? JSONSerialization.jsonObject(with: data!) as! [String : Any]
                print("Response = \(jsonRes)")
                if let userId = jsonRes?["user_id"] as? Int,
                   let message = jsonRes?["message"] as? String {
                    // Update UI on main thread
                    DispatchQueue.main.async {
                        self.usernameTextField.text = "\(userId)"
                        self.passwordTextField.text = message
                    }
                }            }
        }.resume()
        
        
    }
    
    
    @IBAction func loginButton(_ sender: Any) {
        pushToHomeScreen()
    }
    
    
    func pushToHomeScreen() {
        if let homeScreenVc = self.storyboard?.instantiateViewController(withIdentifier: "BookingHomeScreen") as? BookingHomeScreen {
            self.navigationController?.pushViewController(homeScreenVc, animated: true)
        }
    }
    
    @IBAction func signupButton(_ sender: Any) {
        if let signupVc = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController {
            self.navigationController?.pushViewController(signupVc, animated: true)
        }
        else {
            print("Error")
        }
    }
    
    
    
}







