//
//  ViewController.swift
//  WeirdFace
//
//  Created by Patrick Doyle on 6/26/19.
//  Copyright © 2019 Patrick Doyle. All rights reserved.
//

import UIKit
import ARKit
import SceneKit
import StoreKit

class ViewController: UIViewController {
    
    var arTrackingSupported = true
    @IBOutlet weak var arNotSupportedTextView: UITextView!
    
    var selectedPreviewImage: UIImage?
    
    @IBOutlet var mainView: ARSCNView!
    @IBOutlet weak var watermark: UIImageView!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var acceptPositionButton: UIButton!
    
    @IBOutlet weak var transformPrimaryContainer: UIView!
    
    @IBOutlet weak var transformHeaderButtons: UIView!
    @IBOutlet weak var repositionButton: UIButton!
    @IBOutlet weak var resizeButton: UIButton!
    @IBOutlet weak var sizePicker: UIPickerView!
    @IBOutlet weak var acceptSizeButton: UIButton!
    @IBOutlet weak var repositionButtonContainer: UIView!
    
    @IBOutlet weak var resizeButtonContainer: UIView!
    @IBOutlet weak var uploadImageBorderedView: BorderedView!
    @IBOutlet weak var uploadedImage: UIImageView!
    @IBOutlet weak var uploadedImageContainer: UIView!
    @IBOutlet weak var drawnImageContainerView: UIView!
    @IBOutlet weak var drawnImageView: DrawnImageView!
    @IBOutlet weak var drawnImageViewFullScreenButton: UIButton!
    @IBOutlet weak var drawnImageViewFullScreenContainer: UIView!
    
    @IBOutlet weak var drawnImageFullScreenRotateMessage: UIView!
    @IBOutlet weak var drawnImageViewFullScreen: BorderedDrawnImageView!
    
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var drawnImageDiscardButton: UIButton!
    @IBOutlet weak var drawnImageAcceptButton: UIButton!
    @IBOutlet weak var drawnImageFullScreenAcceptButton: UIButton!
    @IBOutlet weak var drawnImageFullScreenUndoButton: UIButton!
    
    @IBOutlet weak var drawnImageFullScreenDiscardButton: UIButton!
    @IBOutlet weak var colorPickerButton: UIButton!
    @IBOutlet weak var colorPickerFullScreenButton: UIButton!
    @IBOutlet weak var uploadImageDiscardButton: UIButton!
    @IBOutlet weak var uploadImageAcceptButton: UIButton!
    @IBOutlet weak var transformLeftButton: UIButton!
    @IBOutlet weak var transformRightButton: UIButton!
    @IBOutlet weak var transformUpButton: UIButton!
    @IBOutlet weak var transformDownButton: UIButton!
    @IBOutlet weak var transformRotateCWButton: UIButton!
    @IBOutlet weak var transformRotateCCWButton: UIButton!
    @IBOutlet weak var transformMinusButton: UIButton!
    @IBOutlet weak var transformPlusButton: UIButton!
    @IBOutlet weak var transformPositionAcceptButton: UIButton!
    @IBOutlet weak var transformSelectSizeButton: UIButton!
    
    @IBOutlet weak var previewImageContainer: UIView!
    @IBOutlet weak var previewImage: UIImageView!
    @IBOutlet weak var discardPreviewButton: UIButton!
    @IBOutlet weak var removeWatermarkButton: UIButton!
    
    @IBOutlet weak var colorPicker: HSBColorPicker!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var tattooTypePicker: UIPickerView!
    @IBOutlet weak var sceneView: ARSCNView!
    var imagePicker = UIImagePickerController()
    
    @IBOutlet weak var settingsContainer: UIView!
    @IBOutlet weak var purchasePremiumButton: UIButton!
    @IBOutlet weak var restorePremiumButton: UIButton!
    
