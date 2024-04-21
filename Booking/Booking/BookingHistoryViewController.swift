//
//  BookingHistoryViewController.swift
//  Booking
//
//  Created by Mac on 21/04/24.
//

import UIKit

struct BookingHistoryDetailedUrl {
    let workspaceName : String
    let workspaceId : Int
    let bookingDate : String
}


class BookingHistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var bookingHistoryTableView: UITableView!
    var bookingHistorySlots : [BookingHistoryDetailedUrl] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bookingHistoryTableView.dataSource = self
        bookingHistoryTableView.delegate = self
        bookingHistory()
        // Do any additional setup after loading the view.
    }
    
    
    func bookingHistory()  {
        
        let urlString = "https://demo0413095.mockable.io/digitalflake/api/get_bookings?user_id=1"
        
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
                    guard let jsonObjectForResults = jsonObject["bookings"] as? [[String:Any]] else{
                        print("The json does not contain any results key")
                        return
                    }
                    for dictionary in jsonObjectForResults{
                        let postworkspaceName = dictionary["workspace_name"] as! String
                        let postworkspaceId = dictionary["workspace_id"] as! Int
                        let postbookingDate = dictionary["booking_date"] as! String
                        
                        print("workspace_name is :\(postworkspaceName) \nworkspace_id :\(postworkspaceId) \nbooking_date : \(postbookingDate)\n\n\n")
                        
                        let bookingHistoryDetailedUrl = BookingHistoryDetailedUrl(workspaceName: postworkspaceName, workspaceId: postworkspaceId, bookingDate: postbookingDate)
                        self.bookingHistorySlots.append(bookingHistoryDetailedUrl)
                        
                        DispatchQueue.main.async {
                            self.bookingHistoryTableView.reloadData()
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
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookingHistorySlots.count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.bookingHistoryTableView.dequeueReusableCell(withIdentifier: "BookingHistoryTableViewCell") as? BookingHistoryTableViewCell else{
            return UITableViewCell()
        }
        let workspaceBH = bookingHistorySlots[indexPath.row]
        cell.workspaceNameLabel.text = workspaceBH.workspaceName
        cell.workspaceIdLabel.text = String(workspaceBH.workspaceId)
        cell.bookingDateLabel.text = workspaceBH.bookingDate
        return cell
    }
    
    
}
