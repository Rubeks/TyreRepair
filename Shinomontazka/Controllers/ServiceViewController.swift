//
//  ServiceViewController.swift
//  Shinomontazka
//
//  Created by Раис Аглиуллов on 13/05/2019.
//  Copyright © 2019 Раис Аглиуллов. All rights reserved.
//

import UIKit
import CoreData

class ServiceViewController: UIViewController {
    
    //В этот массив сохранаяюст новые машины и грузятся из него
    var newCarCoreData: [NewCarCoreData]?
    
    //MARK: - Outlets
    @IBOutlet weak var imagePreviewView: UIImageView!
    @IBOutlet weak var addPreviewLabel: UILabel!
    @IBOutlet weak var addPreviewButton: UIButton!{
        didSet {
            addPreviewButton.layer.cornerRadius = 15
            addPreviewButton.clipsToBounds = true
        }
    }
    
    //MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Загрузка из CoreData
        loadCarFromCoreData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        //Првоерка если CoreData не nil то переход на сохраненные машины
        if (newCarCoreData?.first?.carBrand != nil) && (newCarCoreData?.first?.carModel != nil) {
            performSegue(withIdentifier: "serviceVCToNewCarDoneSegue", sender: nil)
        }
        self.navigationItem.setHidesBackButton(true, animated: false)
    }
    
    @IBAction func addButton(_ sender: UIButton) {
        performSegue(withIdentifier: "serviceToDetailServiceSegue", sender: nil)
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
}
