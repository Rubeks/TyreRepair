//
//  MenuToDetailViewController.swift
//  Shinomontazka
//
//  Created by Раис Аглиуллов on 08/05/2019.
//  Copyright © 2019 Раис Аглиуллов. All rights reserved.
//

import UIKit

class MenuToDetailViewController: UIViewController {
    
    var selectedCell = ""
    
    //MARK: - Свойства
    //Массив структур для хранения шин
    private var structObjects = [universalStructMenuToDetail]()
    
    //Для передачи в DetailVC
    private var onceStructObject = universalStructMenuToDetail()
    
    //урл адресa
    private let urlTyre = NetworkManager.allTyresUrl
    private let urlDisk = NetworkManager.allDisksUrl
    private let urlAccumulator = NetworkManager.allAccumulatorsUrl
    
    //Для обновления таблицы через время
    private var myTimer: Timer!
    
    //MARK: - Oulets
    @IBOutlet weak var tableView: UITableView!
    
    
    //--------------------------------
    //MARK: - Methods
    override func viewDidLoad(){
    super.viewDidLoad()
    
    loadData()

    //Обновление таблицы
    self.myTimer = Timer(timeInterval: 2, target: self, selector: #selector(refresh), userInfo: nil, repeats: false)
    RunLoop.main.add(self.myTimer, forMode: .default)
        
        
        //Заголовок Naigation bar
        let firstWordTitleNAV = selectedCell.components(separatedBy: " ").last?.uppercased()
        self.title = firstWordTitleNAV
      
}
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //Отобразить tab bar
        tabBarController?.tabBar.layer.zPosition = 0
    }
    
    //Обновление таблицы
    @objc func refresh() {
        self.tableView.reloadData()
    }
    
    //Загрузка данных с JSON
    private func loadData() {
        
        switch selectedCell {
        case "Найти шины":
            NetworkManager.getDataWithJSON(url: urlTyre) { (tyres) in
                self.structObjects = tyres
            }
        case "Найти диски":
            NetworkManager.getDataWithJSON(url: urlDisk) { (disks) in
                self.structObjects = disks
            }
        case "Найти аккумуляторы":
            NetworkManager.getDataWithJSON(url: urlAccumulator) { (accumulator) in
                self.structObjects = accumulator
            }
        case "Сервис":
            print("service")
            
        default:
            break
        }
        
        
    }
   
    @IBAction func reloadButton(_ sender: UIBarButtonItem) {
        self.tableView.reloadData()
    }
    
    //Настройка ячейки
    private func configureCell(cell: MenuToDetailTableViewCell, indexPath: IndexPath) {

       let object = structObjects[indexPath.row]

        if object.name != nil {
            cell.nameLabel.text = object.name
        }
        
        if object.price != nil {
            cell.priceLabel.text = (object.price)!.description + " ₽ / шт."
            cell.fourPriceLabel.text = (object.price! * 4).description + " ₽ / 4шт."
        }
        
        DispatchQueue.global().async {
            guard let imageUrl = URL(string: object.imageUrl!) else { return }

            guard let imageData = try? Data(contentsOf: imageUrl) else { return }

            DispatchQueue.main.async {
                cell.cellImageView.image = UIImage(data: imageData)
            }
        }
    }
    
    //Передача в DetailVC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailVC" {
            if let detailVC = segue.destination as? DetailViewController {
                detailVC.objectStructDetailVC = onceStructObject
            }
        }
    }
}

//MARK: - Extensions
extension MenuToDetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return structObjects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? MenuToDetailTableViewCell {
           
            configureCell(cell: cell, indexPath: indexPath)
            
            return cell
        }
        return UITableViewCell()
    }
}

extension MenuToDetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let index = structObjects[indexPath.row]
        onceStructObject = index
       
        performSegue(withIdentifier: "showDetailVC", sender: index)
        
    }
}

