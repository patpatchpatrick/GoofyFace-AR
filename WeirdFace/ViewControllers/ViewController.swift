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
import ReplayKit
import AVKit

class ViewController: UIViewController {
    
    var arTrackingSupported = true
    @IBOutlet weak var arNotSupportedTextView: UITextView!
    
    var selectedPreviewImage: UIImage?
    
    @IBOutlet var mainView: ARSCNView!
    @IBOutlet weak var watermark: UIImageView!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var acceptPositionButton: UIButton!
    
    @IBOutlet weak var transformPrimaryContainer: UIView!
    @IBOutlet weak var secondaryTattooModeSubMenu: UIView!
    @IBOutlet weak var secondaryTattooTransformSubMenu: UIView!
    @IBOutlet weak var sizePicker: UIPickerView!
    @IBOutlet weak var acceptSizeButton: UIButton!
    @IBOutlet weak var repositionButtonContainer: UIView!
    
    @IBOutlet weak var rotateButtonContainer: UIView!
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
    
    @IBOutlet weak var transformDoubleLeft: UIButton!
    
    @IBOutlet weak var transformDoubleRight: UIButton!
    @IBOutlet weak var transformDoubleDown: UIButton!
    
    @IBOutlet weak var transformDoubleUp: UIButton!
    
    @IBOutlet weak var transformRotateCWButton: UIButton!
    @IBOutlet weak var transformRotateCCWButton: UIButton!
    @IBOutlet weak var transformMinusButton: UIButton!
    @IBOutlet weak var transformPlusButton: UIButton!
    
    @IBOutlet weak var transformDoubleMinus: UIButton!
    
    @IBOutlet weak var transformDoublePlus: UIButton!
    
    @IBOutlet weak var transformPositionAcceptButton: UIButton!
    @IBOutlet weak var transformSelectSizeButton: UIButton!
    
    @IBOutlet weak var previewImageContainer: UIView!
    @IBOutlet weak var previewImage: UIImageView!
    @IBOutlet weak var discardPreviewButton: UIButton!
    @IBOutlet weak var removeWatermarkButton: UIButton!
    
    @IBOutlet weak var colorPicker: HSBColorPicker!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tattooTypePicker: UIPickerView!
    @IBOutlet weak var sceneView: ARSCNView!
    var imagePicker = UIImagePickerController()
    
    @IBOutlet weak var settingsContainer: UIView!
    @IBOutlet weak var purchasePremiumButton: UIButton!
    @IBOutlet weak var restorePremiumButton: UIButton!
    
    @IBOutlet weak var distortionSizeButton: RoundedButton!
    @IBOutlet weak var distortionPositionButton: RoundedButton!
    var distortionEditModeButtons: [UIButton] = []
    
    @IBOutlet weak var featuresSlider: UISlider!
    @IBOutlet weak var secondarySizeSubMenu: UIView!
    @IBOutlet weak var secondaryPositionSubMenu: UIView!
    @IBOutlet weak var secondaryScrollMenu: UIView!
    
    @IBOutlet weak var featureHeadButton: RoundedButton!
    @IBOutlet weak var featureMouthButton: RoundedButton!
    @IBOutlet weak var featureNoseButton: RoundedButton!
    @IBOutlet weak var featureEyesButton: RoundedButton!
    var featureButtons: [UIButton] = []
    
    @IBOutlet weak var positionXButton: RoundedButton!
    @IBOutlet weak var positionYButton: RoundedButton!
    @IBOutlet weak var positionZButton: RoundedButton!
    var positionButtons: [UIButton] = []
    
    
    @IBOutlet weak var tattooRepositionButton: RoundedButton!
    
    @IBOutlet weak var tattooResizeButton: RoundedButton!
    @IBOutlet weak var tattooRotateButton: RoundedButton!
    var tattooTransformButtons: [UIButton] = []
    
