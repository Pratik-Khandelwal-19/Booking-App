//
//  SignUpViewController.swift
//  Booking
//
//  Created by Mac on 14/04/24.
//

import UIKit

class SignUpViewController: UIViewController {
    
    
    @IBOutlet weak var fullnameTextField: UITextField!
    
    @IBOutlet weak var mobilenoTextField: UITextField!
    
    
    @IBOutlet weak var emailsignupTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.postApiCallCreateAccount()
        }
    }
    
    func postApiCallCreateAccount() {
        
        let params = [
            "email" : "pankaj@digitalflake.com",
            "name" : "Pankaj Jadhav"]
        
        guard let url = URL(string: "https://demo0413095.mockable.io/digitalflake/api/create_account")
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
                        self.mobilenoTextField.text = "\(userId)"
                        self.emailsignupTextField.text = message
                    }
                }            }
        }.resume()
    }
    
    
    @IBAction func createanaccountButton(_ sender: Any) {
        pushToHomeScreen()
    }
    
    func pushToHomeScreen() {
        if let homeScreenVc = self.storyboard?.instantiateViewController(withIdentifier: "BookingHomeScreen") as? BookingHomeScreen {
            self.navigationController?.pushViewController(homeScreenVc, animated: true)
        }
    }
    
    @IBAction func loginsignupButton(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
        
    }
}
