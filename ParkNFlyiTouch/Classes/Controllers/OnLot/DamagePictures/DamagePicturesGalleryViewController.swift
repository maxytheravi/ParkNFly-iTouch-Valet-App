//
//  DamagePicturesGalleryViewController.swift
//  ParkNFlyiTouch
//
//  Created by Ravi Karadbhajane on 07/12/15.
//  Copyright © 2015 Cybage Software Pvt. Ltd. All rights reserved.
//

import UIKit

@objc protocol DamagePicturesGalleryDelegate {
    @objc optional func getUpdatedDamagePicturesArray(_ vehicleDamageBOArray:[VehicleDamageBO],location:String)
}

class DamagePicturesGalleryViewController: BaseViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var vehicleDamagePictureImageView: UIImageView!
    @IBOutlet weak var vehicleDamagePicturesCollectionView: UICollectionView!
    @IBOutlet weak var damageDescriptionTextView: UITextView!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    var selectIndex = 0
    var viewMoveBy: CGFloat = 220
    var vehicleDamageBOArray = [VehicleDamageBO]()
    var delegate: DamagePicturesGalleryDelegate?
    var imagePickerController: UIImagePickerController?
    var location: String?
    
    // MARK: ViewController life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Picture Gallery"
        
        // Do any additional setup after loading the view.
        
        self.refreshView()
        
        self.damageDescriptionTextView.layer.borderWidth = 0.5
        self.damageDescriptionTextView.layer.cornerRadius = 10.0
        self.damageDescriptionTextView.layer.masksToBounds = true
        self.damageDescriptionTextView.layer.borderColor = UIColor(red: 189.0/255.0, green: 189.0/255.0, blue: 189.0/255.0, alpha: 1.0).cgColor
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(DamagePicturesGalleryViewController.doneButtonClicked(_:)))
        
