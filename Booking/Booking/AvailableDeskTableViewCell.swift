//
//  AvailableDeskTableViewCell.swift
//  Booking
//
//  Created by Mac on 20/04/24.
//

import UIKit

class AvailableDeskTableViewCell: UITableViewCell {

    @IBOutlet weak var workspaceNameLabel: UILabel!
    
    @IBOutlet weak var workspaceIdLabel: UILabel!
    @IBOutlet weak var workspaceActiveLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