    @IBOutlet weak var selectTab: UITabBarItem!
    @IBOutlet weak var customTab: UITabBarItem!
    @IBOutlet weak var uploadTab: UITabBarItem!
    @IBOutlet weak var positionTab: UITabBarItem!
    @IBOutlet weak var addTatTab: UITabBarItem!
    @IBOutlet weak var shareTab: UITabBarItem!
    
    //App mode
    let modeSelect = 0
    let modeDraw = 1
    let modeUpload = 2
    let modePosition = 3
    let modePlace = 4
    let modeShare = 5
    var viewMode:Int = 0
    
    var imageChanged = false
    var tattooViewModel: ARViewModel?
    var mainUIViewModel: MainUIViewModel?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //Set bool to track if facetracking is supported, if it is not supported, facetracking features are disabled and a message is displayed to the user indicating that their device is not supported
        if ARFaceTrackingConfiguration.isSupported == false {
            arTrackingSupported = false
            arNotSupportedTextView.isHidden = false
            //fatalError("Face tracking is not supported on this device")
        } else {
            arNotSupportedTextView.isHidden = true
        }
        
        SKPaymentQueue.default().add(self)
        collectionView.delegate = self
        collectionView.dataSource = self
        tabBar.delegate = self
        tattooTypePicker.delegate = self
        tattooTypePicker.dataSource = self
        sizePicker.delegate = self
        sizePicker.dataSource = self
        sceneView.delegate = self
        colorPicker.delegate = self
        
        let tattooModel = ARModel(imageName: "blank", tattooType: .new)
        tattooViewModel = ARViewModel(tattooModel: tattooModel, delegate: self)
        tattooViewModel?.loadImage()
        
        let mainUIModel = MainUIModel()
        mainUIViewModel = MainUIViewModel(model: mainUIModel, delegate: self)
        
        
        configureButtonsAndViews()

        mainUIViewModel?.checkIfUserHasPremiumAccess()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
  
