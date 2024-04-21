//
//  BookingHomeScreen.swift
//  Booking
//
//  Created by Mac on 14/04/24.
//

import UIKit

class BookingHomeScreen: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    func pushToSelectDatenSlotScreen() {
        if let selectDatenSlotScreenVc = self.storyboard?.instantiateViewController(withIdentifier: "DeskSelectDatenSlots") as? DeskSelectDatenSlots {
            self.navigationController?.pushViewController(selectDatenSlotScreenVc , animated: true)
        }
    }
    
    func pushToBookingHistoryViewCpontroller() {
        if let bookingHistoryVc = self.storyboard?.instantiateViewController(withIdentifier: "BookingHistoryViewController") as? BookingHistoryViewController {
            self.navigationController?.pushViewController(bookingHistoryVc , animated: true)
        }
    }
    
    @IBAction func bookinghistoryButton(_ sender: Any) {
        pushToBookingHistoryViewCpontroller()
    }
    
    
    @IBAction func bookworkstationButton(_ sender: Any) {
        pushToSelectDatenSlotScreen()
        
    }
    

    
    @IBAction func meetingroomButton(_ sender: Any) {
        pushToSelectDatenSlotScreen()
    }
    
}
