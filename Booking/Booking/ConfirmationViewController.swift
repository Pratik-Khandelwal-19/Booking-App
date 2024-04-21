//
//  ConfirmationViewController.swift
//  Booking
//
//  Created by Mac on 21/04/24.
//

import UIKit

class ConfirmationViewController: UIViewController {
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var slotIdLabel: UILabel!
    
    @IBOutlet weak var workspaceIdLabel: UILabel!
    
    @IBOutlet weak var typeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        confirmPostApiCall()
        // Do any additional setup after loading the view.
    }
    
    func confirmPostApiCall() {
        
        let params = [
            "date" : "2023-05-01",
            "slot_id" : "2",
            "workspace_id" : "3",
            "type" : "1"
        ]
        
        guard let url = URL(string: "https://demo0413095.mockable.io/digitalflake/api/confirm_booking")
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
                if let date = jsonRes?["date"] as? String,
                   let slot_id = jsonRes?["slot_id"] as? String,
                   let workspace_id = jsonRes?["workspace_id"] as? String,
                   let type = jsonRes?["type"] as? String
                {
                    // Update UI on main thread
                    DispatchQueue.main.async {
                        self.dateLabel.text = date;                       self.slotIdLabel.text = slot_id
                        self.workspaceIdLabel.text = workspace_id
                        self.typeLabel.text = type
                        
                    }
                }            }
        }.resume()
        
        
    }
    
    func backTwo() {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 4], animated: true)
    }
    
    @IBAction func confirmButton(_ sender: Any) {
        backTwo()
        
    }
}
