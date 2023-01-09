//
//  HomeCell.swift
//  BloodPressureApp
//
//  Created by Utku Çalışkan on 28.12.2022.
//

import UIKit

class HomeCell: UITableViewCell {

    @IBOutlet weak var infoLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var homeView: UIView!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
