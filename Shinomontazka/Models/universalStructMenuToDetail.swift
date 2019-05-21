//
//  universalStructMenuToDetail.swift
//  Shinomontazka
//
//  Created by Раис Аглиуллов on 11/05/2019.
//  Copyright © 2019 Раис Аглиуллов. All rights reserved.
//

import Foundation


struct universalStructMenuToDetail: Decodable {
    
    var id: Int?
    var name: String?
    var price: Int?
    var imageUrl: String?
    var shirina: Int?
    var profile: Int?
    var diametr: Int?
    var holes: Int?
    var ET: Int?
    var DIA: Int?
    var size: String?
    var volt: String?
    var emkost: String?
    var puskovoitok: String?
    
    static let fillCellDetailVCTyres = ["Ширина", "Профиль", "Диаметр"]
    static let fillCellDetailVCDisks = ["Диаметр", "Отверстий", "ET", "DIA"]
    static let fillCellDetailVCAccumulators = ["Размеры", "Напряжение", "Емкость", "Пусковой ток"]
}
