//
//  SelectAddressVC.swift
//  TROS
//
//  Created by Swapnil Katkar on 29/07/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
protocol addressChangesProtocol
{
    func updateSelectedAdress(updateInfo:[String:Any])
}
class SelectAddressVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var savedAddressCounterTitle: UILabel!
    
    
    var delegate : addressChangesProtocol?
    var editableRow = 0
    
    var nameArr = [String]()//["Swapnil Anil Katkar","Anil Shankar Katkar","Kajal Anil Katkar"]
    var addressArr = [String]()//["BDD 17/7 ,N.M. Joshi Marg , Near Bawala Masjit,Lower Parel ,Mumbai ,Maharashtra - 400013","Front of vitthal temple , at - pedrewadi , tal - Ajara , Dist - Kolhapur , 416505" , "flat no 505 ,sheyansh tower , pimpari chinchwad , pune , 400025"]
    var mobileNoArr = [String]()//["8007415573","9764542059","8888258636"]
    
    var editableArr = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customiseNavigationBarWith(isHideNavigationBar: false, headingText: "My Addresses", isBackBtnVisible: true, accessToOpenSlider: false, leftBarOptionToShow: .none)
        tableView.estimatedRowHeight = 88
        tableView.rowHeight = UITableViewAutomaticDimension

        let defualts = UserDefaults.standard
        if let storedArr = defualts.array(forKey: "nameArr") as? [String]
        {
            nameArr = storedArr
            addressArr = defualts.array(forKey: "addressArr") as! [String]
            mobileNoArr = defualts.array(forKey: "mobileNoArr") as! [String]
            editableArr = defualts.array(forKey: "editableArr") as? [String] ?? [String]()
            tableView.reloadData()
        }
        
      savedAddressCounterTitle.text = "\(nameArr.count) SAVED ADRESSES"
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.tableView.reloadData()
    }
    @IBAction func addNewAddressPressed(_ sender: UIButton)
    {
        let addNewAddressVC = self.loadViewController(identifier: "CreateAddressVC") as! CreateAddressVC
        addNewAddressVC.delegate = self
        addNewAddressVC.isFromUpdate = false
        self.navigationController?.pushViewController(addNewAddressVC, animated: true)
    }
    
}
extension SelectAddressVC : UITableViewDataSource,UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectAddressCell") as! SelectAddressCell
        cell.nameLabel.text = nameArr[indexPath.row]
        cell.addressLabel.text  = addressArr[indexPath.row].replacingOccurrences(of: "*", with: "")
        cell.contactNoLabel.text = "Contact No : " + mobileNoArr[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let selectedCell = tableView.cellForRow(at: indexPath) as! SelectAddressCell
        let updateInfo = ["Name":selectedCell.nameLabel.text ?? "" ,"address":selectedCell.addressLabel.text ?? "" , "contactNo":mobileNoArr[indexPath.row]]
        delegate?.updateSelectedAdress(updateInfo: updateInfo)
        self.navigationController?.popViewController(animated: true)
    }
    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let editAction = UIContextualAction(style: .destructive, title: "Edit") { (action, view, handler) in
            let addNewAddressVC = self.loadViewController(identifier: "CreateAddressVC") as! CreateAddressVC
            let cell = tableView.cellForRow(at:indexPath) as! SelectAddressCell
            let addressArr = self.editableArr[indexPath.row].components(separatedBy: "*")
                if let editDataArr =  [cell.nameLabel.text!,self.mobileNoArr[indexPath.row],String(addressArr[2].dropLast()),String(addressArr[1].dropLast()),String(addressArr[0].dropLast()),String(addressArr[4]),String(addressArr[3].dropLast())] as? [String]
                {

                     addNewAddressVC.editData =  editDataArr
                }
            addNewAddressVC.isFromUpdate = true
            addNewAddressVC.delegate = self
            self.editableRow = indexPath.row
            self.navigationController?.pushViewController(addNewAddressVC, animated: true)
        }
        editAction.backgroundColor = .green
        let configuration = UISwipeActionsConfiguration(actions: [editAction])
        return configuration
    }
    
    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, handler) in
            self.nameArr.remove(at: indexPath.row)
            self.addressArr.remove(at: indexPath.row)
            self.mobileNoArr.remove(at: indexPath.row)
            self.editableArr.remove(at: indexPath.row)
            self.saveData()
            tableView.reloadData()
            self.savedAddressCounterTitle.text = "\(self.nameArr.count) SAVED ADRESSES"
        }
        deleteAction.backgroundColor = .red
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
}
extension SelectAddressVC : updateNewAddressDelegate
{
    func addNewAddress(updateInfo: [String : String],isFromUpdate:Bool) {
        if isFromUpdate
        {
            
            editableArr[editableRow] = updateInfo["address"]!
            
            nameArr[editableRow] = updateInfo["Name"]!
            addressArr[editableRow] = updateInfo["address"]!
            mobileNoArr[editableRow] = updateInfo["contactNo"]!
        }
        else
        {
            nameArr.append(updateInfo["Name"]!)
            addressArr.append(updateInfo["address"]!)
            mobileNoArr.append(updateInfo["contactNo"]!)
            editableArr.append(updateInfo["address"]!)
        }
        savedAddressCounterTitle.text = "\(nameArr.count) SAVED ADRESSES"
         saveData()
        tableView.reloadData()
    }
    func saveData()
    {
        let defaults = UserDefaults.standard
        defaults.set(nameArr, forKey: "nameArr")
        defaults.set(addressArr, forKey: "addressArr")
        defaults.set(mobileNoArr, forKey: "mobileNoArr")
        defaults.set(editableArr, forKey: "editableArr")
    }
    
}
