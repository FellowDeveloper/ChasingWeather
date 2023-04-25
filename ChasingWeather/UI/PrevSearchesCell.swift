//
//  PervSearchesCell.swift
//  ChasingWeather
//
//  Created by Anton Tugolukov on 4/24/23.
//

import UIKit

class PrevSearchesCell: UITableViewCell {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var pic: UIImageView!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
