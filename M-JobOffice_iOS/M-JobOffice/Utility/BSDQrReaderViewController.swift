//
//  BSDQrReader.swift
//  BSDQRCodeReader
//
//  Created by Leonardo Canali on 23/02/17.
//  Copyright © 2017 BSDUtility. All rights reserved.
//

import UIKit
import Foundation
import ZBarSDK

class BSDQrReaderViewController : BaseViewController, ZBarReaderDelegate  {
    
    
    @IBOutlet var viewOverlay: BSDQRReader! //CustomView per Scanner.
    @IBOutlet var btnFlash: UIButton! 

    
    
    let reader = ZBarReaderController() //Reader per scanner
    let readerGallery = ZBarReaderController() //Reader per imagePicker da galleria

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Settaggi reader relativo allo scanner.
        
        readerGallery.showsHelpOnFail = false
        if (UIImagePickerController.isSourceTypeAvailable(.camera)){
            reader.readerDelegate = self
            reader.sourceType = .camera
            reader.scanner.setSymbology(ZBAR_QRCODE, config: zbar_config_t(rawValue: UInt32(ENABLE_QRCODE)), to: 0)
            reader.showsCameraControls = false
            reader.showsZBarControls = false
            reader.showsHelpOnFail = false
            reader.cameraOverlayView = viewOverlay;
            reader.cameraOverlayView?.frame.size = view.frame.size
            reader.cameraOverlayView?.center = view.center
        }
        else{
            
        }
        
    }
    
    @IBAction func snapPic(_ sender: UIButton) {
        reader.takePicture()
    }
    
    @IBAction func dismissScanner(_ sender: UIButton) {
        reader.dismiss(animated: true, completion: nil)
    }
    @IBAction func TurnCamera(_ sender: UIButton) {
        
        switch reader.cameraDevice {
        case .front:
            viewOverlay.setTurnCameraText(byString: "Esterna")
            reader.cameraDevice = .rear
        case .rear:
            viewOverlay.setTurnCameraText(byString: "Interna")
            reader.cameraDevice = .front
        }
    }
    @IBAction func FlashONOFF(_ sender: UIButton) {
        
        if  reader.cameraFlashMode == .on{
            btnFlash.setImage(#imageLiteral(resourceName: "flash-off"), for: .normal)
            reader.cameraFlashMode = .off
            
            
        }
        else{
            btnFlash.setImage(#imageLiteral(resourceName: "flash-on-indicator"), for: .normal)
            reader.cameraFlashMode = .on
        }
        
    }
    
    
    override var shouldAutorotate: Bool{
        return false
    }
    
    @IBAction func openGallery(_ sender: UIButton) {
        openGalleryMethod()
    }
    
    func openGalleryMethod(){
        reader.dismiss(animated: true, completion: nil)
        readerGallery.readerDelegate = self
        //        readerGallery
        readerGallery.sourceType = .savedPhotosAlbum
        readerGallery.scanner.setSymbology(ZBAR_QRCODE, config: zbar_config_t(rawValue: UInt32(ENABLE_QRCODE)), to: 0)
        self.present(readerGallery, animated: true, completion: nil)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        reader.dismiss(animated: true, completion: nil)
        readerGallery.dismiss(animated: true, completion: nil)
    }
    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//
//    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
     
    }

    
    
    func readerControllerDidFail(toRead reader: ZBarReaderController!, withRetry retry: Bool) {
        print("fail to scan")
        reader.showsHelpOnFail = false
        readerGallery.showsHelpOnFail = false
    }
    
    @IBAction func leggiQR(_ sender: UIButton) {
        //let reader = ZBarReaderController()
        if (UIImagePickerController.isSourceTypeAvailable(.camera)){
            
            self.present(reader, animated: true, completion: nil)
            
        }
        else{
            openGalleryMethod()
        }
        
        
        
    }

}