    @IBOutlet weak var faceDistortScrollMenu: UIView!
    @IBOutlet weak var tattooScrollMenu: UIView!
    @IBOutlet weak var modeSelectMenu: UIView!
    @IBOutlet weak var scrollMenu: UIView!
    @IBOutlet weak var selectButton: RoundedButton!
    @IBOutlet weak var drawButton: RoundedButton!
    @IBOutlet weak var uploadButton: RoundedButton!
    @IBOutlet weak var placeButton: RoundedButton!
    @IBOutlet weak var addButton: RoundedButton!
    @IBOutlet weak var shareButton: RoundedButton!
    @IBOutlet weak var tattooTypeButton: RoundedButton!
    @IBOutlet weak var stopRecordButton: RoundedButton!
    
    var tattooMainMenuButtons: [UIButton] = []
    
    var tattooViewModel: ARImageViewModel?
    var mainUIViewModel: MainUIViewModel?
    var distortionViewModel: ARDistortionViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //Set bool to track if facetracking is supported, if it is not supported, facetracking features are disabled and a message is displayed to the user indicating that their device is not supported
        if ARFaceTrackingConfiguration.isSupported == false {
            arTrackingSupported = false
            arNotSupportedTextView.isHidden = false
        } else {
            arNotSupportedTextView.isHidden = true
        }
        
        SKPaymentQueue.default().add(self)
        collectionView.delegate = self
        collectionView.dataSource = self
        tattooTypePicker.delegate = self
        tattooTypePicker.dataSource = self
        sizePicker.delegate = self
        sizePicker.dataSource = self
        sceneView.delegate = self
        colorPicker.delegate = self
        
        let tattooModel = ARImageModel(imageName: "blank", tattooType: .new)
        tattooViewModel = ARImageViewModel(tattooModel: tattooModel, delegate: self)
        tattooViewModel?.loadImage()
        
        let mainUIModel = MainUIModel()
        mainUIViewModel = MainUIViewModel(model: mainUIModel, delegate: self)
        
        let distortionModel = ARDistortionModel()
        distortionViewModel = ARDistortionViewModel(model: distortionModel, delegate: self)
        
        /*
        var instanceOfCustomObject: ShaderModifier = ShaderModifier()
        instanceOfCustomObject.someProperty = "Hello World"
        print(instanceOfCustomObject.someProperty)
        instanceOfCustomObject.someMethod() */
        
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
        

