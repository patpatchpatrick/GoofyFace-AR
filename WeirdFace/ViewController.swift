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
    

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var tattooTypePicker: UIPickerView!
    @IBOutlet weak var sceneView: ARSCNView!
    
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
        let model = TattooModel(imageName: "exampletat", tattooType: .lowerLip)
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
    
    
    
    
    @IBAction func plusButtonTapped(_ sender: UIButton) {
        /*
        if tattooHeight < 900.0 {
            tattooWidth += 100.0
            tattooHeight += 100.0
            checkPositions()
              imageChanged = true
        }
 */
        
    }
    
    
    @IBAction func minusButtonTapped(_ sender: UIButton) {
        /*
        if tattooHeight > 200.0 {
            tattooWidth -= 100.0
            tattooHeight -= 100.0
            checkPositions()
              imageChanged = true
        }
 */
    }
    
    
    @IBAction func plusX(_ sender: UIButton) {
        /*
        tattooX += 100.0
        if tattooX > (1000 - tattooWidth) {
            tattooX = 1000 - tattooWidth
        }
        imageChanged = true */
        
    }
    
    
    @IBAction func plusY(_ sender: UIButton) {
        /*
        tattooY += 100.0
        if tattooY > (1000 - tattooHeight) {
            tattooY = 1000 - tattooHeight
        }
        imageChanged = true */
        
    }
    
    
    @IBAction func minusX(_ sender: UIButton) {
        /*
        
        tattooX -= 100.0
        if tattooX < 0 {
            tattooX = 0
        }
         imageChanged = true */
        
    }
    
    @IBAction func minusY(_ sender: UIButton) {
        /*
        tattooY -= 100.0
        if tattooY < 0 {
            tattooY = 0
        }
     imageChanged = true */
        
    }
    
    func checkPositions(){
        /*
        if tattooY > (1000 - tattooHeight) {
            tattooY = 1000 - tattooHeight
            imageChanged = true
        }
        if tattooX > (1000 - tattooWidth) {
            tattooX = 1000 - tattooWidth
            imageChanged = true
        } */
        
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
        return TattooType.allCases.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return TattooType(rawValue: row+1)?.description
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        //If Picker position is changed, update viewModel
        if let type = TattooType(rawValue: row+1) {
            viewModel?.changeTattooType(type: type)
        }
        
    }
    
}

extension ViewController: UITabBarDelegate {
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        //If the "Select Image Button" is tapped, the collection view should appear for the user to select a tattoo image
        if item.tag == 0 {
            collectionView.isHidden = false
        } else {
            collectionView.isHidden = true
        }
        
        if item.tag == 1 {
            viewModel?.displayPositionMap()
            tattooTypePicker.isHidden = false
        } else {
            tattooTypePicker.isHidden = true
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


