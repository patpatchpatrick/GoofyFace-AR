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

class ViewController: UIViewController {
    
    var arTrackingSupported = true
    @IBOutlet weak var arNotSupportedTextView: UITextView!
    
    var premiumModePurchased = false // track if premium mode purchased by user
    
    @IBOutlet var mainView: ARSCNView!
    
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var hideButton: UIButton!
    @IBOutlet weak var acceptPositionButton: UIButton!
    
    @IBOutlet weak var transformButtonContainer: UIView!
    @IBOutlet weak var uploadImageBorderedView: BorderedView!
    @IBOutlet weak var uploadedImage: UIImageView!
    @IBOutlet weak var uploadedImageContainer: UIView!
    @IBOutlet weak var drawnImageContainerView: UIView!
    @IBOutlet weak var drawnImageView: DrawnImageView!
    @IBOutlet weak var drawnImageViewFullScreenContainer: UIView!
    @IBOutlet weak var drawnImageViewFullScreen: BorderedDrawnImageView!
    
    @IBOutlet weak var drawnImageDiscardButton: UIButton!
    @IBOutlet weak var drawnImageAcceptButton: UIButton!
    @IBOutlet weak var drawnImageFullScreenAcceptButton: UIButton!
    @IBOutlet weak var drawnImageFullScreenUndoButton: UIButton!
    @IBOutlet weak var colorPickerButton: UIButton!
    @IBOutlet weak var colorPickerFullScreenButton: UIButton!
    @IBOutlet weak var uploadImageDiscardButton: UIButton!
    @IBOutlet weak var uploadImageAcceptButton: UIButton!
    
    @IBOutlet weak var transformHideButton: UIButton!
    
    @IBOutlet weak var transformLeftButton: UIButton!
    @IBOutlet weak var transformRightButton: UIButton!
    
    @IBOutlet weak var transformUpButton: UIButton!
    
    @IBOutlet weak var transformDownButton: UIButton!
    
    @IBOutlet weak var transformRotateCWButton: UIButton!
    
    @IBOutlet weak var transformRotateCCWButton: UIButton!
    
    @IBOutlet weak var transformMinusButton: UIButton!
    
    @IBOutlet weak var transformPlusButton: UIButton!
    
    @IBOutlet weak var transformPositionAcceptButton: UIButton!
    @IBOutlet weak var colorPicker: HSBColorPicker!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var tattooTypePicker: UIPickerView!
    @IBOutlet weak var sceneView: ARSCNView!
    var imagePicker = UIImagePickerController()
    
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
    var viewModel: TattooViewModel?

    
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
 
        
        collectionView.delegate = self
        collectionView.dataSource = self
        tabBar.delegate = self
        tattooTypePicker.delegate = self
        tattooTypePicker.dataSource = self
        sceneView.delegate = self
        colorPicker.delegate = self
        
        let model = TattooModel(imageName: "blank", tattooType: .new)
        viewModel = TattooViewModel(tattooModel: model)
        viewModel?.loadImage()
        