        //Observer for if Device Rotated
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(device_rotated),
                                            name:UIDevice.orientationDidChangeNotification,
                                               object: nil)
        if arTrackingSupported {
        let configuration = ARFaceTrackingConfiguration()
            sceneView.session.run(configuration)}
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIDevice.orientationDidChangeNotification,
                                                  object: nil)
        if arTrackingSupported{
                sceneView.session.pause()
        }
    }
    
    @objc func device_rotated(notification:Notification) -> Void{
        
        //If device is rotated, hide the message that tells user to rotate the device in full screen mode
        switch UIDevice.current.orientation {
        case .landscapeLeft, .landscapeRight:
            print("Landscape")
            drawnImageFullScreenRotateMessage.isHidden = true
        case .portrait, .portraitUpsideDown:
            print("Portrait")
        default:
            print("Default")
            drawnImageFullScreenRotateMessage.isHidden = true
        }
        
    }
    
    
    @IBAction func canvasDrawingAccepted(_ sender: UIButton) {
        
        //Update the tattoo image to be the user's drawing
        drawnImageView.layer.backgroundColor = UIColor.clear.cgColor
        drawnImageView.layer.borderWidth = 0.0
        let userDrawing = drawnImageView.screenShot
        tattooViewModel?.changeImage(image: userDrawing!)
        tattooViewModel?.manualDrawingAccepted()
    }
    
    
    @IBAction func canvasDrawingDiscarded(_ sender: UIButton) {
        
        drawnImageContainerView.isHidden = true
        drawnImageView.clear()
        
    }
    
    
    @IBAction func uploadedImageAccepted(_ sender: UIButton) {
        guard let image = uploadedImage.image else {return}
        uploadImageBorderedView.layer.borderWidth = 0.0
        guard let uploadedImage = uploadImageBorderedView.screenShot else {return}
        tattooViewModel?.changeImage(image: uploadedImage)
        tattooViewModel?.uploadedImageAccepted()
    }
    
    
    @IBAction func uploadedImageDiscarded(_ sender: UIButton) {
        uploadedImageContainer.isHidden = true
    }
    
    @IBAction func imageResizedByPinch(_ sender: UIPinchGestureRecognizer) {
        //User uploaded image can be resized by pinch
        uploadedImage.transform = CGAffineTransform(scaleX: sender.scale, y: sender.scale)
        
    }
    
    
    
    @IBAction func rotateClockwise(_ sender: UIButton) {
        
        tattooViewModel?.rotate(clockwise: true)
        
    }
    
    
    @IBAction func rotateCounterClock(_ sender: UIButton) {
        
        tattooViewModel?.rotate(clockwise: false)
    }
    
    
    @IBAction func plusX(_ sender: UIButton) {
        

        tattooViewModel?.incrementX()
    }
    
    
    @IBAction func plusY(_ sender: UIButton) {
        tattooViewModel?.decrementY()
        
    }
    
    
    @IBAction func minusX(_ sender: UIButton) {
        tattooViewModel?.decrementX()
        
    }
    
    @IBAction func minusY(_ sender: UIButton) {
        
        tattooViewModel?.incrementY()
        
    }
    
    
    @IBAction func sizeDecrease(_ sender: UIButton) {
        
        //Decrease tattoo size while keeping 2x1 proportions
        tattooViewModel?.decrementSize()
    }
    
    
    @IBAction func sizeIncrease(_ sender: UIButton) {
         //Increase tattoo size while keeping 2x1 proportions
        tattooViewModel?.incrementSize()
    }
    
    
    @IBAction func selectDefaultSize(_ sender: UIButton) {
        
        //Allow user to select a default size
        sizePicker.isHidden = false
        //Hide resize buttons while you select a size
        resizeButtonContainer.isHidden = true
    }
    
    
    
    func resetDrawView(){
        //Set the drawView back to its default state
        drawnImageView.layer.backgroundColor = UIColor.white.cgColor
        drawnImageView.layer.borderWidth = 2.0
    }
    
    func resetUploadView(){
        //set the uploadview back to its default state
        uploadImageBorderedView.layer.borderWidth = 2.0
    }
    
    
    @IBAction func acceptDefaultImagePosition(_ sender: UIButton) {
        
        //If tattoo auto position is accepted, tattoo manual transformation box is displayed for user to adjust the tattoo
        
        tattooViewModel?.acceptPosition()
        
    }
    
    
    @IBAction func resetButtonTapped(_ sender: UIButton) {
        
        //Reset the screen and remove all tattoos
        
        tattooViewModel?.reset()
  
    }
    
    
    
    @IBAction func drawnImageFullScreenButtonTapped(_ sender: UIButton) {
        
       mainUIViewModel?.drawnImageFullScreenModeRequested()
        
    }
    
    @IBAction func drawnImageFullScreenDiscardButtonTapped(_ sender: UIButton) {
        drawnImageViewFullScreenContainer.isHidden = true
        drawnImageViewFullScreen.clear()
    }
    
    @IBAction func drawnImageFullScreenAcceptButtonTapped(_ sender: UIButton) {
        
        //Update the tattoo image to be the user's drawing
        //Clear the background before taking a screenshot of the drawn image
        drawnImageViewFullScreen.layer.backgroundColor = UIColor.clear.cgColor
        let userDrawing = drawnImageViewFullScreen.screenShot?.rotate(radians: -.pi/2)
        
        drawnImageViewFullScreen.layer.backgroundColor = UIColor.white.cgColor
        tattooViewModel?.changeImage(image: userDrawing!)
        tattooViewModel?.fullScreenDrawingAccepted()
    }
    
    @IBAction func drawnImageColorWheelTapped(_ sender: UIButton) {
        
        //Show color wheel if premium account purchased, otherse show alert with option to purchase
        mainUIViewModel?.colorPickerRequested()
        
    }
    
    
    @IBAction func drawnImageFullScreenColorWheelTapped(_ sender: UIButton) {
        colorPicker.isHidden = false
    }
    
    
    @IBAction func drawnImageFullScreenUndoTapped(_ sender: UIButton) {
        //Undo the path and update the colorPicker button tint color to the previous color so the user knows what color they are working with
        drawnImageViewFullScreen.undo()
        let currentColor = drawnImageViewFullScreen.getCurrentColor()
        colorPickerFullScreenButton.tintColor = currentColor
        
    }
    
    
    @IBAction func discardPreviewButtonTapped(_ sender: UIButton) {
        hideImagePreview()
    }
    
    func hideImagePreview(){
        previewImageContainer.isHidden = true
    }
    
    func displayShareImageWindow(image: UIImage){
        
        let objectsToShare: [AnyObject] = [ image ]
        let activityViewController = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        self.present(activityViewController, animated: true, completion: nil)
        
    }
    
    @IBAction func removeWatermarkButtonTapped(_ sender: UIButton) {
        
            removeWatermarkButton.isEnabled = false
            self.buyInAppPurchases()
        
    }
    
    @IBAction func purchasePremiumButtonTapped(_ sender: UIButton) {
        //Purchase button tapped inside Settings menu
        purchasePremiumButton.isEnabled = false
         self.buyInAppPurchases()
        
    }
    
    @IBAction func restorePurchasesButtonTapped(_ sender: UIButton) {
        //Restore button tapped inside Settings menu
        restorePremiumButton.isEnabled = false
        self.restoreInAppPurchases()
    }
    
    
    @IBAction func settingsButtonTapped(_ sender: UIButton) {
        settingsContainer.isHidden = false
    }
    
    
    @IBAction func hideSettingsButtonTapped(_ sender: UIButton) {
        settingsContainer.isHidden = true
    }
    
    
    @IBAction func discardRotateMessageTapped(_ sender: UIButton) {
        //Hide rotate message if user presses X button
        drawnImageFullScreenRotateMessage.isHidden = true
    }
    
    @IBAction func repositionButtonTapped(_ sender: UIButton) {
        //Hide/show reposition buttons
        repositionButtonContainer.isHidden = !repositionButtonContainer.isHidden
        
        //Hide other transform containers
        resizeButtonContainer.isHidden = true
    }
    
    @IBAction func resizeButtonTapped(_ sender: UIButton) {
        //Hide/show resize buttons
        resizeButtonContainer.isHidden = !resizeButtonContainer.isHidden
        tattooViewModel?.arPickerType = .size
        sizePicker.reloadAllComponents()
        
        //Hide other transform containers
        repositionButtonContainer.isHidden = true
    }
    
    @IBAction func acceptSizeButtonTapped(_ sender: UIButton) {
        //Hide the size picker and show the resize buttons again
        acceptSizeButton.isHidden = true
        sizePicker.isHidden = true
        resizeButtonContainer.isHidden = false
    }
    
}

