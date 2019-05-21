//
//  MenuTopCustomView.swift
//  Shinomontazka
//
//  Created by Раис Аглиуллов on 08/05/2019.
//  Copyright © 2019 Раис Аглиуллов. All rights reserved.
//

import UIKit

class MenuTopCustomView: UIView {

    //Настройка кастомной вью в верху экрана
    override init(frame: CGRect) {
        super.init(frame: frame)
        settingInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        settingInit()
    }
    
    private func settingInit() {
        let topColor = UIColor(red: 236 / 255, green: 238 / 255, blue: 239 / 255, alpha: 1)
        let downColor = UIColor(red: 26 / 255, green: 80 / 255, blue: 108 / 255, alpha: 1)
        setGradientBackgroundCenterToTopOrBottom(colorOne: downColor, colorTwo: topColor, direction: .centerToBot)
    }
    
}
