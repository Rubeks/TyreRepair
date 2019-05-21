//
//  DetailViewController.swift
//  Shinomontazka
//
//  Created by Раис Аглиуллов on 10/05/2019.
//  Copyright © 2019 Раис Аглиуллов. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UIViewController {
    
    //Для приема данных из MenuToDetailVC
    var objectStructDetailVC: universalStructMenuToDetail!
    
    //Массив с названиями ячеек
    let cellLabelsTyres = universalStructMenuToDetail.fillCellDetailVCTyres
    let cellLabelsDisks = universalStructMenuToDetail.fillCellDetailVCDisks
    let cellLabelsAccumulators = universalStructMenuToDetail.fillCellDetailVCAccumulators
    
    //Для сохранения значений соответсвующих пункту ( ширина 205, дмаметр - 29 и пр.)
    var arrayValuesCell: [String?] = []
    
    var basketCoreData: [BasketCoreData]?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var fourPrice: UILabel! {
        didSet {
            if objectStructDetailVC.shirina == nil && objectStructDetailVC.DIA == nil {
                fourPrice.isHidden = true
            }
        }
    }
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var buyBacketButton: UIButton! {
        didSet {
            buyBacketButton.layer.cornerRadius = buyBacketButton.bounds.size.height / 2
            buyBacketButton.clipsToBounds = true
        }
    }
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Скрытие tabBar
        self.tabBarController?.tabBar.layer.zPosition = -1
        
        //Заполнение View
        fillingView()
        
        //Заполнение массива
        fillingArrayNamesCell()
    }
    
    //Заполнение аутлетов
    private func fillingView() {
        guard let thisTyre = objectStructDetailVC else { return }
        
        nameLabel.text = thisTyre.name
        priceLabel.text = "Цена " + (thisTyre.price!).description + " ₽ / шт."
        fourPrice.text = (thisTyre.price! * 4).description + " ₽ за комплект из 4 штук"
        
        DispatchQueue.global().async {
            guard let imageUrl = URL(string: thisTyre.imageUrl!) else { return }
            guard let imageData = try? Data(contentsOf: imageUrl) else { return }
            
            DispatchQueue.main.async {
                self.imageView.image = UIImage(data: imageData)
            }
        }
    }
    
    //Заполнение массива значенияим соответсвующих пункту ( ширина 205, дмаметр - 29 и пр.)
    private func fillingArrayNamesCell() {
        
        if objectStructDetailVC.holes == nil && objectStructDetailVC.volt == nil {
            arrayValuesCell.append(objectStructDetailVC.shirina?.description)
            arrayValuesCell.append(objectStructDetailVC.profile?.description)
            arrayValuesCell.append(objectStructDetailVC.diametr?.description)
        } else if objectStructDetailVC.shirina == nil && objectStructDetailVC.volt == nil {
            arrayValuesCell.append(objectStructDetailVC.diametr?.description)
            arrayValuesCell.append(objectStructDetailVC.holes?.description)
            arrayValuesCell.append(objectStructDetailVC?.DIA?.description)
            arrayValuesCell.append(objectStructDetailVC.ET?.description)
        } else  {
            arrayValuesCell.append(objectStructDetailVC.size)
            arrayValuesCell.append(objectStructDetailVC.volt)
            arrayValuesCell.append(objectStructDetailVC.emkost)
            arrayValuesCell.append(objectStructDetailVC.puskovoitok)
        }
    }
    
    //Настройка ячейки
    private func configureCell(cell: DetailTableViewCell, indexPath: IndexPath) {
        
            //Шины
        if objectStructDetailVC.holes == nil && objectStructDetailVC.volt == nil {
            let cellName = cellLabelsTyres[indexPath.row]
            let cellValue = (arrayValuesCell[indexPath.row])?.description
            
            cell.cellLabel.text = cellName
            cell.cellValue.text = cellValue
            
            //Диски
        } else if objectStructDetailVC.shirina == nil && objectStructDetailVC.volt == nil {
            let cellName = cellLabelsDisks[indexPath.row]
            let cellValue = (arrayValuesCell[indexPath.row])?.description
            
            cell.cellLabel.text = cellName
            cell.cellValue.text = cellValue
            
            //Аккумуляторы
        } else {
            let cellName = cellLabelsAccumulators[indexPath.row]
            let cellValue = (arrayValuesCell[indexPath.row])?.description
            
            cell.cellLabel.text = cellName
            cell.cellValue.text = cellValue
        }
    }
    
    //Кнопка "В корзину"
    @IBAction func buyBacketButton(_ sender: UIButton) {
        
        //Проверка полей
        guard let name = nameLabel.text, let price = priceLabel.text, let fourPrice = fourPrice.text, let imageUrl = objectStructDetailVC.imageUrl else { return }
      
        //Сохранение
        saveItemInsideCoreData(name: name, price: price, fourPrice: fourPrice, imageUrl: imageUrl)
        
        //Вызов алерта при добавлении
        let alert = UIAlertController(title: "Товар добавлен в корзину!", message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    //Сохранение в БД аккумулятора шины или диска
    func saveItemInsideCoreData(name: String, price: String, fourPrice: String, imageUrl: String) {
        
        // Добираюсь до АпДелегат. Нужно будет для свойства СейвКонтекст
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        // Получаю сам контекст
        let context = appDelegate.persistentContainer.viewContext
        
        // Создаю сущность (в корДата все работает через сущности - своего рода класс)
        
        let entity = NSEntityDescription.entity(forEntityName: "BasketCoreData", in: context)
        
        // Создаю сам объект( из сущности и контекста) который хочу сохранить
        let item = NSManagedObject(entity: entity!, insertInto: context) as! BasketCoreData
        
        // Устанавливаю значение для carObject (из принимаемого значения функцией)
        item.name = name
        item.price = price
        item.fourPrice = fourPrice
        item.imageUrl = imageUrl
        
        // Сохраняю контекст, для того чтобы сохранился сам объект
        do {
            try context.save()
            basketCoreData?.append(item)
            print("Saved!")
        } catch {
            print(error.localizedDescription)
        }
    }
    
}

//MARK: - Extensions
extension DetailViewController: UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayValuesCell.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? DetailTableViewCell {
           
            configureCell(cell: cell, indexPath: indexPath)
            
            return cell
           
        }
        
        return UITableViewCell()
    }
}

extension DetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