extension ViewController: ARSCNViewDelegate {
    
    
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        
        //New node added to AR renderer
        if !arTrackingSupported {return nil}
        
        guard let sceneView = renderer as? ARSCNView,
            anchor is ARFaceAnchor else { return nil }
        
 
        let faceGeometry = ARSCNFaceGeometry(device: sceneView.device!)!
        let material = faceGeometry.firstMaterial!
        
        
        //If the image was changed, set the new image on the face contents
        if imageChanged {
            material.diffuse.contents = tattooViewModel?.image
            material.lightingModel = .physicallyBased
            imageChanged = false
        }
 
 
       return SCNNode(geometry: faceGeometry)
        
    }
    
    func renderer(
        _ renderer: SCNSceneRenderer,
        didUpdate node: SCNNode,
        for anchor: ARAnchor) {
        
        if !arTrackingSupported {return}
        
        //Renderer node updated

        guard let faceGeometry = node.geometry as? ARSCNFaceGeometry,
            let faceAnchor = anchor as? ARFaceAnchor
            else { return }
        
        
        //If the image was changed, set the new image on the face contents
        if imageChanged {
            let material = faceGeometry.firstMaterial!
            material.diffuse.contents = tattooViewModel?.image
            material.lightingModel = .physicallyBased
            imageChanged = false
        }

        
        faceGeometry.update(from: faceAnchor.geometry)
 
    }
 
 
 
 
 
    
}

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    //There are 2 primary types of pickers, one to choose position and one to choose size.  The following picker methods are set based on the picker type that is currently in use
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
       
        switch tattooViewModel?.arPickerType{
             //Display all tattoo types except for the last one (which is the default type and shouldn't be selectable)
        case .position?: return FacialPosition.allCases.count - 1
            
             //Display all image sizes
        case .size?: return ARImageSize.allCases.count
        case .none:
            return FacialPosition.allCases.count - 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        //Return correct count depending on picker type being used
        
        switch tattooViewModel?.arPickerType{
        case .position?:  return FacialPosition(rawValue: row+1)?.description
        case .size?:  return ARImageSize(rawValue: row+1)?.description
        case .none:
             return FacialPosition(rawValue: row+1)?.description
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        //If Picker position is changed, update viewModel
        //If a new position is chose, the image must be repositioned
        
        //If Picker size is changed, update viewModel
        //New image size will be shown
        func setFacialPosition(){
            if let type = FacialPosition(rawValue: row+1) {
                tattooViewModel?.positionType = .auto
                tattooViewModel?.changeTattooType(type: type)
                acceptPositionButton.isHidden = false
            }
        }
        
        func setARImageSize(){
            
            if let type = ARImageSize(rawValue: row+1) {
                acceptSizeButton.isHidden = false
                let size = ARImageSize(rawValue: row+1)
                tattooViewModel?.setDefaultSize(size: size)
            }
            
            
        }
        
        switch tattooViewModel?.arPickerType{
        case .position?:  setFacialPosition()
        case .size?:  setARImageSize()
        case .none:
            setFacialPosition()
        }
        
    
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        //Add style (big green text) to the pickerview
        
        var title = UILabel()
        if var title = view {
            title = title as! UILabel
        }
        title.font = UIFont.systemFont(ofSize: 21, weight: UIFont.Weight.bold)
        title.textColor = UIColor.green
        
        switch tattooViewModel?.arPickerType{
        case .position?:   title.text = FacialPosition(rawValue: row+1)?.description
        case .size?:   title.text = ARImageSize(rawValue: row+1)?.description
        case .none:
           title.text = FacialPosition(rawValue: row+1)?.description
        }
      
        title.textAlignment = .center
        
        return title
    }
    
}

