//
//  AvailableDesks.swift
//  Booking
//
//  Created by Mac on 15/04/24.
//

import UIKit

struct AvailableDesksDetailedUrl {
    let workspaceName : String
    let workspaceId : Int
    let workspaceActive : Bool
}


class AvailableDesks: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var availableDeskTableView: UITableView!
    
    var availableDesksSlots : [AvailableDesksDetailedUrl] = [] // Array to store available slots
    
    override func viewDidLoad() {
        super.viewDidLoad()
        availableDeskTableView.dataSource = self
        availableDeskTableView.delegate = self

        availableSlots()
        // Do any additional setup after loading the view.
    }
    
    func availableSlots()  {
        
        let urlString = "https://demo0413095.mockable.io/digitalflake/api/get_availability?date=2023-05-01&slot_id=2&type=1"
        
        guard let url = URL(string: urlString) else{
            print("URL is invalid")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let session = URLSession(configuration: .default)
        
        let dataTask = session.dataTask(with: request) {
            data, response, error in
            
            print("Data received from URL is : \(String(describing : data))")
            
            if let error = error {
                print("Error received from URL : \(error)")
            } else {
                
                
                guard let response = response as? HTTPURLResponse,
                      response.statusCode == 200,
                      let data = data else
                {
                    print("Data is invalid OR Status code is not proper")
                    return
                }
                
                
                do{
                    guard let jsonObject = try? JSONSerialization.jsonObject(with: data) as? [String :Any] else{
                        print("JSON not in expected format")
                        return
                    }
                    guard let jsonObjectForResults = jsonObject["availability"] as? [[String:Any]] else{
                        print("The json does not contain any results key")
                        return
                    }
                    for dictionary in jsonObjectForResults{
                        let postworkspaceName = dictionary["workspace_name"] as! String
                        let postworkspaceId = dictionary["workspace_id"] as! Int
                        let postworkspaceActive = dictionary["workspace_active"] as! Bool
                        
                        print("workspace_name is :\(postworkspaceName) \nworkspace_id :\(postworkspaceId) \nworkspace_active : \(postworkspaceActive)\n\n\n")
                        
                        let availableDesksDetailedUrl = AvailableDesksDetailedUrl(workspaceName: postworkspaceName, workspaceId: postworkspaceId, workspaceActive: postworkspaceActive)
                        self.availableDesksSlots.append(availableDesksDetailedUrl)
                        
                        DispatchQueue.main.async {
                            self.availableDeskTableView.reloadData()
                        }
                    }
                }
                catch{
                    print("Got error while converting Data to JSON - \(error.localizedDescription)")
                }
            }
        }
        dataTask.resume()
    }

    func pushToConfirmationScreen() {
        if let confirmScreenVc = self.storyboard?.instantiateViewController(withIdentifier: "ConfirmationViewController") as? ConfirmationViewController {
            self.navigationController?.pushViewController(confirmScreenVc, animated: true)
        }
    }

    
    
    @IBAction func bookDeskButton(_ sender: Any) {
        pushToConfirmationScreen()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return availableDesksSlots.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.availableDeskTableView.dequeueReusableCell(withIdentifier: "AvailableDeskTableViewCell") as? AvailableDeskTableViewCell else{
            return UITableViewCell()
        }
        let workspace = availableDesksSlots[indexPath.row]
        cell.workspaceNameLabel.text = workspace.workspaceName
        cell.workspaceIdLabel.text = String(workspace.workspaceId)
        cell.workspaceActiveLabel.text = String(workspace.workspaceActive)
        
        return cell
    }

}
