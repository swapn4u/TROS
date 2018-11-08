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
        else
        {
            loadErrorViewOn(subview: self.view, forAlertType: .NoDataAvailable, errorMessage: NO_DATA_AVAILABLE_MSG) {
                
            }
        }
        productTableView.estimatedRowHeight = 110
        productTableView.rowHeight = UITableViewAutomaticDimension
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
        cell.brandName.text =  "Brand :" + commonFilter[indexPath.row].brand
        cell.price.text = "₹ : \(commonFilter[indexPath.row].cost) / \(commonFilter[indexPath.row].unit)"
        cell.descriptionText.isHidden = commonFilter[indexPath.row].description.trimmingCharacters(in: .whitespaces) == ""
        cell.descriptionText.text = self.commonFilter[indexPath.row].description.html2String.trimmingCharacters(in: .whitespaces).replacingOccurrences(of: "\n", with: "")
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
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0
        UIView.animate(withDuration: 0.5, delay:0.2, options: [.curveEaseIn], animations: {
            cell.alpha = 1
            
        }, completion: nil)
    }
}
extension ProductCategoryDetailsVC : UISearchBarDelegate
{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !isInternetActive()
        {
            //            loadErrorViewOn(subview: self.productTableView, forAlertType: .NoInternetConnection, errorMessage: NO_INTERNET_CONNECTIVITY) {
            //                self.searchBarSearchButtonClicked(searchBar)
            showAlertFor(title: "Search Products", description: NO_INTERNET_CONNECTIVITY)
            //            }
        }
        else{
            searchBar.resignFirstResponder()
            if searchBar.text!.isEmpty
            {
                showAlertFor(title: "Search Products", description: "Enter search text to proceed .")
            }
            else
            {
                getSearchProductWithText(_searchText: searchBar.text ?? "")
            }
        }
    }
     func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
     {
        if searchText.count>0
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
        if !isInternetActive()
        {
            showAlertFor(title: "Search Products", description: NO_INTERNET_CONNECTIVITY)
        }
        else
        {
            UIView.animate(withDuration: 0.5) {
                self.searchBarView.isHidden = false
                self.isSearchBarHide = false
            }
        }
    }
    func getSearchProductWithText(_searchText : String)
    {
        if !isInternetActive()
        {
            showAlertFor(title: "Search Products", description: NO_INTERNET_CONNECTIVITY)
        }
        else
        {
            showLoaderWith(Msg: "Searching Products ...")
            ProductCategoriesListManager.getSearchResultFor(searchText:_searchText , category: productId, completed: { (response) in
                switch response
                {
                case .success(let productList):
                    self.commonFilter.removeAll()
                    self.isProductsFinished = productList.isEmpty
                    if productList.isEmpty
                    {
                        self.showAlertFor(title: "Products", description: "Opps..No Product Found,We Make Available for You Soon")
                    }
                    else
                    {
                        self.commonFilter += productList
                    }
                    self.dismissLoader()
                    
                case .failure:
                    self.showAlertFor(title: "Products", description: "Opps..No Product Found,We Make Available for You Soon")
                    self.dismissLoader()
                }
            })
        }
    }
   @objc func addToCartPressed(sender:UIButton)
   {
    showLoaderWith(Msg: "saving product in cart ...")
    let isProductAddeddToCart =  CoreDataManager.manager.isProductAddedInCart(productId:self.commonFilter[sender.tag].id)
    if isProductAddeddToCart
    {
        self.dismissLoader()
        self.showAlertFor(title: "Add to Cart", description: "Product already added in cart")
    }
    else
    {
        CoreDataManager.manager.saveData(recordDict: self.commonFilter[sender.tag]) { (isSucess) in
            self.dismissLoader()
            if isSucess
            {
                self.showAlertFor(title: "Add to Cart", description: "Product added succesfully in cart")
            }
        }
    }
    }
}

