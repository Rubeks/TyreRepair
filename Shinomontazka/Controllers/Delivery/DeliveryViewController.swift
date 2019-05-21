//
//  DeliveryViewController.swift
//  Shinomontazka
//
//  Created by Раис Аглиуллов on 20/05/2019.
//  Copyright © 2019 Раис Аглиуллов. All rights reserved.
//

import UIKit
import CoreData

class DeliveryViewController: UIViewController {
    
    var basketCoreData: [BasketCoreData]?
    
    @IBOutlet weak var orderButton: UIButton!{
        didSet {
            orderButton.layer.cornerRadius = 10
            orderButton.clipsToBounds = true
        }
    }
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var adressTextField: UITextField!
    @IBOutlet weak var personalNameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var emailTetField: UITextField!
    @IBOutlet weak var itemCountLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Загрузка с CoreData
       loadCoreData()
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        //Количество элементов в массиве = количеству товаров
        let itemCount = basketCoreData?.count
        itemCountLabel.text = "Товаров к оплате: " + "\(itemCount!)"
    }
    
    //Отключение клавы при нажатие на экран в любом месте
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        cityTextField.resignFirstResponder()
        adressTextField.resignFirstResponder()
        personalNameTextField.resignFirstResponder()
        phoneNumberTextField.resignFirstResponder()
        emailTetField.resignFirstResponder()
        self.view.endEditing(true)
        
    }
    
    //Загрузка с CoreData
    func loadCoreData() {
        
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
    
    //Кнопка заказа - Заглушка
    @IBAction func orderButton(_ sender: UIButton) {
        
        let itemCount = basketCoreData?.count
        let alert = UIAlertController(title: "Вы заказали " + "\(itemCount!)" + " товара/ов", message: "Платите деньги!", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ладно", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
        
    
    }
    
    @IBAction func cityTextField(_ sender: UITextField) {
    }
    @IBAction func adressTextField(_ sender: UITextField) {
    }
    @IBAction func personalNameTextField(_ sender: UITextField) {
    }
    @IBAction func phoneNumberTextField(_ sender: UITextField) {
    }
    @IBAction func emailTetField(_ sender: UITextField) {
    }
    
}
extension DeliveryViewController: UITextFieldDelegate {
    
    //Выклбчение клавы при нажатие Enter
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
