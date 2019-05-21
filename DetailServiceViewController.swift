//
//  DetailServiceViewController.swift
//  Shinomontazka
//
//  Created by Раис Аглиуллов on 13/05/2019.
//  Copyright © 2019 Раис Аглиуллов. All rights reserved.
//

import UIKit

class DetailServiceViewController: UIViewController {
    
    //Приходит название выбранной ячейки с контроллера "Новое ТС"
    var cellsLabels: String?
    
    //Ключи и значения словаря
    var dictionaryKey: [String] = []
    var dictionaryValue: [Any] = []
    
    //Выбранный Бренд и модель для передачи в ServiceToDetailVC
    var selectedBrands = ""
    var selectedModel = ""
    var selectedTyre = ""
    
    //Диаметр колес( для всех машин одинаковый, чтобы для каждой был свой нужно новый словарь)
    private let tyreDiametr = ["14", "15", "16", "17", "18", "19"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Проверка на пришедшее имя ячейки
        switch cellsLabels {
        case "Марка автомобиля":
            fillingNamesCar()
        case "Модель":
            fillingNamesCar()
         
        default:
            break
        }
        
    }
    
    //Создание словаря и заполнение массивов
    func fillingNamesCar() {
        
        //Путь
        guard let path = Bundle.main.path(forResource: "AllCars", ofType: "plist") else { return }
        
        //Попытка создания словаря
        guard let tableData = NSDictionary(contentsOfFile: path) else { return }
        
        //Проверка пришедшего имени ячейки
        if cellsLabels == "Марка автомобиля" {
            dictionaryKey = (Array(tableData.allKeys) as! [String]).sorted()
        }
        
        if cellsLabels == "Модель" {
            dictionaryValue = tableData.value(forKey: selectedBrands) as! [String]
        }
    }
  
    @IBAction func backButton(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
}

extension DetailServiceViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if cellsLabels == "Марка автомобиля" {
            return dictionaryKey.count
        }
        
        if cellsLabels == "Модель" {
            return dictionaryValue.count
        }
        
       if cellsLabels == "Диаметр шин" {
            return tyreDiametr.count
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellDetail", for: indexPath)
        
        if cellsLabels == "Марка автомобиля" {
            cell.textLabel?.text = dictionaryKey[indexPath.row]
            return cell
        }
        
        if cellsLabels == "Модель" {
            cell.textLabel?.text = dictionaryValue[indexPath.row] as? String
            return cell
            
        }
        
        if cellsLabels == "Диаметр шин" {
            cell.textLabel?.text = tyreDiametr[indexPath.row]
        }
        
        return cell
    }
}

extension DetailServiceViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        //Проверка имени с присваивание в перемннуб для передачи на ServiceToDetailVC
        if cellsLabels == "Марка автомобиля" {
            let index = dictionaryKey[indexPath.row]
            selectedBrands = index
        }
        
        if cellsLabels == "Модель" {
            let index = dictionaryValue[indexPath.row] as! String
            selectedModel = index
        }
        
        if cellsLabels == "Диаметр шин" {
            let index = tyreDiametr[indexPath.row]
            selectedTyre = index
        }
        
        
        //Переход на предыдущий экран
        performSegue(withIdentifier: "unwindDetailToServiceDetail", sender: self)
        dismiss(animated: true, completion: nil)
    }
}
