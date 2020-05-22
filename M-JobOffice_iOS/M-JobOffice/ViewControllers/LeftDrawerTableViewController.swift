//
//  LeftDrawerTableViewController.swift
//  M-JobOffice
//
//  Created by Stage on 30/01/17.
//  Copyright © 2017 Stage. All rights reserved.
//

import UIKit
import MMDrawerController
import SwiftSpinner
import RxSwift

class LeftDrawerTableViewController: UITableViewController, UISplitViewControllerDelegate {
    
    var highlightedCellIndexPath : IndexPath?
    var arrayVoci = [VoceMenu]()
    var countCell = -1
    
    let CELL_DEFAULT_HEIGHT : CGFloat = 44
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingDrawer()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrayVoci.count == 0{
            reloadMenu()
            return 0
        }
        // +6 perche sono le celle di menu statiche che non vengono scaricate dal server
        return arrayVoci.count + 6
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let arrayMenuToCheck = ["cedapp","cuapp","varapp","anfapp","vdfapp"]
        countCell += 1
        
        // ho messo un cout per ovviare al problema di tagliare fuori le celle non comprese in arrayVoci
        // questa funzione controlla che ci sia la voce di menu nel mio array
        if countCell < arrayVoci.count{
            for singleVoce in arrayMenuToCheck{
                if arrayVoci[indexPath[1]].code == singleVoce {
                    return CELL_DEFAULT_HEIGHT
                }
            }
            return 0
        }
        return CELL_DEFAULT_HEIGHT
        
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if highlightedCellIndexPath != nil {
            
            (tableView.cellForRow(at: highlightedCellIndexPath!)?.viewWithTag(2) as! UIImageView).tintColor = UIColor(red:0.40, green:0.40, blue:0.40, alpha:1.00)
            (tableView.cellForRow(at: highlightedCellIndexPath!)?.viewWithTag(1) as! UILabel ).textColor = UIColor(red:0.40, green:0.40, blue:0.40, alpha:1.00)
            
        }
        
        highlightedCellIndexPath = indexPath
        let selectedCell = (tableView.cellForRow(at: indexPath)) as! DrawerTableViewCell
        let unselectedImage = (selectedCell.viewWithTag(2) as! UIImageView).image!
        let selectedImage = unselectedImage.withRenderingMode(.alwaysTemplate)
        
        (selectedCell.viewWithTag(2) as! UIImageView).image = selectedImage
        (selectedCell.viewWithTag(2) as! UIImageView).tintColor =  UIColor(red:0.39, green:0.58, blue:0.22, alpha:1.00)
        (selectedCell.viewWithTag(1) as! UILabel).textColor = UIColor(red:0.39, green:0.58, blue:0.22, alpha:1.00)
        
        var storyboardID  = ""
        let code = selectedCell.code!
        var isMasterDetail = false
        
        
        //TODO : Il seguente switch, potrebbe non essere necessario, per il momentolo lascio nel caso possa serivire in futuro.
        switch code {
            
        case "cedolini":
            isMasterDetail = true
            storyboardID = code
            print("ok cedolini")
        case "cud":
            isMasterDetail = true
            storyboardID = code
            print("ok cud")
        case "anf":
            storyboardID = code
            isMasterDetail = true
            print("ok anf")
        case "datifiscali":
            storyboardID = code
            isMasterDetail = true
            print("ok dati")
        case "retribuzioni":
            storyboardID = code
        case "timbrature":
            storyboardID = code
            isMasterDetail = true
            print("ok timbrature")
        case "account":
            storyboardID = code
        case "impostazioni":
            storyboardID = code
        case "informazioni":
            storyboardID = code
        case "logout":
            var alertController = UIAlertController()
            if IS_IPAD{
                alertController = UIAlertController(title: "Attenzione", message: "alert_logout".localized(), preferredStyle: .alert)
            }
            else{
                alertController = UIAlertController(title: "Attenzione", message: "alert_logout".localized(), preferredStyle: .actionSheet)
            }
            let siAction = UIAlertAction(title: "Si", style: .destructive, handler: { (action) in
                (UIApplication.shared.delegate as! AppDelegate).logout()
            })
            let noAction = UIAlertAction(title: "No", style: .default, handler: {(action) in
                return
            })
            alertController.addAction(siAction)
            alertController.addAction(noAction)
            self.present(alertController, animated: true, completion: nil)
            return
            
        default:
            storyboardID = code
            return
        }
        
