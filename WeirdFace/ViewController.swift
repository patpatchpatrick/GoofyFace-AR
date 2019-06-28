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
    
    @IBOutlet var mainView: ARSCNView!
    
    @IBOutlet weak var acceptPositionButton: UIButton!
    
    @IBOutlet weak var transformButtonContainer: UIView!
    @IBOutlet weak var uploadImageBorderedView: BorderedView!
    @IBOutlet weak var uploadedImage: UIImageView!
    @IBOutlet weak var uploadedImageContainer: UIView!
    @IBOutlet weak var drawnImageContainerView: UIView!
    @IBOutlet weak var drawnImageView: DrawnImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var tattooTypePicker: UIPickerView!
    @IBOutlet weak var sceneView: ARSCNView!
     var imagePicker = UIImagePickerController()
    
    let modeSelect = 0
    let modeDraw = 1
    let modeUpload = 2
    let modePosition = 3
    let modePlace = 4
    
    var viewMode:Int = 0
    
    var imageChanged = false
    var viewModel: TattooViewModel?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard ARFaceTrackingConfiguration.isSupported else {
            fatalError("Face tracking is not supported on this device")
        }
        
        collectionView.delegate = self
        collectionView.dataSource = self
        tabBar.delegate = self
        tattooTypePicker.delegate = self
        tattooTypePicker.dataSource = self
        let model = TattooModel(imageName: "blank", tattooType: .new)
        viewModel = TattooViewModel(tattooModel: model)
        viewModel?.loadImage()
        
        sceneView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updated_data),
                                               name:Notification.Name("UPDATED_DATA"),
                                               object: nil)
        let configuration = ARFaceTrackingConfiguration()
        
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.removeObserver(self)
        sceneView.session.pause()
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
    }
    
    
    @IBAction func uploadedImageDiscarded(_ sender: UIButton) {
        uploadedImageContainer.isHidden = true
    }
    
    @IBAction func imageResizedByPinch(_ sender: UIPinchGestureRecognizer) {
        
        uploadedImage.transform = CGAffineTransform(scaleX: sender.scale, y: sender.scale)
        
    }
    
    
    
    @IBAction func rotateClockwise(_ sender: UIButton) {
        viewModel?.rotation -= 0.1
        
        viewModel?.loadImage()
        
    }
    
    
    @IBAction func rotateCounterClock(_ sender: UIButton) {
        viewModel?.rotation += 0.1
        
        viewModel?.loadImage()
    }
    
    
    @IBAction func plusX(_ sender: UIButton) {
        viewModel?.x += 10.0
        
        viewModel?.loadImage()
        
    }
    
    
    @IBAction func plusY(_ sender: UIButton) {
        viewModel?.y -= 10.0
        
        viewModel?.loadImage()
        
    }
    
    
    @IBAction func minusX(_ sender: UIButton) {
        viewModel?.x -= 10.0
        
        viewModel?.loadImage()
        
    }
    
    @IBAction func minusY(_ sender: UIButton) {
        
        viewModel?.y += 10.0

     viewModel?.loadImage()
        
    }
    
    
    @IBAction func viewPanned(_ sender: UIPanGestureRecognizer) {
        
        if viewMode == modePosition {
            let vel = sender.velocity(in: self.mainView)
            if vel.x > 0 {
                // user dragged towards the right
                print("right")
            }
            else if vel.x < 0 {
                // user dragged towards the left
                print("left")
            }
            
            if vel.y > 0 {
                // user dragged towards the down
                print("down")
            }
            else if vel.y < 0 {
                print("up")
            }
            
            
        }
    }
    
    func resetDrawView(){
        drawnImageView.layer.backgroundColor = UIColor.white.cgColor
        drawnImageView.layer.borderWidth = 2.0
    }
    
    func resetUploadView(){
        uploadImageBorderedView.layer.borderWidth = 2.0
    }
    
    
    @IBAction func acceptPosition(_ sender: UIButton) {
        
        //If tattoo auto position is accepted, tattoo manual box is displayed for user to adjust the tattoo
        
        viewModel?.acceptPosition()
        tattooTypePicker.isHidden = true
        viewModel?.positionType = .manual
        transformButtonContainer.isHidden = false
        acceptPositionButton.isHidden = true
        
    }
    
    
}

extension ViewController: ARSCNViewDelegate {
    // 2
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        
        guard let sceneView = renderer as? ARSCNView,
            anchor is ARFaceAnchor else { return nil }
        
        #if targetEnvironment(simulator)
        #error("ARKit is not supported in iOS Simulator. Connect a physical iOS device and select it as your Xcode run destination, or select Generic iOS Device as a build-only destination.")
        #else
        let faceGeometry = ARSCNFaceGeometry(device: sceneView.device!)!
        let material = faceGeometry.firstMaterial!
        
        if imageChanged {
            material.diffuse.contents = viewModel?.image// Example texture map image.
            material.lightingModel = .physicallyBased
            imageChanged = false
        }
        
        #endif
        return SCNNode(geometry: faceGeometry)
        
        
    }
    
    func renderer(
        _ renderer: SCNSceneRenderer,
        didUpdate node: SCNNode,
        for anchor: ARAnchor) {

        guard let faceGeometry = node.geometry as? ARSCNFaceGeometry,
            let faceAnchor = anchor as? ARFaceAnchor
            else { return }
        
        
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
        if let type = TattooType(rawValue: row+1) {
            viewModel?.positionType = .auto
            viewModel?.changeTattooType(type: type)
            
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let string = TattooType(rawValue: row+1)?.description
        return NSAttributedString(string: string!, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }
    
}

extension ViewController: UITabBarDelegate {
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        //If the "Select Image Button" is tapped, the collection view should appear for the user to select a tattoo image
        viewMode = item.tag
        if item.tag == modeSelect {
            collectionView.isHidden = false
        } else {
            collectionView.isHidden = true
        }
        
        if item.tag == modeDraw {
            resetDrawView()
            drawnImageContainerView.isHidden = false
        } else {
            drawnImageContainerView.isHidden = true
        }
        
        if item.tag == modeUpload {
            resetUploadView()
            uploadedImageContainer.isHidden = false
            selectUploadPicture()
        } else {
            uploadedImageContainer.isHidden = true
        }
        
        if item.tag == modePosition {
            viewModel?.positionType = .auto
            viewModel?.displayPositionMap()
            tattooTypePicker.isHidden = false
            acceptPositionButton.isHidden = false
        } else {
            tattooTypePicker.isHidden = true
            acceptPositionButton.isHidden = true
        }
        
        if item.tag == modePlace {
            //If the "Add Tattoo" button is clicked, commit the tattoo to the canvas (i.e. the user's face)
            viewModel?.commitTattoo()
            transformButtonContainer.isHidden = true
        }
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
    }
    
    
    
    
}

extension ViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    
    func selectUploadPicture(){
        
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            print("Button capture")
            
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false
            
            present(imagePicker, animated: true, completion: nil)
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        guard let image = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        //let size = CGSize(width: 200, height: 200)
        //let croppedImage = image.crop(to: size)
        uploadedImage.image = image
        
    }
    
}


