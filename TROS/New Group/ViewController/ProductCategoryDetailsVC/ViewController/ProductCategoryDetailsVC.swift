//
//  ProductCategoryDetailsVC.swift
//  TROS
//
//  Created by Swapnil Katkar on 22/06/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class ProductCategoryDetailsVC: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchBarView: UIView!
    @IBOutlet weak var productTableView: UITableView!
    var reachLastLimit = false
    var productList = [ProductList(dict: [String:Any]())]
    var productId = 0
    var pageCount = 1
    var isProductsFinished = false
    var productCategoryName = ""
    var isSearchBarHide = true
    var commonFilter = [ProductList(dict: [String:Any]())]
    {
        didSet{productTableView.reloadData()}
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if !productList.isEmpty
        {
            commonFilter = productList
            productTableView.reloadData()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        customiseNavigationBarWith(isHideNavigationBar: false, headingText: productCategoryName, isBackBtnVisible: true, accessToOpenSlider: true, leftBarOptionToShow: .search)
        searchBar.placeholder = "Type to search products"
    }
    @IBAction func CloseSearchBarPressed(_ sender: Any)
    {
        UIView.animate(withDuration: 0.5) {
        self.isSearchBarHide = true
        self.searchBarView.isHidden = true
        self.searchBar.resignFirstResponder()
        self.commonFilter.removeAll()
        self.commonFilter = self.productList
        }
        
    }
    
    
}
extension ProductCategoryDetailsVC:UITableViewDataSource,UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commonFilter.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryProductCell") as! CategoryProductCell
        cell.selectionStyle = .none
        cell.separatorInset = .zero
        cell.productImage.sd_setImage(with: URL(string: commonFilter[indexPath.row].imageUrl), placeholderImage: UIImage(named: PlaceholderImage))
        cell.brandName.text = commonFilter[indexPath.row].brand
        cell.price.text = "₹ : \(commonFilter[indexPath.row].cost)"
        cell.productNameLabel.text = commonFilter[indexPath.row].name
        cell.addToCartButton.tag = indexPath.row
        cell.addToCartButton.addTarget(self, action: #selector(addToCartPressed(sender:)), for: .touchUpInside)
        if indexPath.row == commonFilter.count-1 && !isProductsFinished && isSearchBarHide
        {
            loadNextfifteenProducts()
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.layer.transform = CATransform3DMakeScale(0.1,0.1,1)
        UIView.animate(withDuration: 0.3, animations: {
            cell.layer.transform = CATransform3DMakeScale(1.05,1.05,1)
        },completion: { finished in
            UIView.animate(withDuration: 0.1, animations: {
                cell.layer.transform = CATransform3DMakeScale(1,1,1)
            })
        })
    }
}
extension ProductCategoryDetailsVC : UISearchBarDelegate
{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if searchBar.text!.isEmpty
        {
            showAlertFor(title: "Products", description: "Enter search text to proceed .")
        }
        else
        {
        getSearchProductWithText(_searchText: searchBar.text ?? "")
        }
    }
}
extension ProductCategoryDetailsVC
{
    func loadNextfifteenProducts()
    {
        showLoaderWith(Msg: "Loading Products ...")
        ProductCategoriesListManager.loadCategoaryForProduct(productId:"\(productId)",pageCount:pageCount, completed: { (response) in
            switch response
            {
            case .success(let productList):
                self.pageCount += 1
                self.productList += productList
                self.commonFilter = self.productList
                 self.isProductsFinished = productList.isEmpty
                self.productTableView.reloadData()
                self.dismissLoader()
               
            case .failure:
                self.dismissLoader()
            }
        })
    }
    @objc func openSearchBar()
    {
        UIView.animate(withDuration: 0.5) {
            self.searchBarView.isHidden = false
            self.isSearchBarHide = false
        }
    }
    func getSearchProductWithText(_searchText : String)
    {
        showLoaderWith(Msg: "Loading Products ...")
        ProductCategoriesListManager.getSearchResultFor(searchText:_searchText , category: productId, completed: { (response) in
            switch response
            {
            case .success(let productList):
                self.commonFilter.removeAll()
               self.isProductsFinished = productList.isEmpty
                if productList.isEmpty
                {
                    self.showAlertFor(title: "Products", description: "No Product Found")
                }
                else
                {
                      self.commonFilter += productList
                }
                self.dismissLoader()
                
            case .failure:
                self.showAlertFor(title: "Products", description: "No Product Found")
                self.dismissLoader()
            }
        })
    }
   @objc func addToCartPressed(sender:UIButton)
    {
        showLoaderWith(Msg: "saving product in cart ...")
        CoreDataManager.manager.saveData(recordDict: self.commonFilter[sender.tag]) { (isSucess) in
            self.dismissLoader()
            if isSucess
            {
               self.showAlertFor(title: "Add to Cart", description: "Product added succesfully in cart")
            }
        }
    }
}

