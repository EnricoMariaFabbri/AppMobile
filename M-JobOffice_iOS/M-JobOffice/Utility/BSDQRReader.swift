

import UIKit


class BSDQRReader: UIView {
    
    @IBOutlet weak var btnGallery: UIButton!
    @IBOutlet weak var btnSnapPic: UIButton!
    @IBOutlet weak var btnTurnCamera: UIButton!
    @IBOutlet weak var btnCompany: UIButton!
    @IBOutlet weak var btnFlash: UIButton!
    @IBOutlet weak var dismiss: UIButton!
    @IBOutlet weak var BottomView: UIView!
    @IBOutlet weak var lblCamera: UILabel!
    
    
    var flashOffImage : UIImage?
    var flashOnImage : UIImage?
    var ImageArray : [UIImage]?
    var themeColor : UIColor?
    
    
    
    override func draw(_ rect: CGRect) {
        
        //RoundedButtons
        btnGallery.layer.cornerRadius = btnGallery.frame.size.width / 2
        btnSnapPic.layer.cornerRadius = btnSnapPic.frame.size.width / 2
        btnTurnCamera.layer.cornerRadius = btnTurnCamera.frame.size.width / 2
        
    }
    
    
    
    public func initialize(withIconsForCompany : UIImage, flashOn : UIImage, flashOff : UIImage, dimiss : UIImage, turnCamera : UIImage, snapPic : UIImage, gallery : UIImage, themeColor : UIColor, on UiViewController : UIViewController ){
        
        
        self.themeColor = themeColor
        
        btnGallery.setImage(withIconsForCompany, for: .normal)
        btnSnapPic.setImage(snapPic, for: .normal)
        btnTurnCamera.setImage(turnCamera, for: .normal)
        btnFlash.setImage(flashOff, for: .normal)
        dismiss.setImage(dimiss, for: .normal)
        
    }
    
    public func setDefaultColor(){
        if self.themeColor != nil{
            changeTheme(byColor: self.themeColor!)
        }
    }
    
    public func changeTheme(byColor color : UIColor){
        
        BottomView.backgroundColor = color
        changeColor(color: color, button: btnFlash)
        changeColor(color: color, button: dismiss)
        changeColor(color: color, button: btnCompany)
        changeColor(color: color, button: btnTurnCamera)
        changeColor(color: color, button: btnSnapPic)
        changeColor(color: color, button: btnGallery)
        
    }
    private func changeColor(color : UIColor, button : UIButton){
        
        let image = button.image(for: .normal)?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = color
        
    }
    
    public func setTurnCameraText(byString text : String){
        lblCamera.text = text
    }
    
}
