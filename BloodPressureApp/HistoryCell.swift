//
//  HistoryCell.swift
//  BloodPressureApp
//
//  Created by Utku Çalışkan on 27.12.2022.
//

import UIKit

class HistoryCell: UITableViewCell {

    @IBOutlet weak var systoleLabel: UILabel!
    
    @IBOutlet weak var diastoleLabel: UILabel!
    
    @IBOutlet weak var pulseLabel: UILabel!
    
    @IBOutlet weak var historyView: UIView!
    
    @IBOutlet weak var dateLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
