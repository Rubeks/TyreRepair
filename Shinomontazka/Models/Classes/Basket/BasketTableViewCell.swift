//
//  BasketTableViewCell.swift
//  Shinomontazka
//
//  Created by Раис Аглиуллов on 20/05/2019.
//  Copyright © 2019 Раис Аглиуллов. All rights reserved.
//

import UIKit

class BasketTableViewCell: UITableViewCell {
    
    //Запишется цена из CoreData при инициализации ячеек
    var price: String.SubSequence?
    
    //Перевод полученного price в Int
    var newValuePriceLabel: Int {
        
        get {
            let priceString = String(price!)
            return Int(priceString)!
        }
        
        set {
            priceLabel.text = "Цена " + String(newValue) + " ₽ / за " + String(countLabelValue) + " шт."
        }
    }
    
    //Запись в countLabel
    var countLabelValue: Int {
        
        get {
            return Int(countLabel.text!)!
        }
        
        set {
            countLabel.text = String(newValue)
        }
    }
    
    @IBOutlet weak var customImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel! {
        didSet {
            countLabel.text = "1"
        }
    }
    @IBOutlet weak var minusButton: UIButton! {
        didSet {
            minusButton.isEnabled = false
        }
    }
    @IBOutlet weak var plusButton: UIButton!
    
    //Кнопки - +
    @IBAction func plusOrMinus(_ sender: UIButton) {
        
        // +
        if sender.tag == 1 {
            if countLabelValue >= 1 {
                minusButton.isEnabled = true
                countLabelValue += 1
                newValuePriceLabel *= countLabelValue
            }
            
            // -
        } else if sender.tag == 0 {
            if countLabelValue == 1 {
                minusButton.isEnabled = false
            } else if countLabelValue > 1 {
                countLabelValue -= 1
                newValuePriceLabel /= countLabelValue
            }
        }
    }
}