//        self.navigationItem.hidesBackButton = true
//        let newBackButton = UIBarButtonItem(title: "< Back", style: UIBarButtonItemStyle.Done, target: self, action: "backButtonClicked:")
//        self.navigationItem.leftBarButtonItem = newBackButton;
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    func refreshView() {
        
        if self.vehicleDamageBOArray.count == 0 {
            return
        }
        
        let vehicleDamageBO: VehicleDamageBO = self.vehicleDamageBOArray[self.selectIndex]
        
        self.damageDescriptionTextView.text = vehicleDamageBO.damageDesc
        self.vehicleDamagePictureImageView.image = vehicleDamageBO.vehicleDamageImage
        
        self.vehicleDamagePicturesCollectionView.reloadData()
        self.vehicleDamagePicturesCollectionView.scrollToItem(at: IndexPath(item: self.selectIndex, section: 0), at: UICollectionViewScrollPosition.centeredHorizontally, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Button Action Methods
    func doneButtonClicked(_ sender: AnyObject) {
        
        self.clearImagesFromArray()
        _ = self.navigationController?.popViewController(animated: true)
        self.delegate!.getUpdatedDamagePicturesArray!(vehicleDamageBOArray,location: self.location!)
    }
    
    override func popingViewController() {
        self.clearImagesFromArray()
    }
    
//    func backButtonClicked(sender: AnyObject) {
//        
//        self.clearImagesFromArray()
//        self.navigationController?.popViewControllerAnimated(true)
//    }
    
    @IBAction func nextPreviousButtonClicked(_ sender:UIButton) {
        
        self.view.endEditing(true)
        
        if sender.tag == 1 {
            self.selectIndex = ((self.vehicleDamageBOArray.count - 1) == self.selectIndex) ? 0 : (self.selectIndex + 1)
        } else {
            self.selectIndex = (self.selectIndex == 0) ? (self.vehicleDamageBOArray.count - 1) : (self.selectIndex - 1)
        }
        
        self.refreshView()
    }
    
    @IBAction func cameraButtonClicked(_ sender:UIButton) {
        
        self.view.endEditing(true)
        
        self.imagePickerController = UIImagePickerController()
        self.imagePickerController!.delegate = self
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera){
            self.imagePickerController!.sourceType = UIImagePickerControllerSourceType.camera
        } else {
            self.imagePickerController!.sourceType = UIImagePickerControllerSourceType.photoLibrary
        }
        self.imagePickerController!.allowsEditing = true
        self.present(self.imagePickerController!, animated: true, completion: nil)
        ActivityLogsManager.sharedInstance.logUserActivity(("Camera button is tapped"), logType: "Normal")
    }
    
    // MARK: - UIImagePickerController Methods
//    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!){
//        
////        let chosenImage: UIImage = editingInfo[UIImagePickerControllerEditedImage] as! UIImage
//        let tempImage = editingInfo[UIImagePickerControllerOriginalImage] as! UIImage
//        
//        self.addImageToArray(tempImage)
//        
//        self.dismissViewControllerAnimated(true, completion: { () -> Void in
//            self.imagePickerController = nil
//        })
//    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let image = info[UIImagePickerControllerEditedImage] as! UIImage
        self.addImageToArray(image)
        
        self.dismiss(animated: true, completion: { () -> Void in
            self.imagePickerController = nil
        })
    }
    
    // MARK: - Custom Methods
    func addImageToArray(_ image:UIImage) {
        
        let vehicleDamageBO = VehicleDamageBO()
        vehicleDamageBO.damageDesc = ""
        vehicleDamageBO.vehicleDamageImage = image
        if let imgageStream = ObjectiveCCommonMethods.base64forData(UIImageJPEGRepresentation(image,0)) {
            vehicleDamageBO.imageStream = imgageStream
        }
        vehicleDamageBO.location = self.location
        vehicleDamageBO.reportDateTime = Utility.stringFromDateAdjustmentWithT(Utility.getServerDateTimeFormat(), date: Date())
        vehicleDamageBO.ticketId = Int((naviController?.ticketBO?.ticketID)!)
        self.vehicleDamageBOArray.append(vehicleDamageBO)
        
        self.selectIndex = self.vehicleDamageBOArray.count - 1
        
        self.refreshView()
    }
    
    func clearImagesFromArray() {
        for vehicleDamageBO in self.vehicleDamageBOArray {
            vehicleDamageBO.vehicleDamageImage = nil
        }
    }
    
    // MARK: - UICollectionView Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.vehicleDamageBOArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAtIndexPath indexPath: IndexPath) -> UICollectionViewCell {
        
        let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DamagePictureGellery", for: indexPath) as! DamagePictureGelleryCollectionViewCell
        
        let vehicleDamageBO: VehicleDamageBO = self.vehicleDamageBOArray[(indexPath as NSIndexPath).item] 
        cell.damagePictureImageView.image = vehicleDamageBO.vehicleDamageImage
        
        if (indexPath as NSIndexPath).item == self.selectIndex {
            cell.damagePictureImageView.layer.borderWidth = 2.0;
            cell.damagePictureImageView.layer.borderColor = UIColor(red: 0.0/255.0, green: 176.0/255.0, blue: 219.0/255.0, alpha: 1.0).cgColor
        } else {
            cell.damagePictureImageView.layer.borderWidth = 2.0;
            cell.damagePictureImageView.layer.borderColor = UIColor.black.cgColor
        }
        
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: IndexPath) {
        
        self.view.endEditing(true)
        self.selectIndex = (indexPath as NSIndexPath).item
        
        self.refreshView()
    }
    
    // MARK: - UITextView Methods
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.topConstraint.constant = self.viewMoveBy * -1.0
        self.bottomConstraint.constant = self.viewMoveBy
//        self.view.updateConstraints()
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        }) 
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        let vehicleDamageBO: VehicleDamageBO = self.vehicleDamageBOArray[self.selectIndex]
        vehicleDamageBO.damageDesc = textView.text
        
        self.topConstraint.constant = 0.0
        self.bottomConstraint.constant = 0.0
//        self.view.updateConstraints()
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        }) 
    }
    
    //MARK: hiding keyboard when touch outside of textfields
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
