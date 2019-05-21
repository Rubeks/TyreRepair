//
//  MenuToDetailTableViewCell.swift
//  Shinomontazka
//
//  Created by Раис Аглиуллов on 08/05/2019.
//  Copyright © 2019 Раис Аглиуллов. All rights reserved.
//

import UIKit

class MenuToDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var cellImageView: UIImageView! {
        didSet {
            cellImageView.layer.cornerRadius = 5
            cellImageView.clipsToBounds = true
            cellImageView.layer.borderWidth = 2
            cellImageView.layer.borderColor = UIColor(red: 228 / 255, green: 228 / 255, blue: 228 / 255, alpha: 1).cgColor
        }
    }
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var fourPriceLabel: UILabel!
}
