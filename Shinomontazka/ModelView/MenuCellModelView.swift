//
//  MenuCellModelView.swift
//  Shinomontazka
//
//  Created by Раис Аглиуллов on 08/05/2019.
//  Copyright © 2019 Раис Аглиуллов. All rights reserved.
//

import Foundation

class MenuCellModelView {
    
    static let cellsObjects: [MenuCellModel] = {
        let obj1 = MenuCellModel(nameLabel: "Найти шины", ugolImage: "tyre", backgroundImage: "Halftyre")
        let obj2 = MenuCellModel(nameLabel: "Найти диски", ugolImage: "disk", backgroundImage: "Halfdisk")
        let obj3 = MenuCellModel(nameLabel: "Найти аккумуляторы", ugolImage: "accumulator", backgroundImage: "Halfaccu,ulator")
        let obj4 = MenuCellModel(nameLabel: "Сервис", ugolImage: "service", backgroundImage: "Halfservice")
        
        
        return [obj1, obj2, obj3, obj4]
    }()
    
}