extension ViewController: UITabBarDelegate {
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        
        viewMode = item.tag
        
        //"Select mode" - user can select custom tattooo
        if item.tag == modeSelect {
            mainUIViewModel?.modeChanged(mode: .select)
        }
        
        //"Draw mode" - user can draw their own tattoo
        if item.tag == modeDraw {
             mainUIViewModel?.modeChanged(mode: .draw)
        }
        
        //"Upload mode" - user can upload their own tattoo
        if item.tag == modeUpload {
            mainUIViewModel?.modeChanged(mode: .upload)
        }
        
        //"Position mode" - User can position/transform the tattoo
        if item.tag == modePosition {
            tattooViewModel?.arPickerType = .position
            tattooViewModel?.positionType = .auto
            tattooViewModel?.displayPositionMap()
            mainUIViewModel?.modeChanged(mode: .position)
        }
        
        //"Place Mode" - User can place the tattoo and commit the changes (i.e. commit the tattoo to the user's face)
        if item.tag == modePlace {
            tattooViewModel?.commitTattoo()
            mainUIViewModel?.modeChanged(mode: .place)
        }
        
        //"Share Mode" - Save image to user's gallery or share via any other apps
        if item.tag == modeShare {
            let previewWindowOpen = !previewImageContainer.isHidden
            //Capture image of user
            let selectedImage = sceneView.snapshot()
            mainUIViewModel?.modeChangedToShare(previewWindowOpen: previewWindowOpen, snapshot: selectedImage)
            
        }
    }
    
    //Save image to user's gallery
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            showAlertWith(title: "Save error", message: error.localizedDescription)
        } else {
            showAlertWith(title: "Saved!", message: "Your image has been saved to your photos.")
        }
    }
    
    func showAlertWith(title: String, message: String){
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func displayPremiumAccessRequiredAlert(title: String, message: String){
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        ac.addAction(UIAlertAction(title: "Buy Premium Access", style: .default, handler: {action in
            self.buyInAppPurchases()
        }))
        present(ac, animated: true)
        
    }
    
    func verifyIfUserWantsToCompletePurchase(title: String, message: String, callback: @escaping (Bool) -> Void){
        //Verify if user wants to complete purchase of product and send callback
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "No", style: .default, handler: {action in
            callback(false)
        }))
        ac.addAction(UIAlertAction(title: "Buy", style: .default, handler: {action in
            callback(true)
        }))
        present(ac, animated: true)
    }
    
    
    
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return totalImageCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as! CollectionViewCell
        let imageName = String(indexPath.row)
        print("INDEX PATH", indexPath.row)
        cell.collectionImage.image = UIImage(named: imageName)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //Update the image in the viewModel to match the image selected in the collection view by the user
        let imageName = String(indexPath.row)
        tattooViewModel?.changeImage(named: imageName)
        collectionView.isHidden = true
        resetButton.isHidden = false
        settingsButton.isHidden = false
        positionTab.isEnabled = true
    }
    
    
    
    
}

