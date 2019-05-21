//
//  Tyres.swift
//  Shinomontazka
//
//  Created by Раис Аглиуллов on 07/05/2019.
//  Copyright © 2019 Раис Аглиуллов. All rights reserved.
//

import Foundation

//Модель загрузки для шин
struct universalStructMenuToDetail: Decodable {
    var id: Int?
    var name: String?
    var price: Int?
    var imageUrl: String?
    var shirina: Int?
    var profile: Int?
    var diametr: Int?
    
    static let arrayNames = ["Ширина", "Профиль", "Диаметр"]
    
//    struct Disks: Decodable {
//        var id: Int?
//        var name: String?
//        var price: Int?
//        var imageURL: String?
//        var diametr: Int?
//        var holes: Int?
//        var et: Int?
//        var dia: Float?
}
