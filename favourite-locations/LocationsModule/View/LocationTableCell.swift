//
//  LocationTableCell.swift
//  favourite-locations
//
//  Created by Ирек Хабибуллин on 02.01.2023.
//

import UIKit

class LocationTableCell: UITableViewCell {
    static let id = "LocationCell"
    
    
    let title = UILabel()
    let coordinates = UILabel()
    let comment = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
