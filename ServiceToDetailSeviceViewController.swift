//
//  ServiceToDetailSeviceViewController.swift
//  Shinomontazka
//
//  Created by Раис Аглиуллов on 13/05/2019.
//  Copyright © 2019 Раис Аглиуллов. All rights reserved.
//

import UIKit
import CoreData

class ServiceToDetailSeviceViewController: UIViewController {
    
    //Заполнение ячеек
    private let namesCells = ["Марка автомобиля", "Модель", "Диаметр шин", "Регистрационный номер", "VIN", "Пробег автомобиля"]
    private var valuesCells = ["Выбрать", "Выбрать", "Выбрать", "Добавить", "Не обязательно", "Не обязательно"]
    private var valuesCellsCopy = ["Выбрать", "Выбрать", "Выбрать", "Добавить", "Не обязательно", "Не обязательно"]
    private var valuesCellsStatic = ["Выбрать", "Выбрать", "Выбрать", "Добавить", "Не обязательно", "Не обязательно"]
   
    
    //Поля в которые записывается выбранный бренд и марка с DetailVC UnwindSegue
    var selectedBrandsWithDetailServiceVC: String?
    var selectedModelWithDetailServiceVC: String?
    var selectedTyreWithDetailServiceVC: String?
    
    //Поле для гос номера
    var gosNumber: String?
    var VINNumber: String?
    var probeg: String?
    
    //Название выбранной ячейки
    var selectedCellLabelsToDetailVC: String?
    
    //В этот массив сохранаяюст новые машины и грузятся из него
    var newCarCoreData: [NewCarCoreData]?
    
    //Аутлеты
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var doneButton: UIButton!{
        didSet {
            doneButton.layer.cornerRadius = 15
            doneButton.clipsToBounds = true
        }
    }

    //MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Убирает не заполненные ячейки таьлицы
        self.tableView.tableFooterView = UIView()
        
