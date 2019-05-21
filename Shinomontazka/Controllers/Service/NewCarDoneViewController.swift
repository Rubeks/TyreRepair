//
//  NewCarDoneViewController.swift
//  Shinomontazka
//
//  Created by Раис Аглиуллов on 15/05/2019.
//  Copyright © 2019 Раис Аглиуллов. All rights reserved.
//

import UIKit
import CoreData

class NewCarDoneViewController: UIViewController {
    
    //В этот массив сохранаяюст новые машины и грузятся из него
    var newCarCoreData: [NewCarCoreData]?
    
    //Аутлеты
    @IBOutlet weak var doneButton: UIButton!{
        didSet {
            doneButton.layer.cornerRadius = 10
            doneButton.clipsToBounds = true
        }
    }
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //doneButton.isHidden = true
        
        //Скрыть нав кнопку назад
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        //Загрузка из CoreData
        loadCarFromCoreData()
        
         //Скрытие пустых ячеек после таблицы
        self.tableView.tableFooterView = UIView()
        
       
    }
    
    //Загрузка из БД машин
    func loadCarFromCoreData() {
        
        // Добираюсь до АпДелегат. Нужно будет для свойства СейвКонтекст
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        // Получаю сам контекст
        let context = appDelegate.persistentContainer.viewContext
        
        // Создаю запрос к КорДате, чтобы получить все записи
        let fetchRequest: NSFetchRequest<NewCarCoreData> = NewCarCoreData.fetchRequest()
        
        // Обращаюсь к КорДате и пробую загрузить все в массив
        do {
            newCarCoreData = try context.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    //Настройка ячейки
    func configureCell(cell: NewCarDoneTableViewCell, indexPath: IndexPath) {
        
        if newCarCoreData != nil {
            
            guard let newCar = newCarCoreData?[indexPath.row] else { return }
            
            cell.brandLabel.text = "Марка: \(newCar.carBrand!)"
            cell.modelLabel.text = "Модель: \(newCar.carModel!)"
            cell.tyreDiametr.text = "Диаметр колес: \(newCar.carTyreDiametr!)"
            cell.gosNumberLabel.text =  "Гос. номер: \(newCar.gosNumber!)"
            cell.VINNumberLabel.text = "VIN номер: \(newCar.vinNumber!)"
            cell.probegLabel.text = "Пробег, км.: \(newCar.probeg!)"
            
            cell.customView.layer.cornerRadius = 25
            cell.customView.layer.borderWidth = 2
            cell.customView.layer.borderColor = UIColor(red: 228 / 255, green: 228 / 255, blue: 228 / 255, alpha: 1).cgColor
            cell.customView.clipsToBounds = true
        }
    }
    
    //Переход на добавлени новой машины
    @IBAction func doneButton(_ sender: UIButton) {
    }
}

//MARK: - Extensions
extension NewCarDoneViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if newCarCoreData != nil {
            return newCarCoreData!.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? NewCarDoneTableViewCell {
            configureCell(cell: cell, indexPath: indexPath)
            
            return cell
        }
        return UITableViewCell()
    }
}

extension NewCarDoneViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //Разрешение на изменение
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //Удаление ячейки
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        // Добираюсь до АпДелегат. Нужно будет для свойства СейвКонтекст
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        // Получаю сам контекст
        let context = appDelegate.persistentContainer.viewContext
        
        //Выбранная ячейка
        guard let deleteCar = newCarCoreData?[indexPath.row], editingStyle == .delete else { return }
        
        //Удаление из массива
        newCarCoreData?.remove(at: indexPath.row)
        
        //Удаление из CoreData
        context.delete(deleteCar)
        
        self.tableView.beginUpdates()
        
        //Попытка сохранения
        do {
            try context.save()
            tableView.deleteRows(at: [indexPath], with: .automatic)
        } catch {
            print(error.localizedDescription)
        }
        
        self.tableView.endUpdates()
        
        //Если обнулилась CoreData то переход на добавление новой машины
        if (newCarCoreData?.first?.carBrand == nil) && (newCarCoreData?.first?.carModel == nil) {
            performSegue(withIdentifier: "backToAddCar", sender: nil)
        }
    }
}
