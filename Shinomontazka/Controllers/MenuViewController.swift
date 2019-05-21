//
//  FirstViewController.swift
//  Shinomontazka
//
//  Created by Раис Аглиуллов on 07/05/2019.
//  Copyright © 2019 Раис Аглиуллов. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    
    //Массив объектов структуры для заполнения ячеек
    private let cellObjects = MenuCellModelView.cellsObjects
    
    private var selectedCell = ""
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.backgroundColor = UIColor(red: 247 / 255, green: 247 / 255, blue: 247 / 255, alpha: 1)
        }
    }
    @IBOutlet weak var imageView: UIImageView!{
        didSet {
            imageView.layer.cornerRadius = 20
            imageView.clipsToBounds = true
            imageView.layer.borderColor = UIColor(red: 228 / 255, green: 228 / 255, blue: 228 / 255, alpha: 1).cgColor
            imageView.layer.borderWidth = 2
        }
    }
    @IBOutlet weak var topLabel: UILabel!
    
    //Цвет статус бара - белый
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let topColor = UIColor(red: 236 / 255, green: 238 / 255, blue: 239 / 255, alpha: 1)
        let downColor = UIColor(red: 26 / 255, green: 80 / 255, blue: 108 / 255, alpha: 1)
        
        navigationController?.navigationBar.setGradientBackgroundCenterToTopOrBottom(colorOne: topColor, colorTwo: downColor, direction: .centerToTop)
        
        
        //Заполнение imageView
        fillingImageView()
    }
    
    //--------------------
    //Setting imageView
    private func fillingImageView() {
        Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(setRandomImage), userInfo: nil, repeats: true)
    }
    
    //Метод для селектора , настройка imageView
    @objc func setRandomImage() {
        
        //Типо акции под картинку
        let labels = ["Успей сделать себе колеса!", "Дырявые колеса - езжай к нам!", "Выйграй замену колес!", "Новые поступления каждую неделю!", "Зачем переплачивать, когда можно сделать у нас!"]
        
        //Рандомное число
        let randomNumber = Int.random(in: 0..<5)
        
        //Рандомное имя
        let randomNameImage = "shin" + "\(randomNumber)"
        
        //Рандомное название из массива
        let randomLabel = labels[randomNumber]
        
        guard let image = UIImage(named: randomNameImage) else { return }
        
        imageView.image = image
        topLabel.text = randomLabel
    }
    //--------------------
    
    //Настройка ячейки
    private func configureCell(cell: MenuCollectionViewCell, for indexPath: IndexPath) {
        
        //Создание 1 структуры по индексу
        let cellObject = cellObjects[indexPath.row]
        
        cell.backgroundColor = .white
        cell.layer.cornerRadius = 20
        cell.layer.borderWidth = 2
        cell.layer.borderColor = UIColor(red: 228 / 255, green: 228 / 255, blue: 228 / 255, alpha: 1).cgColor
        //        cell.layer.shadowOffset = CGSize(width: 2, height: 2)
        //        cell.layer.shadowColor = UIColor.black.cgColor
        //        cell.layer.shadowOpacity = 0.8
        //        cell.layer.shadowRadius = 10
        cell.clipsToBounds = true
        cell.nameCellLabel.text = cellObject.nameLabel
        cell.backGroundImage.image = UIImage(named: cellObject.backgroundImage)
        cell.ugolImage.image = UIImage(named: cellObject.ugolImage)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let menuToDetailVC = segue.destination as? MenuToDetailViewController {
            menuToDetailVC.selectedCell = selectedCell
        }
    }
    
}

extension MenuViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellObjects.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? MenuCollectionViewCell {
            
            configureCell(cell: cell, for: indexPath)
            
            return cell
        }
        return UICollectionViewCell()
    }
}

extension MenuViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let index = cellObjects[indexPath.row]
        selectedCell = index.nameLabel
        
        switch selectedCell {
        case "Найти шины":
            performSegue(withIdentifier: "ShowMenuToDetailTyre", sender: nil)
        case "Найти диски":
            performSegue(withIdentifier: "ShowMenuToDetailDisk", sender: nil)
        case "Найти аккумуляторы":
            performSegue(withIdentifier: "ShowMenuToDetailAccumulator", sender: nil)
        case "Сервис":
           tabBarController?.selectedIndex = 1
           
        default:
            break
        }
    }
}