        tattooViewModel?.incrementX(multiplier: 1)
    }
    
    
    @IBAction func plusY(_ sender: UIButton) {
        tattooViewModel?.decrementY(multiplier: 1)
        
    }
    
    
    @IBAction func minusX(_ sender: UIButton) {
        tattooViewModel?.decrementX(multiplier: 1)
        
    }
    
    @IBAction func minusY(_ sender: UIButton) {
        
        tattooViewModel?.incrementY(multiplier: 1)
        
    }
    
    @IBAction func minusXDouble(_ sender: UIButton) {
        tattooViewModel?.decrementX(multiplier: 3)
    }
    
    
    @IBAction func plusXDouble(_ sender: UIButton) {
        tattooViewModel?.incrementX(multiplier: 3)
    }
    
    
    @IBAction func minusYDouble(_ sender: UIButton) {
         tattooViewModel?.incrementY(multiplier: 3)
    }
    
    
    @IBAction func plusYDouble(_ sender: UIButton) {
        tattooViewModel?.decrementY(multiplier: 3)
    }
    
    @IBAction func sizeDecrease(_ sender: UIButton) {
        
        //Decrease tattoo size while keeping 2x1 proportions
        tattooViewModel?.decrementSize(multiplier: 1)
    }
    
    
    @IBAction func sizeIncrease(_ sender: UIButton) {
         //Increase tattoo size while keeping 2x1 proportions
        tattooViewModel?.incrementSize(multiplier: 1)
    }
    
    @IBAction func sizeDecreaseDouble(_ sender: UIButton) {
        //Decrease tattoo size while keeping 2x1 proportions
        tattooViewModel?.decrementSize(multiplier: 3)
    }
    
    
    @IBAction func sizeIncreaseDouble(_ sender: UIButton) {
        //Increase tattoo size while keeping 2x1 proportions
        tattooViewModel?.incrementSize(multiplier: 3)
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
        distortionViewModel?.reset()
        mainUIViewModel?.reset()
  
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
        rotateButtonContainer.isHidden = true
        mainUIViewModel?.transformButtonSelected(button: sender)
    }
    
    @IBAction func resizeButtonTapped(_ sender: UIButton) {
        //Hide/show resize buttons
        resizeButtonContainer.isHidden = !resizeButtonContainer.isHidden
        tattooViewModel?.arPickerType = .size
        sizePicker.reloadAllComponents()
        
        //Hide other transform containers
        repositionButtonContainer.isHidden = true
        rotateButtonContainer.isHidden = true
        mainUIViewModel?.transformButtonSelected(button: sender)
    }
    
    @IBAction func rotateHeaderButtonTapped(_ sender: UIButton) {
        rotateButtonContainer.isHidden = !rotateButtonContainer.isHidden
        
        //Hide other transform containers
        repositionButtonContainer.isHidden = true
        resizeButtonContainer.isHidden = true
        mainUIViewModel?.transformButtonSelected(button: sender)
    }
    
    
    @IBAction func acceptSizeButtonTapped(_ sender: UIButton) {
        //Hide the size picker and show the resize buttons again
        acceptSizeButton.isHidden = true
        sizePicker.isHidden = true
        //Reset size picker to reselect initial item after a size is chosen
        sizePicker.selectRow(0, inComponent:0, animated:true)
        resizeButtonContainer.isHidden = false
    }
    
    
    @IBAction func scrollMenuButtonTapped(_ sender: UIButton) {
        
        viewMode = sender.tag
        
        if viewMode == modeRecord {
            mainUIViewModel?.recordButtonTapped()
        }
        
        //"Change mode" - user can change the app mode
        if viewMode == modeChange {
            //Toggle mode select menu
            mainUIViewModel?.hideAllTattooSubMenus()
            distortionViewModel?.hideAllSubMenus()
            distortionViewModel?.modeSelectMenuTapped()
        }
        
        //"Tattoo Type" - select type of tattoo to use (custom/draw/uplaod)
        if viewMode == modeTattooType {
            //Toggle mode select menu
            mainUIViewModel?.selectTattooType(button: sender)
            
        }
        
        //"Custom mode" - user can select custom tattooo
        if viewMode == modeCustom {
            mainUIViewModel?.tattooModeChanged(mode: .custom, button: sender)
        }
        
        //"Draw mode" - user can draw their own tattoo
        if viewMode == modeDraw {
            mainUIViewModel?.tattooModeChanged(mode: .draw, button: sender)
        }
        
        //"Upload mode" - user can upload their own tattoo
        if viewMode == modeUpload {
            mainUIViewModel?.tattooModeChanged(mode: .upload, button: sender)
        }
        
        //"Position mode" - User can position/transform the tattoo
        if viewMode == modePosition {
            tattooViewModel?.arPickerType = .position
            tattooViewModel?.positionType = .auto
            tattooViewModel?.displayPositionMap()
            mainUIViewModel?.tattooModeChanged(mode: .position, button: sender)
        }
        
        //"Place Mode" - User can place the tattoo and commit the changes (i.e. commit the tattoo to the user's face)
        if viewMode == modePlace {
            tattooViewModel?.commitTattoo()
            mainUIViewModel?.tattooModeChanged(mode: .place, button: sender)
        }
        
        //"Share Mode" - Save image to user's gallery or share via any other apps
        if viewMode == modeShare {
            let previewWindowOpen = !previewImageContainer.isHidden
            //Capture image of user
            let selectedImage = sceneView.snapshot()
            mainUIViewModel?.modeChangedToShare(previewWindowOpen: previewWindowOpen, snapshot: selectedImage, button: sender)
            
        }
    }
    
    
    @IBAction func primaryAppModeChanged(_ sender: UIButton) {
        
        //Change the mode of the app
        let appMode = sender.tag
        mainUIViewModel?.primaryModeChanged(appMode: appMode)
        modeSelectMenu.isHidden = true
        
    }
    
    
    @IBAction func distortionEditModeChanged(_ sender: UIButton) {
        
        //Edit mode for facial distortion changed
        let editMode = sender.tag
        distortionViewModel?.distortionEditModeChanged(editMode: editMode, button: sender)
    }
    
    
    @IBAction func facialFeatureButtonTapped(_ sender: UIButton) {
        
        //Toggle features slider
        featuresSlider.isHidden = false
        
        //Update the current feature being edited
        let featureType = sender.tag
        distortionViewModel?.setCurrentFeatureBeingEdited(feature: featureType, button: sender)
        
    }
    
    @IBAction func featureSliderValueChanged(_ sender: UISlider) {
        distortionViewModel?.featureSliderValueUpdated(value: sender.value)
    }
    
    
    @IBAction func hideTransformControls(_ sender: UIButton) {
        
        secondaryScrollMenu.isHidden = true
        secondaryTattooTransformSubMenu.isHidden = true
        transformPrimaryContainer.isHidden = true
    }
    
    @IBAction func distortionShareButtonTapped(_ sender: UIButton) {
        
        let previewWindowOpen = !previewImageContainer.isHidden
        //Capture image of user
        let selectedImage = sceneView.snapshot()
        mainUIViewModel?.modeChangedToShare(previewWindowOpen: previewWindowOpen, snapshot: selectedImage, button: sender)
        
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
        //If a new position is chosen, the image must be repositioned
        
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

extension ViewController {
    
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
        let imageName = String(totalImageCount - indexPath.row - 1)
        print("INDEX PATH", indexPath.row)
        cell.collectionImage.image = UIImage(named: imageName)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //Update the image in the viewModel to match the image selected in the collection view by the user
        let imageName = String(totalImageCount - indexPath.row - 1)
        tattooViewModel?.changeImage(named: imageName)
        collectionView.isHidden = true
        resetButton.isHidden = false
        settingsButton.isHidden = false
        configureEnabledButton(button: placeButton)
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

extension ViewController: ARImageViewModelViewDelegate{
    
    
    func resetARViews(){
        //Reset views to initial state of app
        transformPrimaryContainer.isHidden = true
        repositionButtonContainer.isHidden = true
        rotateButtonContainer.isHidden = true
        resizeButtonContainer.isHidden = true
        configureDisabledButton(button: placeButton)
        configureDisabledButton(button: addButton)
        configureDisabledButton(button: shareButton)
    }
    
    
    func fullScreenDrawingAccepted() {
         //When a full screen drawing is accepted, position tab is enabled for user to position image
        drawnImageViewFullScreenContainer.isHidden = true
        configureEnabledButton(button: placeButton)
    }
    
    func uploadedImageAccepted() {
        //When an uploaded image is accepted, position tab is enabled for user to position image
        uploadedImageContainer.isHidden = true
        configureEnabledButton(button: placeButton)
    }
    
    func manualDrawingAccepted() {
        //After manual drawing is accepted, position tab is enabled for user to position drawing
        drawnImageContainerView.isHidden = true
        configureEnabledButton(button: placeButton)
    }
    
    func arImagePositionAccepted() {
        //Position was accepted, set up views accordingly
        tattooTypePicker.isHidden = true
        sizePicker.isHidden = true
        acceptSizeButton.isHidden = true
        tattooViewModel?.positionType = .manual
        secondaryScrollMenu.isHidden = false
        secondaryTattooTransformSubMenu.isHidden = false
        transformPrimaryContainer.isHidden = false
        acceptPositionButton.isHidden = true
        configureEnabledButton(button: addButton)
        
    }
    
    
    func arImagePositionUpdated() {
        //Let the renderer know that the image has changed
        tattooViewModel?.imageChanged = true
    }
    
    
}

extension ViewController: MainUIViewModelViewDelegate{
    
    
    func startScreenRecording() {
        rpStartRecording()
    }
    
    func stopScreenRecording() {
        rpStopRecording()
    }
    
    func hideSecondaryMenu() {
        secondaryScrollMenu.isHidden = true
        secondaryTattooModeSubMenu.isHidden = true
        secondaryTattooTransformSubMenu.isHidden = true
        featuresSlider.isHidden = true
    }
    
    
    func toggleTattooModeMenu() {
        secondaryScrollMenu.isHidden = !secondaryScrollMenu.isHidden
        secondaryTattooModeSubMenu.isHidden = secondaryScrollMenu.isHidden
    }
    
    
    func hideTattooSubMenus() {
        acceptPositionButton.isHidden = true
        acceptSizeButton.isHidden = true
        tattooTypePicker.isHidden = true
        sizePicker.isHidden = true
        secondaryScrollMenu.isHidden = true
        secondaryTattooTransformSubMenu.isHidden = true
        secondaryTattooModeSubMenu.isHidden = true
        transformPrimaryContainer.isHidden = true
        drawnImageContainerView.isHidden = true
        uploadedImageContainer.isHidden = true
        drawnImageViewFullScreenContainer.isHidden = true
        hideImagePreview()
    }
    
    
    func unselectAllButtons() {
        for button in tattooMainMenuButtons {
            configureButtonAsUnselected(button: button)
        }
        for button in tattooTransformButtons {
            configureButtonAsUnselected(button: button)
        }
        for button in distortionEditModeButtons {
            configureButtonAsUnselected(button: button)
        }
    }
    
    func selectButton(button: UIButton) {
        configureButtonAsSelected(button: button)
    }
    
    
    //Main app mode changed (between tattoo and face distort)
    //Show appropriate menus
    func mainAppModeChanged(to mode: Int) {
        
        switch mode {
        case modeTattoo:
            tattooScrollMenu.isHidden = false
            faceDistortScrollMenu.isHidden = true
            secondaryScrollMenu.isHidden = true
            featuresSlider.isHidden = true
        case modeFaceDistortion:
            tattooScrollMenu.isHidden = true
            faceDistortScrollMenu.isHidden = false
        default:
            print("Default")
        }
    }
    
  
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
        rotateButtonContainer.isHidden = true
        resizeButtonContainer.isHidden = true
        transformPrimaryContainer.isHidden = true
        settingsButton.isHidden = false
    }
    
    func playSnapshotSound() {
        //Play camera shutter sound
        AudioServicesPlaySystemSound(1108)
    }
    
    //Handle UI changes when the user changes the "mode" of the app
    
    func tattooModeChanged(to mode: Mode, _ viewModel: MainUIViewModel) {
        
        resetViewsToDefault()
        
        switch mode {
        case .custom: modeChangedToCustom()
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
    rotateButtonContainer.isHidden = true
    resizeButtonContainer.isHidden = true
    transformPrimaryContainer.isHidden = true
    
    }
    
    func modeChangedToCustom() {
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
        sizePicker.isHidden = true
        acceptSizeButton.isHidden = true
        previewImageContainer.isHidden = true
        tattooTypePicker.reloadAllComponents() //reload picker view to contain position data
    }
    
    func modeChangedToPlace() {
        repositionButtonContainer.isHidden = true
        resizeButtonContainer.isHidden = true
        rotateButtonContainer.isHidden = true
        transformPrimaryContainer.isHidden = true
        sizePicker.isHidden = true
        acceptSizeButton.isHidden = true
        configureEnabledButton(button: shareButton)
        configureDisabledButton(button: addButton)
        configureDisabledButton(button: placeButton)
        settingsButton.isHidden = false
        previewImageContainer.isHidden = true
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

extension ViewController: ARDistortionViewModelViewDelegate{
    
    func toggleFeatureSlider(hidden: Bool) {
        featuresSlider.isHidden = hidden
    }
    
    
    func toggleModeSelectMenu() {
        modeSelectMenu.isHidden = !modeSelectMenu.isHidden
    }
    
    
    func hideModeSelectMenu(){
        modeSelectMenu.isHidden = true
    }
    
    func resetFeaturesSlider() {
        featuresSlider.setValue(1.0, animated: true)
    }
    
    
    func collapseSecondaryMenuIfExpanded() {
        if !secondaryScrollMenu.isHidden {
            secondaryScrollMenu.isHidden = true
            hideAndResetFeaturesSlider()
            distortionViewModel?.resetEditMode()
        }
    }
    
    
    func unselectDistortionEditButtons() {
        for button in distortionEditModeButtons {
            configureButtonAsUnselected(button: button)
        }
    }
    
    
    func unselectPositionButtons() {
        for button in positionButtons {
            configureButtonAsUnselected(button: button)
        }
    }
    
    
    func unselectFeatureButtons() {
        for button in featureButtons {
            configureButtonAsUnselected(button: button)
        }
    }
    
    
    func distortionButtonSelected(button: UIButton) {
        configureButtonAsSelected(button: button)
    }
    
    
    func toggleSecondaryMenu(hidden: Bool) {
        secondaryScrollMenu.isHidden = hidden
    }
    
    func toggleSecondarySizeSubMenu(hidden: Bool) {
        secondarySizeSubMenu.isHidden = hidden
    }
    
    func toggleSecondaryPositionSubMenu(hidden: Bool) {
        secondaryPositionSubMenu.isHidden = hidden
    }

    
}

extension ViewController: RPPreviewViewControllerDelegate{
    
    //Start screen recording with replaykit and set buttons to appropriate icons
    func rpStartRecording() {
        let recorder = RPScreenRecorder.shared()
        recorder.isMicrophoneEnabled = true
        recorder.startRecording(withMicrophoneEnabled: true) { [unowned self] (error) in
            if let unwrappedError = error {
                print(unwrappedError.localizedDescription)
            } else {
                self.mainUIViewModel?.recording = true
                
                DispatchQueue.main.async {
                    self.stopRecordButton.isHidden = false
                    self.hideAllViewsAndButtonsForRecording()
                }
                
                
            }
        }
    }
    
    //Start screen recording with replaykit and set buttons to appropriate icons
    //Show preview window for user to decide to share/save/delete recording
    func rpStopRecording() {
        let recorder = RPScreenRecorder.shared()
        recorder.isMicrophoneEnabled = true
        recorder.stopRecording { [unowned self] (preview, error) in
            if let error = error {
                print("STOP REC ERROR")
                print(error.localizedDescription)
            } else {
                self.mainUIViewModel?.recording = false
                
                DispatchQueue.main.async {
                    self.restoreViewsAfterFinishedRecording()
                }
                
                if let unwrappedPreview = preview {
                    
                    unwrappedPreview.previewControllerDelegate = self
                    self.present(unwrappedPreview, animated: true, completion: nil)
                }
            }
            
        }
    }
    
    //Dismiss preview view controller when user cancels/saves preview
    func previewControllerDidFinish(_ previewController: RPPreviewViewController) {
        previewController.dismiss(animated: true, completion: {})
    }
    
    func hideAllViewsAndButtonsForRecording(){
        hideButtonsForSnapshot()
        hideSecondaryMenu()
        hideTattooSubMenus()
        hideImagePreview()
        resetButton.isHidden = true
        settingsButton.isHidden = true
        scrollMenu.isHidden = true
    }
    
    func restoreViewsAfterFinishedRecording(){
        scrollMenu.isHidden = false
        resetButton.isHidden = false
        settingsButton.isHidden = false
        stopRecordButton.isHidden = true
    }
    
}



