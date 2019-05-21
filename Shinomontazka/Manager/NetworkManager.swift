//
//  NetworkManager.swift
//  Shinomontazka
//
//  Created by Раис Аглиуллов on 07/05/2019.
//  Copyright © 2019 Раис Аглиуллов. All rights reserved.
//

import Foundation


class NetworkManager {
    
    static let allTyresUrl = "https://vk.com/doc277822508_504255423?wnd=1&fragment=0"
    static let allDisksUrl = "https://vk.com/doc277822508_504255312?wnd=1&fragment=0"
    static let allAccumulatorsUrl = "https://vk.com/doc277822508_504255056?wnd=1&fragment=0"

    
    //Получение данных и запись в экземпляр структуры
    static func getDataWithJSON(url: String, completion: @escaping (_ objects: [universalStructMenuToDetail])->()) {
        
        //проверка на валидность
        guard let url = URL(string: url) else { return }
        
        //сессия
        let session = URLSession.shared
        
        //добавление задачи
        session.dataTask(with: url) { (data, response, error) in
            
            //проверка даты на существование
            guard let data = data else { return }
            
            //попытка трансфотмировать JSON в массив объектов структуры
            do {
//                let json = try JSONSerialization.jsonObject(with: data, options: [])
//                print(json)
                
                let object = try JSONDecoder().decode([universalStructMenuToDetail].self, from: data)
                completion(object)
               
            } catch {
                print(error.localizedDescription)
            }
            }.resume()
        
        
    }

}