        doneButton.isEnabled = false
        doneButton.alpha = 0.4
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if (selectedBrandsWithDetailServiceVC != "") && (selectedModelWithDetailServiceVC != "") && (selectedBrandsWithDetailServiceVC != nil) && (selectedModelWithDetailServiceVC != nil) {
            doneButton.isEnabled = true
            doneButton.alpha = 1
        }
        
    }
    
    @IBAction func doneButton(_ sender: UIButton) {
        
        saveNewCarInsideCoreData(carBrand: valuesCellsCopy[0], carModel: valuesCellsCopy[1], carTyreDiametr: valuesCellsCopy[2], gosNumber: valuesCellsCopy[3], probeg: valuesCellsCopy[5], vinNumber: valuesCellsCopy[4])
        
        performSegue(withIdentifier: "createNewCarSegue", sender: self)
        
        
    }
    
    //Сохранение в БД новой машины
    func saveNewCarInsideCoreData(carBrand: String, carModel: String, carTyreDiametr: String, gosNumber: String, probeg: String, vinNumber: String) {
        
        // Добираюсь до АпДелегат. Нужно будет для свойства СейвКонтекст
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        // Получаю сам контекст
        let context = appDelegate.persistentContainer.viewContext
        
        // Создаю сущность (в корДата все работает через сущности - своего рода класс)
        
        let entity = NSEntityDescription.entity(forEntityName: "NewCarCoreData", in: context)
        
        // Создаю сам объект( из сущности и контекста) который хочу сохранить
        let carObject = NSManagedObject(entity: entity!, insertInto: context) as! NewCarCoreData
        
        // Устанавливаю значение для carObject (из принимаемого значения функцией)
        carObject.carBrand = carBrand
        carObject.carModel = carModel
        carObject.carTyreDiametr = carTyreDiametr
        carObject.gosNumber = gosNumber
        carObject.probeg = probeg
        carObject.vinNumber = vinNumber
        
        // Сохраняю контекст, для того чтобы сохранился сам объект
        do {
            try context.save()
            newCarCoreData?.append(carObject)
            print("Saved!")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @IBAction func backButton(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    //Настройка ячейки
    func configureCell(cell: UITableViewCell, indexPath: IndexPath) {
        
        //Текст слева ячейки - всегда статичен
        cell.textLabel?.text = namesCells[indexPath.row]
        
        //Проверка пришло ли значение из DetailVC если да то заполнение через другой массив
        if selectedBrandsWithDetailServiceVC == nil {
            cell.detailTextLabel?.text = valuesCells[indexPath.row]
        } else {
            cell.detailTextLabel?.text = valuesCellsCopy[indexPath.row]
        }
    }
    
    //Подготовка перехода
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "serviceDetailToDetailVC" {
            if let detailVC = segue.destination as? DetailServiceViewController {
                
                //Передача имени ячейки ( Марка авто, модель...)
                detailVC.cellsLabels = selectedCellLabelsToDetailVC
                
                //Передача выбранного бренда для заполнения Модели авто( это ключ для словаря в DetailVC)
                detailVC.selectedBrands = valuesCellsCopy[0]
            }
        }
        
//        if segue.identifier == "createNewCarSegue" {
//            if let newCarVC = segue.destination as? NewCarDoneViewController {
//                newCarVC.newCar = newCar
//            }
//        }
        
        
    }
    
    //UnwindSegue
    @IBAction func unwindDetailServiceToServiceToDetailVC(segue:UIStoryboardSegue) {
        
        if segue.source is DetailServiceViewController {
            if let vc = segue.source as? DetailServiceViewController {
                
                //Сохранение выбранных брэнда и модели с DetailVC когда возвращается
                selectedBrandsWithDetailServiceVC = vc.selectedBrands
                selectedModelWithDetailServiceVC = vc.selectedModel
                selectedTyreWithDetailServiceVC = vc.selectedTyre
                
                //Удаление элемента из массива и вписыние в него пришедшего значения( чтобы в cellDetail отображалась Марка и модель)
                valuesCellsCopy.remove(at: 0)
                valuesCellsCopy.insert(selectedBrandsWithDetailServiceVC!, at: 0)
                
                //Проверка не пустое ли свойство пришло чтобы не было пустой cellDetail
                if selectedModelWithDetailServiceVC != "" {
                    valuesCellsCopy.remove(at: 1)
                    valuesCellsCopy.insert(selectedModelWithDetailServiceVC!, at: 1)
                }
                if selectedTyreWithDetailServiceVC != "" {
                    valuesCellsCopy.remove(at: 2)
                    valuesCellsCopy.insert(selectedTyreWithDetailServiceVC!, at: 2)
                }
                
                self.tableView.reloadData()
            }
        }
    }
    
    //Вызов алерта
    private func showAlertVC(nameCell: String) {
       
        if nameCell == "Регистрационный номер" {
            
            let alertVC = UIAlertController(title: nameCell, message: "Введите регистрационный номер вашего автомобиля:", preferredStyle: .alert)
            
            alertVC.addTextField { (textField) in
                
            }
            
            let okAction = UIAlertAction(title: "Добавить", style: .default) { (action) in
                self.gosNumber = alertVC.textFields?.first?.text
                self.valuesCells.remove(at: 3)
                self.valuesCells.insert(self.gosNumber!, at: 3)
                
                self.valuesCellsCopy.remove(at: 3)
                self.valuesCellsCopy.insert(self.gosNumber!, at: 3)
                self.tableView.reloadData()
            }
            
            let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
            alertVC.addAction(okAction)
            alertVC.addAction(cancelAction)
            present(alertVC, animated: true, completion: nil)
        }
        
        else if nameCell == "VIN" {
            let alertVC = UIAlertController(title: nameCell, message: "Введите идентификационный номер VIN транспортного средства, 17 символов:", preferredStyle: .alert)
            
            alertVC.addTextField { (textField) in
                
            }
            
            let okAction = UIAlertAction(title: "Добавить", style: .default) { (action) in
                self.VINNumber = alertVC.textFields?.first?.text
                self.valuesCells.remove(at: 4)
                self.valuesCells.insert(self.VINNumber!, at: 4)
                
                self.valuesCellsCopy.remove(at: 4)
                self.valuesCellsCopy.insert(self.VINNumber!, at: 4)
                self.tableView.reloadData()
            }
            
            let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
            alertVC.addAction(okAction)
            alertVC.addAction(cancelAction)
            present(alertVC, animated: true, completion: nil)
        }
        
        else if nameCell == "Пробег автомобиля" {
            let alertVC = UIAlertController(title: nameCell, message: "Пробег вашего автомобиля, км.:", preferredStyle: .alert)
            
            alertVC.addTextField { (textField) in
                
            }
            
            let okAction = UIAlertAction(title: "Добавить", style: .default) { (action) in
                self.probeg = alertVC.textFields?.first?.text
                self.valuesCells.remove(at: 5)
                self.valuesCells.insert(self.probeg!, at: 5)
                
                self.valuesCellsCopy.remove(at: 5)
                self.valuesCellsCopy.insert(self.probeg!, at: 5)
                self.tableView.reloadData()
            }
            
            let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
            alertVC.addAction(okAction)
            alertVC.addAction(cancelAction)
            present(alertVC, animated: true, completion: nil)
        }
       
    }
    
    //Кнопка отмены изменений
    @IBAction func resetButton(_ sender: UIBarButtonItem) {
        
        //Обнуление значений
        selectedBrandsWithDetailServiceVC = nil
        selectedModelWithDetailServiceVC = nil
        selectedTyreWithDetailServiceVC = nil
        gosNumber = nil
        VINNumber = nil
        probeg = nil
        
        //Восстановление массива
        valuesCellsCopy = valuesCellsStatic
        valuesCells = valuesCellsStatic
        
        //Отключение кнопки
        doneButton.isEnabled = false
        doneButton.alpha = 0.4
        
        self.tableView.reloadData()
    }
}

//MARK: - Extensions
extension ServiceToDetailSeviceViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return namesCells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        configureCell(cell: cell, indexPath: indexPath)
        
        return cell
    }
}

extension ServiceToDetailSeviceViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        //Переход
        let index = namesCells[indexPath.row]
        selectedCellLabelsToDetailVC = index
        
        showAlertVC(nameCell: index)
        
       
        
        performSegue(withIdentifier: "serviceDetailToDetailVC", sender: index)
    }
}

