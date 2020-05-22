//
//  LoginViewController.swift
//  M-JobOffice
//
//  Created by Stage on 30/01/17.
//  Copyright © 2017 Leonardo Canali. All rights reserved.
//

import UIKit
import MMDrawerController
import RxCocoa
import ZBarSDK
import CryptoSwift
import SwiftSpinner

class LoginViewController: BSDQrReaderViewController, UITextFieldDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblLogin: UILabel!
    @IBOutlet weak var txtUtente: UITextField!
    @IBOutlet weak var btnCheckBox: CheckBoxElement!
    @IBOutlet weak var txtToken: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    var fromGestioneAccount = false;
    var token, username : String?
    let IPHONE_6_VIEW_OFFSET_VALUE : CGFloat = 80.0
    let IPHONE_5_VIEW_OFFSET_VALUE : CGFloat = 120.0
    let IPAD_VIEW_OFFSET_VALUE : CGFloat = 140.0
    let TAG_TXT_USERNAME = 0
    let TAG_TXT_PASSWORD = 1
    let imagePicker = UIImagePickerController()
    let appDelegate = AppDelegate()
    
    
    var loginViewkeyboardOffset : CGFloat {
        get {
            if IS_IPAD {
                return IPAD_VIEW_OFFSET_VALUE
            } else if IS_IPHONE_4_OR_LESS || IS_IPHONE_5 {
                return IPHONE_5_VIEW_OFFSET_VALUE
            } else {
                return IPHONE_6_VIEW_OFFSET_VALUE
            }
        }
        set {}
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        txtPassword.isSecureTextEntry = true
        txtUtente.delegate = self
        txtPassword.delegate = self
        
        
        //		let encodedGzippedString = "H4sIAAAAAAAA/ysoyi9LBABmfJ3+BQAAAA=="
        //		let decoded = NSData(base64EncodedString: encodedGzippedString, options: NSDataBase64DecodingOptions(rawValue: 0))
        //		let stringBefore = NSString.init(data: decoded!, encoding: NSUTF8StringEncoding)
        //		let datadecompressed = decoded?.gunzippedData()
        //		let string = NSString.init(data: datadecompressed!, encoding: NSUTF8StringEncoding)
        //		print(string)
        
        
        drawRoundedBorder(textField: txtToken)
        drawRoundedBorder(textField: txtUtente)
        drawRoundedBorder(textField: txtPassword)
        txtPassword.layer.borderColor = UIColor.white.cgColor
        txtPassword.layer.borderWidth = 1.0
        
        if fromGestioneAccount {
            btnLogin.setTitle("AGGIUNGI", for: .normal)
            btnBack.isEnabled = true
            btnBack.isHidden = false
            lblLogin.text = "Scansiona il QR fornito per aggiungere un utente"
            
        }
        else {
            btnLogin.setTitle("LOGIN", for: .normal)
            btnBack.isEnabled = false
            btnBack.isHidden = true
            lblLogin.text = "Scansiona il QR fornito per accedere"
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func login(_ sender: UIButton) {
        if self.token
            != nil {
            if txtUtente.text != "" && txtPassword.text != ""  && txtToken.text != ""{
                
                //Update con campi manuali
                self.token = txtToken.text!
                self.username = txtUtente.text!
                
                var params = Dictionary<String,Any>()
                params["sicrawebUsername"] =  txtUtente.text
                params["sicrawebPassword"] = txtPassword.text
                params["mobileDesc"] = UIDevice.current.modelName
                params["token"] = txtToken.text
                Session.sharedInstance.deviceID = (UIDevice.current.identifierForVendor?.uuidString)!
                let _ = SwiftSpinner.show("Login in corso...", centerLogo: #imageLiteral(resourceName: "ic_spinner"), animated: true)
                let _ = WebService.sharedInstance.attivazioneDispositivo(params).subscribe(onNext: { (dict) in
                    let repoUtente = UtentiRepository()
                    let elencoUtenti = repoUtente.getUtenti()
                    if elencoUtenti.count > 0{
                        for utente in elencoUtenti{
                            utente.isSelezionato = false
                            repoUtente.deselezionaUtente(byToken: utente.tokenUtente)
                        }
                    }
                    let utente = Utente(JSON: dict as! NSDictionary, token: self.token!)
                    utente.isSelezionato = true
                    
                    //let repoListaAooUtente = ListaAooUtenteRepository()
                    Session.sharedInstance.username = self.username!
                    Session.sharedInstance.password = self.txtPassword.text!.md5()
                    utente.richiediPassword = self.btnCheckBox.getChecked()
                    repoUtente.insertUtente(utente)
                    
                    //repoListaAooUtente.insertListaAooUtente(utente.listeAoo)
                    
                    //TODO INSERIRE UTENTE CON LISTA AOO
                    Session.sharedInstance.token = self.token!
                    self.caricaAppunti()
                    UtilityHelper.getRelazioni(vc: self)
                    SwiftSpinner.hide()
                }, onError: { (error) in
                    print("x-x-x-x-x-x-x-x-x")
                    print(error)
                    print("x-x-x-x-x-x-x-x-x")
                    SwiftSpinner.hide()
                    ErrorManager.presentError(error: error as NSError, vc: self)
                    self.appDelegate.logout()
                }, onCompleted: {
                    print("Completed")
                }) {
                    print("Disposed")
                }
            } else {
                UtilityHelper.presentAlertMessage("Errore", message: "Compilare tutti i campi manualmente o tramite QR code.", viewController: self)
            }
        } else {
            UtilityHelper.presentAlertMessage("Errore", message: "Prima di effettuare il login è necessario attivare il dispositivo tramite il QR Code.", viewController: self)
        }
    }
    @IBAction func back(_ sender: UIButton) {
        
        //TODO : Sistemare per IPAD
        let _ = self.navigationController?.popViewController(animated: true)
        
    }
    
    func drawRoundedBorder(textField : UITextField){
        
        textField.layer.cornerRadius = 8.0
        textField.layer.masksToBounds = true
        textField.layer.borderColor = UIColor.white.cgColor
        textField.layer.borderWidth = 1.0
        
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == TAG_TXT_USERNAME {
            txtPassword.becomeFirstResponder()
        } else {
            txtPassword.resignFirstResponder()
            self.view.endEditing(true)
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDelegate(self)
        UIView.setAnimationDuration(0.2)
        UIView.setAnimationBeginsFromCurrentState(true)
        view.frame = CGRect(x: view.frame.origin.x, y: view.frame.origin.y - loginViewkeyboardOffset, width: view.frame.size.width, height: view.frame.size.height)
        UIView.commitAnimations()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDelegate(self)
        UIView.setAnimationDuration(0.2)
        UIView.setAnimationBeginsFromCurrentState(true)
        view.frame = CGRect(x: view.frame.origin.x, y: view.frame.origin.y + loginViewkeyboardOffset, width: view.frame.size.width, height: view.frame.size.height)
        UIView.commitAnimations()
    }
    
    //override func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    override func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        reader.dismiss(animated: true, completion: nil)
        readerGallery.dismiss(animated: true, completion: nil)
        UtilityHelper.presentAlertMessage("Completato", message: "Scansione completata con successo, prosegui per accedere", viewController: self)
        //let result = info[ZBarReaderControllerResults]
        let result = info[UIImagePickerController.InfoKey.init(rawValue: "ZBarReaderControllerResults")]
        let string = (result as! Array<ZBarSymbol>)[0].data
        let data: Data = string!.data(using: String.Encoding.utf8)!
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? NSDictionary
            let qrCodeModel = QRCodeModel(json: json!)
            self.txtToken.text = qrCodeModel.token!
            self.txtUtente.text = qrCodeModel.sicrawebUsername
            self.token = qrCodeModel.token!
            self.username = qrCodeModel.sicrawebUsername
            self.lblLogin.text = self.username!
            
        } catch {
            UtilityHelper.presentAlertMessage("errore", message: "login_errore_lettura_qr", viewController: self)
        }
        
        txtPassword.isHidden = false
        
    }
    
    override func readerControllerDidFail(toRead reader: ZBarReaderController!, withRetry retry: Bool) {
        
        reader.dismiss(animated: true, completion: nil)
        readerGallery.dismiss(animated: true, completion: nil)
        UtilityHelper.presentAlertMessage("errore", message: "login_errore_lettura_qr", viewController: self)
        
    }
    
    func caricaAppunti() {
        (UIApplication.shared.delegate as! AppDelegate).caricaAppunti()
    }
}
