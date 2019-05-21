//
//  MenuCollectionViewCell.swift
//  Shinomontazka
//
//  Created by Раис Аглиуллов on 07/05/2019.
//  Copyright © 2019 Раис Аглиуллов. All rights reserved.
//

import UIKit

class MenuCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var backGroundImage: UIImageView! {
        didSet {
            
            backGroundImage.contentMode = .scaleAspectFill
            backGroundImage.alpha = 0.2
        }
    }
    @IBOutlet weak var ugolImage: UIImageView!
    @IBOutlet weak var nameCellLabel: UILabel!
    
}