        configureButtons()
        rotateFullScreenImages()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updated_data),
                                               name:Notification.Name("UPDATED_DATA"),
                                               object: nil)
        if arTrackingSupported {
        let configuration = ARFaceTrackingConfiguration()
            sceneView.session.run(configuration)}
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.removeObserver(self)
        if arTrackingSupported{
                sceneView.session.pause()
        }
    }
    
    @objc func updated_data(notification:Notification) -> Void{
        
        imageChanged = true
        
    }
    
    
    @IBAction func canvasDrawingAccepted(_ sender: UIButton) {
        
        //Update the tattoo image to be the user's drawing
        drawnImageView.layer.backgroundColor = UIColor.clear.cgColor
        drawnImageView.layer.borderWidth = 0.0
        let userDrawing = drawnImageView.screenShot
        viewModel?.changeImage(image: userDrawing!)
        drawnImageContainerView.isHidden = true
        positionTab.isEnabled = true
        
    }
    
    
    @IBAction func canvasDrawingDiscarded(_ sender: UIButton) {
        
        drawnImageContainerView.isHidden = true
        drawnImageView.clear()
        
    }
    
    
    @IBAction func uploadedImageAccepted(_ sender: UIButton) {
        guard let image = uploadedImage.image else {return}
        uploadImageBorderedView.layer.borderWidth = 0.0
        guard let uploadedImage = uploadImageBorderedView.screenShot else {return}
        
        viewModel?.changeImage(image: uploadedImage)
        uploadedImageContainer.isHidden = true
        positionTab.isEnabled = true
    }
    
    
    @IBAction func uploadedImageDiscarded(_ sender: UIButton) {
        uploadedImageContainer.isHidden = true
    }
    
    @IBAction func imageResizedByPinch(_ sender: UIPinchGestureRecognizer) {
        //User uploaded image can be resized by pinch
        uploadedImage.transform = CGAffineTransform(scaleX: sender.scale, y: sender.scale)
        
    }
    
    
    
    @IBAction func rotateClockwise(_ sender: UIButton) {
        
        viewModel?.rotate(clockwise: true)
        
    }
    
    
    @IBAction func rotateCounterClock(_ sender: UIButton) {
        
        viewModel?.rotate(clockwise: false)
    }
    
    
    @IBAction func plusX(_ sender: UIButton) {
        

        viewModel?.incrementX()
    }
    
    
    @IBAction func plusY(_ sender: UIButton) {
        viewModel?.decrementY()
        
    }
    
    
    @IBAction func minusX(_ sender: UIButton) {
        viewModel?.decrementX()
        
    }
    
    @IBAction func minusY(_ sender: UIButton) {
        
        viewModel?.incrementY()
        
    }
    
    
    @IBAction func sizeDecrease(_ sender: UIButton) {
        
        //Decrease tattoo size while keeping 2x1 proportions
        viewModel?.decrementSize()
    }
    
    
    @IBAction func sizeIncrease(_ sender: UIButton) {
         //Increase tattoo size while keeping 2x1 proportions
        viewModel?.incrementSize()
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
    
    
    @IBAction func acceptPosition(_ sender: UIButton) {
        
        //If tattoo auto position is accepted, tattoo manual transformation box is displayed for user to adjust the tattoo
        
        viewModel?.acceptPosition()
        tattooTypePicker.isHidden = true
        viewModel?.positionType = .manual
        transformButtonContainer.isHidden = false
        hideButton.isHidden = false
        acceptPositionButton.isHidden = true
        addTatTab.isEnabled = true
        
    }
    
    
    @IBAction func resetButtonTapped(_ sender: UIButton) {
        
        //Reset the screen and remove all tattoos
        
        viewModel?.reset()
        transformButtonContainer.isHidden = true
        hideButton.isHidden = true
        positionTab.isEnabled = false
        addTatTab.isEnabled = false
        shareTab.isEnabled = false
    }
    
    @IBAction func hideButtonTapped(_ sender: UIButton) {
        
        //Hide/Show the transform buttons
        transformButtonContainer.isHidden = !transformButtonContainer.isHidden
    }
    
    
    @IBAction func drawnImageFullScreenButtonTapped(_ sender: UIButton) {
        
        drawnImageViewFullScreenContainer.isHidden = false
        drawnImageContainerView.isHidden = true
        
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
        viewModel?.changeImage(image: userDrawing!)
        drawnImageViewFullScreenContainer.isHidden = true
        positionTab.isEnabled = true
    }
    
    @IBAction func drawnImageColorWheelTapped(_ sender: UIButton) {
        colorPicker.isHidden = false
        
    }
    
    
    @IBAction func drawnImageFullScreenColorWheelTapped(_ sender: UIButton) {
        colorPicker.isHidden = false
    }
    
    
    @IBAction func drawnImageFullScreenUndoTapped(_ sender: UIButton) {
        drawnImageViewFullScreen.undo()
        
    }
    
    func shareImage(image: UIImage){
        
        let objectsToShare: [AnyObject] = [ image ]
        let activityViewController = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        
       // activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        
        
        self.present(activityViewController, animated: true, completion: nil)
        
    }
    
}