extension ViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    
    func selectUploadPicture(){
        //Select photo from user's gallery
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            print("Button capture")
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true, completion: nil)
        }
        
    }
    
    //Image chosen by user
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        guard let image = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        uploadedImage.image = image
        
    }
    
}

extension ViewController: HSBColorPickerDelegate {
    func HSBColorColorPickerTouched(sender: HSBColorPicker, color: UIColor, point: CGPoint, state: UIGestureRecognizer.State) {
        //Color is chosen in color picker
        //Change the color of the pens in the drawnImageViews
        colorPicker.isHidden = true
        //Update the color picker button image color to show the chosen color so that the user can see the color they chose
        colorPickerButton.setImage(UIImage(named: "iconColorWheelTemplate"), for: .normal)
        colorPickerButton.tintColor = color
        colorPickerFullScreenButton.setImage(UIImage(named: "iconColorWheelTemplate"), for: .normal)
        colorPickerFullScreenButton.tintColor = color
        drawnImageView.changeColor(color: color)
        drawnImageViewFullScreen.changeColor(color: color)
    }
    
    
}

extension ViewController: ARViewModelViewDelegate{
    
    
    func resetARViews(){
        //Reset views to initial state of app
        transformPrimaryContainer.isHidden = true
        repositionButtonContainer.isHidden = true
        resizeButtonContainer.isHidden = true
        positionTab.isEnabled = false
        addTatTab.isEnabled = false
        shareTab.isEnabled = false
    }
    
    
    func fullScreenDrawingAccepted() {
         //When a full screen drawing is accepted, position tab is enabled for user to position image
        drawnImageViewFullScreenContainer.isHidden = true
        positionTab.isEnabled = true
    }
    
    func uploadedImageAccepted() {
        //When an uploaded image is accepted, position tab is enabled for user to position image
        uploadedImageContainer.isHidden = true
        positionTab.isEnabled = true
    }
    
    func manualDrawingAccepted() {
        //After manual drawing is accepted, position tab is enabled for user to position drawing
        drawnImageContainerView.isHidden = true
        positionTab.isEnabled = true
    }
    
    func arImagePositionAccepted() {
        //Position was accepted, set up views accordingly
        tattooTypePicker.isHidden = true
        sizePicker.isHidden = true
        acceptSizeButton.isHidden = true
        tattooViewModel?.positionType = .manual
        transformPrimaryContainer.isHidden = false
        acceptPositionButton.isHidden = true
        addTatTab.isEnabled = true
        
    }
    
    
    func arImagePositionUpdated() {
        //Let the renderer know that the image has changed
        imageChanged = true
    }
    
    
}

