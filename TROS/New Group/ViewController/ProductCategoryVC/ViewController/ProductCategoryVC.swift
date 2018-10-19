//
//  ProductCategoryVC.swift
//  TROS
//
//  Created by Swapnil Katkar on 22/06/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class ProductCategoryVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    let categoriesListArr = ["Dairy","Bakery","Cosmatic","Grocery","Fruites & Vegetables","Genaral or Others","Personal Care","Frozen Products","Chocolates & Ice Cream","Sweets & Mithai","Snacks & Beverages","Toyes & Games","Healthy Leaving"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
      
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        customiseNavigationBarWith(isHideNavigationBar: false, headingText: "Category", isBackBtnVisible: false, accessToOpenSlider: true, leftBarOptionToShow: .search)
        saveRecord(value: "true", forKey: "isLogined")
    }

}
extension ProductCategoryVC : UICollectionViewDelegate , UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoriesListArr.count
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCategoriesCell", for: indexPath) as! ProductCategoriesCell
        cell.categoryImageView.image = UIImage(named: "c\(indexPath.row+1)")
        cell.categoryNameLabel.text = categoriesListArr[indexPath.row]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.size.width - 20) / 2, height: (collectionView.frame.size.width - 20) / 2)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        
        cell.alpha = 0
        UIView.animate(withDuration: 0.5) {
            cell.alpha = 1
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        showLoaderWith(Msg: "Loading Products ...")
        ProductCategoriesListManager.loadCategoaryForProduct(productId:"\(indexPath.row+1)",pageCount:1, completed: { (response) in
            switch response
            {
            case .success(let productList):
                let categoryVC = self.loadViewController(identifier: "ProductCategoryDetailsVC") as! ProductCategoryDetailsVC
                categoryVC.productList = []
                categoryVC.productList = productList
                categoryVC.productId = indexPath.row+1
                categoryVC.productCategoryName = self.categoriesListArr[indexPath.row]
                self.navigationController?.pushViewController(categoryVC, animated: true)
                self.dismissLoader()
                
            case .failure(let error):
                 self.dismissLoader()
                switch error {
                case .unknownError( _,_) :
                    self.showAlertFor(title: "Product List", description: NO_DATA_AVAILABLE_MSG)
                default:
                    self.showAlertFor(title: "Product List", description: SERVICE_FAILURE_MESSAGE)
                }
            }
            
        })
    }

}

//Other task
extension ProductCategoryVC
{
    func configureCollectioCell(_ cell:ProductCategoriesCell)
    {
        cell.categoryImageView.layer.cornerRadius = cell.categoryImageView.frame.size.width/2
       // cell.layer.cornerRadius = 5.0
        cell.layer.backgroundColor = UIColor.white.cgColor
        cell.layer.borderWidth = 5.0

    }
}