        if let view = storyboard?.instantiateViewController(withIdentifier: storyboardID){
            
            if !IS_IPAD || isMasterDetail{
                mm_drawerController.centerViewController = view
                mm_drawerController.closeDrawer(animated: true, velocity: 350, animationOptions: .allowAnimatedContent, completion: nil)
            }
            else{
                let navigation = UINavigationController(rootViewController: view)
                navigation.modalPresentationStyle = .formSheet
                navigation.isNavigationBarHidden = true
                present(navigation, animated: true , completion: nil)
            }
        }
    }
    
    
    func reloadMenu(){
        let vociMenuPersonale = WebService.sharedInstance.elencoMenuSubscriptor()
        let vociMenuTimbrature = WebService.sharedInstance.getVociMenuTimbrature()
        
        let _ = Observable.combineLatest(vociMenuPersonale, vociMenuTimbrature).subscribe(onNext: {(WSpersonale, WStimbrature) in
            
            let dictArrayOfVociPersonale = (WSpersonale as! Dictionary<String,Any>)["voci"] as! Array<Dictionary<String,Any>>
            let dictArrayOfVociTimbrature = (WStimbrature as! Dictionary<String,Any>)["voci"] as! Array<Dictionary<String,Any>>
            self.arrayVoci = []
            for dict in dictArrayOfVociPersonale{
                let voce = VoceMenu(fromDictionary: dict)
                self.arrayVoci.append(voce)
            }
            for dict in dictArrayOfVociTimbrature{
                let voce = VoceMenu(fromDictionary: dict)
                self.arrayVoci.append(voce)
            }
            
            
            self.arrayVoci = self.formattVociMenu(arrayVociMenu: self.arrayVoci)
            
        }, onError: { (error) in
            print(error)
        }, onCompleted: {
            print("Completed")
            self.tableView.reloadData()
        }) {
            print("Disposed")
        }
    }
    
    
    func settingDrawer() {
        
        mm_drawerController.shouldStretchDrawer = false
        mm_drawerController.openDrawerGestureModeMask = .all
        mm_drawerController.setDrawerVisualStateBlock { (drawerController, drawerSide, percentVisible) in
            let block : MMDrawerControllerDrawerVisualStateBlock? = MMDrawerVisualState.parallaxVisualStateBlock(withParallaxFactor: 10.0)
            if block != nil {
                
                block!(drawerController,drawerSide,percentVisible)
            }
        }
        
        mm_drawerController.setMaximumLeftDrawerWidth(250, animated: true, completion: nil)
        tableView.reloadData()
        
    }
    
    
    func formattVociMenu(arrayVociMenu vociMenu:[VoceMenu]) -> [VoceMenu] {
        
        var arrayVociMenuFormatted = [VoceMenu]()
        for voceMenu in vociMenu {
            if voceMenu.voce != nil{
                arrayVociMenuFormatted.append(voceMenu)
            }
        }
        
        // print di debug, mi sono utili in tutta la pagina
        /*for voceMenu in arrayVociMenuFormatted{
            print("x-x-x-x-x-x-x-x-x--x-x-x-x-x-x-x-x-x")
            print(voceMenu.voce!)
            print("x-x-x-x-x-x-x-x-x--x-x-x-x-x-x-x-x-x")
        }*/
        return arrayVociMenuFormatted
    }
}