extension ViewController: MainUIViewModelViewDelegate{
  
    //If user has premium mode, configure views accordingly
    func premiumModeUnlocked() {
        configureViewsForPremiumMode(isPremium: true)
    }
    
    //Share image using other applications
    func shareImage(image: UIImage) {
        displayShareImageWindow(image: image)
    }
    
    //Set and show the user a preview of their snapshot
    func setAndShowPreviewImage(image: UIImage) {
        previewImage.image = image
        previewImageContainer.isHidden = false
    }
    
    func hideButtonsForSnapshot(){
        repositionButtonContainer.isHidden = true
        resizeButtonContainer.isHidden = true
        transformPrimaryContainer.isHidden = true
        settingsButton.isHidden = false
    }
    
    func playSnapshotSound() {
        //Play camera shutter sound
        AudioServicesPlaySystemSound(1108)
    }
    
    //Handle UI changes when the user changes the "mode" of the app
    
    func modeChanged(to mode: Mode, _ viewModel: MainUIViewModel) {
        
        resetViewsToDefault()
        
        switch mode {
        case .select: modeChangedToSelect()
        case .draw: modeChangedToDraw()
        case .upload: modeChangedToUpload()
        case .position: modeChangedToPosition()
        case .place: modeChangedToPlace()
        default:
            print("default")
        }
    }
    
    func resetViewsToDefault(){
        
    collectionView.isHidden = true
    resetButton.isHidden = false
    settingsButton.isHidden = false
    drawnImageContainerView.isHidden = true
    uploadedImageContainer.isHidden = true
    tattooTypePicker.isHidden = true
    acceptPositionButton.isHidden = true
    repositionButtonContainer.isHidden = true
    resizeButtonContainer.isHidden = true
    transformPrimaryContainer.isHidden = true
    
    }
    
    func modeChangedToSelect() {
        collectionView.isHidden = false
        resetButton.isHidden = true
        settingsButton.isHidden = true
        previewImageContainer.isHidden = true
    }
    
    func modeChangedToDraw() {
        resetDrawView()
        drawnImageContainerView.isHidden = false
        previewImageContainer.isHidden = true
    }
    
    func modeChangedToUpload() {
        resetUploadView()
        uploadedImageContainer.isHidden = false
        previewImageContainer.isHidden = true
        selectUploadPicture()
    }
    
    func modeChangedToPosition() {
        tattooTypePicker.isHidden = false
        previewImageContainer.isHidden = true
    }
    
    func modeChangedToPlace() {
        repositionButtonContainer.isHidden = true
        resizeButtonContainer.isHidden = true
        transformPrimaryContainer.isHidden = true
        sizePicker.isHidden = true
        acceptSizeButton.isHidden = true
        shareTab.isEnabled = true
        addTatTab.isEnabled = false
        positionTab.isEnabled = false
        settingsButton.isHidden = false
        previewImageContainer.isHidden = true
        tattooTypePicker.reloadAllComponents() //reload picker view to contain position dataa
    }
    
    func setViewsForColorPicker(unlocked: Bool) {
        //Show color wheel if premium account purchased, otherse show alert with option to purchase
        if unlocked {
            colorPicker.isHidden = false
        } else {
            colorPickerButton.isEnabled = false
            self.buyInAppPurchases()
        }
    }
    
    
    func setViewsForFullScreenDrawnImage(unlocked: Bool) {
        //Show color wheel if premium account purchased, otherwise show alert with option to purchase
        if unlocked {
            drawnImageViewFullScreenContainer.isHidden = false
            drawnImageContainerView.isHidden = true
            switch UIDevice.current.orientation{
            case .portrait, .portraitUpsideDown:
                //Show message that tells user to rotate device if screen is not landscape
                drawnImageFullScreenRotateMessage.isHidden = false
            default:
                print("Orientation Is Correct")
            }
        } else {
            drawnImageViewFullScreenButton.isEnabled = false
            self.buyInAppPurchases()
        }
    }
    
    
    
}



