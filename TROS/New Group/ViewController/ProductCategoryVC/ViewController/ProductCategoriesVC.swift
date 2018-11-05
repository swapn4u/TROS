//
//  ProductCategoriesVC.swift
//  TROS
//
//  Created by Swapnil Katkar on 01/11/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class ProductCategoriesVC: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    let categoriesListArr = ["Dairy","Bakery","Cosmatic","Grocery","Fruites & Vegetables","Genaral or Others","Personal Care","Frozen Products","Chocolates & Ice Cream","Sweets & Mithai","Snacks & Beverages","Toyes & Games","Healthy Leaving"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setRootVC("ProductCategoriesVC")
        saveRecord(value: "true", forKey: "isLogined")
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        customiseNavigationBarWith(isHideNavigationBar: false, headingText: "Category", isBackBtnVisible: false, accessToOpenSlider: true, leftBarOptionToShow: .cart)
    }
}
extension ProductCategoriesVC : UICollectionViewDelegate , UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoriesListArr.count
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCategoriesCell", for: indexPath) as! ProductCategoriesCell
        cell.categoryImageView.image = UIImage(named: "\(categoriesListArr[indexPath.row])")
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
        if isInternetActive()
        {
            loadProductsList(categoryID:indexPath.row)
        }
        else
        {
            self.showAlertFor(title: "Product List", description: NO_INTERNET_CONNECTIVITY)
        }
    }
    
}

//Other task
extension ProductCategoriesVC
{
    func configureCollectioCell(_ cell:ProductCategoriesCell)
    {
        cell.categoryImageView.layer.cornerRadius = cell.categoryImageView.frame.size.width/2
        // cell.layer.cornerRadius = 5.0
        cell.layer.backgroundColor = UIColor.white.cgColor
        cell.layer.borderWidth = 5.0
        
    }
    func loadProductsList(categoryID:Int)
    {
        showLoaderWith(Msg: "Loading Products ...")
        ProductCategoriesListManager.loadCategoaryForProduct(productId:"\(categoryID+1)",pageCount:1, completed: { (response) in
            switch response
            {
            case .success(let productList):
                let categoryVC = self.loadViewController(identifier: "ProductCategoryDetailsVC") as! ProductCategoryDetailsVC
                categoryVC.productList = []
                categoryVC.productList = productList
                categoryVC.productId = categoryID+1
                categoryVC.productCategoryName = self.categoriesListArr[categoryID]
                self.navigationController?.pushViewController(categoryVC, animated: true)
                self.dismissLoader()
                
            case .failure(let error):
                self.dismissLoader()
                switch error {
                case .noInternetConnection :
                    self.loadErrorViewOn(subview: self.collectionView, forAlertType: .NoInternetConnection, errorMessage: NO_INTERNET_CONNECTIVITY, retryButtonAction: {
                        self.loadProductsList(categoryID:categoryID)
                    })
                case .noDataAvailable:
                    self.loadErrorViewOn(subview: self.collectionView, forAlertType: .NoDataAvailable, errorMessage: NO_DATA_AVAILABLE_MSG, retryButtonAction: {
                    })
                    
                default:
                    self.showAlertFor(title: "Product List", description: SERVICE_FAILURE_MESSAGE)
                }
            }
            
        })
    }
}

