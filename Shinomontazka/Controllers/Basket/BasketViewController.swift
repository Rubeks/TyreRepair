//
//  BasketViewController.swift
//  Shinomontazka
//
//  Created by Раис Аглиуллов on 20/05/2019.
//  Copyright © 2019 Раис Аглиуллов. All rights reserved.
//

import UIKit
import CoreData

class BasketViewController: UIViewController {
    
    //Доступ к CoreData
    var basketCoreData: [BasketCoreData]?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var freeLabel: UILabel!
    @IBOutlet weak var orderButton: UIButton!{
        didSet {
            orderButton.layer.cornerRadius = 10
            orderButton.clipsToBounds = true
        }
    }
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        loadCarFromCoreData()
        
        //Если CoreData не пустая скрытие лейблов имедж и отображение ьаблицы
        if (basketCoreData?.first?.name != nil) && (basketCoreData?.first?.price != nil) {
            tableView.isHidden = false
            self.tableView.tableFooterView = UIView()
            
            imageView.isHidden = true
            freeLabel.isHidden = true
            orderButton.isHidden = false
            self.tableView.reloadData()
            
            print("core data note empty")
            
        } else if (basketCoreData?.first?.name == nil) || (basketCoreData?.first?.price == nil) {
            tableView.isHidden = true
            
            imageView.isHidden = false
            freeLabel.isHidden = false
            orderButton.isHidden = true
            print("core dara empty")
        }
    }
    
    @IBAction func orderButtonPressed(_ sender: UIButton) {
        
    }
    
    //Загрузка из БД корзины
    func loadCarFromCoreData() {
        
        // Добираюсь до АпДелегат. Нужно будет для свойства СейвКонтекст
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        // Получаю сам контекст
        let context = appDelegate.persistentContainer.viewContext
        
        // Создаю запрос к КорДате, чтобы получить все записи
        let fetchRequest: NSFetchRequest<BasketCoreData> = BasketCoreData.fetchRequest()
        
        // Обращаюсь к КорДате и пробую загрузить все в массив
        do {
            basketCoreData = try context.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    //Настройка ячейки
    func configureCell(cell: BasketTableViewCell, indexPath: IndexPath) {
        
        guard let itemCoreData = basketCoreData?[indexPath.row] else { return }
        
        //Пулучение значения цены из того дерьма что пришло "Цена 8890 Р/шт."
        let price = itemCoreData.price
        let words = price?.byWords
        let priceWord = words?[1]
        cell.price = priceWord
        
        cell.nameLabel.text = itemCoreData.name
        cell.priceLabel.text = itemCoreData.price
        //cell.priceLabel.text = "Цена " + "\(priceWord!)" + " ₽ / шт."
        
        //Загрузка картинки
        DispatchQueue.global().async {
            
            guard let imageUrl = URL(string: itemCoreData.imageUrl!) else { return }
            guard let imageData = try? Data(contentsOf: imageUrl) else { return }
            
            DispatchQueue.main.async {
                cell.customImageView.image = UIImage(data: imageData)
            }
        }
    }
    
}

extension BasketViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if basketCoreData != nil {
            return basketCoreData!.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? BasketTableViewCell {
            
            configureCell(cell: cell, indexPath: indexPath)
            
            return cell
        }
        
        return UITableViewCell()
    }
}

extension BasketViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        // Добираюсь до АпДелегат. Нужно будет для свойства СейвКонтекст
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        // Получаю сам контекст
        let context = appDelegate.persistentContainer.viewContext
        
        //Выбранная ячейка
        guard let deleteItem = basketCoreData?[indexPath.row], editingStyle == .delete else { return }
        
        //Удаление из массива
        basketCoreData?.remove(at: indexPath.row)
        
        //Удаление из CoreData
        context.delete(deleteItem)
        
        self.tableView.beginUpdates()
        
        //Попытка сохранения
        do {
            try context.save()
            tableView.deleteRows(at: [indexPath], with: .automatic)
        } catch {
            print(error.localizedDescription)
        }
        
        self.tableView.endUpdates()
        
        //Если CoreData обнулилась то скрываю таблицу
        if (basketCoreData?.first?.name == nil) && (basketCoreData?.first?.price == nil) {
            tableView.isHidden = true
            
            imageView.isHidden = false
            freeLabel.isHidden = false
            orderButton.isHidden = true
            print("core dara empty")
        }
    }
}