extension ViewController: ARSCNViewDelegate {
    
    
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        
        //New node added to AR renderer
        if !arTrackingSupported {return nil}
        
        guard let sceneView = renderer as? ARSCNView,
            anchor is ARFaceAnchor else { return nil }
        
       /*
        #if targetEnvironment(simulator)
        #error("ARKit is not supported in iOS Simulator. Connect a physical iOS device and select it as your Xcode run destination, or select Generic iOS Device as a build-only destination.")
        #else
 */
 
 
 
        let faceGeometry = ARSCNFaceGeometry(device: sceneView.device!)!
        let material = faceGeometry.firstMaterial!
        
        
        //If the image was changed, set the new image on the face contents
        if imageChanged {
            material.diffuse.contents = viewModel?.image
            material.lightingModel = .physicallyBased
            imageChanged = false
        }
 
        
     //   #endif
 
       return SCNNode(geometry: faceGeometry)
       // return SCNNode(geometry: nil)
        
        
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
            material.diffuse.contents = viewModel?.image// Example texture map image.
            material.lightingModel = .physicallyBased
            imageChanged = false
        }

        
        faceGeometry.update(from: faceAnchor.geometry)
 
    }
 
 
 
 
 
    
}

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        print("PICKER COUNT", TattooType.allCases.count)
        //Display all tattoo types except for the last one (which is the default type and shouldn't be selectable)
        return TattooType.allCases.count - 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return TattooType(rawValue: row+1)?.description
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        //If Picker position is changed, update viewModel
        //If a new position is chose, the image must be repositioned
        if let type = TattooType(rawValue: row+1) {
            viewModel?.positionType = .auto
            viewModel?.changeTattooType(type: type)
            acceptPositionButton.isHidden = false
            
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
        title.text = TattooType(rawValue: row+1)?.description
        title.textAlignment = .center
        
        return title
    }
    
}

extension ViewController: UITabBarDelegate {
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        
        viewMode = item.tag
        
        //"Select mode" - user can select custom tattooo
        if item.tag == modeSelect {
            collectionView.isHidden = false
            resetButton.isHidden = true
        } else {
            collectionView.isHidden = true
            resetButton.isHidden = false
        }
        
        //"Draw mode" - user can draw their own tattoo
        if item.tag == modeDraw {
            resetDrawView()
            drawnImageContainerView.isHidden = false
        } else {
            drawnImageContainerView.isHidden = true
        }
        
        //"Upload mode" - user can upload their own tattoo
        if item.tag == modeUpload {
            resetUploadView()
            uploadedImageContainer.isHidden = false
            selectUploadPicture()
        } else {
            uploadedImageContainer.isHidden = true
        }
        
        //"Position mode" - User can position/transform the tattoo
        if item.tag == modePosition {
            viewModel?.positionType = .auto
            viewModel?.displayPositionMap()
            tattooTypePicker.isHidden = false
        } else {
            tattooTypePicker.isHidden = true
            acceptPositionButton.isHidden = true
            hideButton.isHidden = true
            transformButtonContainer.isHidden = true
        }
        
        //"Place Mode" - User can place the tattoo and commit the changes (i.e. commit the tattoo to the user's face)
        if item.tag == modePlace {
            viewModel?.commitTattoo()
            transformButtonContainer.isHidden = true
            hideButton.isHidden = true
            shareTab.isEnabled = true
            addTatTab.isEnabled = false
            positionTab.isEnabled = false
        }
        
        //"Share Mode" - Save image to user's gallery or share via any other apps
        if item.tag == modeShare {
            transformButtonContainer.isHidden = true
            hideButton.isHidden = true
            let selectedImage = sceneView.snapshot()
            AudioServicesPlaySystemSound(1108) //Play camera shutter sound
            shareImage(image: selectedImage)
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
    
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tattooImagesCount
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
        viewModel?.changeImage(named: imageName)
        collectionView.isHidden = true
        resetButton.isHidden = false
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


