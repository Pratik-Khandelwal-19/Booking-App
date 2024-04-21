//
//  DeskSelectDatenSlots.swift
//  Booking
//
//  Created by Mac on 15/04/24.
//

import UIKit
import FSCalendar

struct SlotsDetailedUrl {
    let slotName : String
    let slotId : Int
    let slotActive : Bool
}

class DeskSelectDatenSlots: UIViewController, FSCalendarDelegate, UITableViewDataSource, UITableViewDelegate {
    
    var calendar: FSCalendar!
    
    @IBOutlet weak var slotsTableView: UITableView!
    
    var availableSlots : [SlotsDetailedUrl] = [] // Array to store available slots
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Create FSCalendar instance
        calendar = FSCalendar(frame: CGRect(x: 0, y: 125, width: view.frame.width, height: 250))
        calendar.delegate = self
        view.addSubview(calendar)
        
        // Set initial selected date
        calendar.select(Date())
        
        slotsTableView.delegate = self
        slotsTableView.dataSource = self
        
        // Fetch available slots for initial date
        fetchAvailableSlots(for: Date())    }
    
    // Handle date selection
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        // Fetch available slots for selected date
        fetchAvailableSlots(for: date)
    }
    
    func fetchAvailableSlots(for date: Date)  {
        
        // Format date
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: date)
        let urlString = "https://demo0413095.mockable.io/digitalflake/api/get_slots?date=\(dateString)"
        
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
                    guard let jsonObjectForResults = jsonObject["slots"] as? [[String:Any]] else{
                        print("The json does not contain any results key")
                        return
                    }
                    for dictionary in jsonObjectForResults{
                        let postslotName = dictionary["slot_name"] as! String
                        let postslotId = dictionary["slot_id"] as! Int
                        let postslotActive = dictionary["slot_active"] as! Bool
                        
                        print("slot_name is :\(postslotName) \nslot_id :\(postslotId) \nslot_active : \(postslotActive)\n\n\n")
                        
                        let slotsDetailedUrl = SlotsDetailedUrl(slotName: postslotName, slotId: postslotId, slotActive: postslotActive)
                        self.availableSlots.append(slotsDetailedUrl)
                        
                        DispatchQueue.main.async {
                            self.slotsTableView.reloadData()
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
    
    func pushToAvailableDesksScreen() {
        if let availableDesksScreenVc = self.storyboard?.instantiateViewController(withIdentifier: "AvailableDesks") as? AvailableDesks {
            self.navigationController?.pushViewController(availableDesksScreenVc , animated: true)
        }
    }
    
    
    @IBAction func nextAvailableDesksButton(_ sender: Any) {
        pushToAvailableDesksScreen()
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return availableSlots.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.slotsTableView.dequeueReusableCell(withIdentifier: "SlotTableViewCell") as? SlotTableViewCell else{
            return UITableViewCell()
        }
        let slot = availableSlots[indexPath.row]
        cell.slotNameLabel.text = slot.slotName
        cell.slotIdLabel.text = String(slot.slotId)
        cell.slotActiveLabel.text = String(slot.slotActive)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let slot = availableSlots[indexPath.row]
        
        if slot.slotActive {
        

           pushToAvailableDesksScreen()

            

        } else {
            // Slot is inactive, show a visual indication to the user
            tableView.cellForRow(at: indexPath)?.setSelected(false, animated: false) // Deselect the row
            tableView.cellForRow(at: indexPath)?.selectionStyle = .none // Disable selection style
            
            // Optionally, you can provide feedback to the user, for example, by displaying an alert
            // Alert can be customized according to your app's design
            let alertController = UIAlertController(title: "Slot Inactive", message: "This slot is inactive and cannot be selected.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
        }
    }

    
}
