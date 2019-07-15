//
//  WeirdFaceTests.swift
//  WeirdFaceTests
//
//  Created by Patrick Doyle on 6/26/19.
//  Copyright © 2019 Patrick Doyle. All rights reserved.
//

import XCTest
import CoreData
@testable import WeirdFace

class WeirdFaceTests: XCTestCase {
    
    var viewController: ViewController?
    var tattooModel: ARModel?
    var tattooViewModel: ARViewModel?
    var mainUIModel: MainUIModel?
    var mainUIViewModel: MainUIViewModel?

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        self.viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PrimaryViewController") as! ViewController
        
        self.tattooModel = ARModel(imageName: "blank", tattooType: .new)
        self.tattooViewModel = ARViewModel(tattooModel: tattooModel!, delegate: viewController!)
        
        self.mainUIModel = MainUIModel()
        self.mainUIViewModel = MainUIViewModel(model: mainUIModel!, delegate: viewController!)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testSettingAndResettingArImagePosition(){
        
        //Change AR Image (Tattoo) Position to a non-default position (leftBrow)
        tattooViewModel?.positionType = .auto
        tattooViewModel?.changeTattooType(type: .leftBrow)
        setModelPositionsOnViewModel()
        
        //Ensure positions are no longer default
        XCTAssertFalse(tattooViewModel?.x == tattooViewModel?.model.defaultXPosition)
        XCTAssertFalse(tattooViewModel?.y == tattooViewModel?.model.defaultYPosition)
        XCTAssertFalse(tattooViewModel?.rotation == tattooViewModel?.model.defaultRotation)
        
        //Reset tattoo positions
       tattooViewModel?.reset()
        sleep(5) //Wait for async code to run
      
        //Assert that positions are now default
        XCTAssertTrue(tattooViewModel?.x == tattooViewModel?.model.defaultXPosition)
        XCTAssertTrue(tattooViewModel?.y == tattooViewModel?.model.defaultYPosition)
        XCTAssertTrue(tattooViewModel?.width == tattooViewModel?.model.defaultWidth)
        XCTAssertTrue(tattooViewModel?.height == tattooViewModel?.model.defaultHeight)
        XCTAssertTrue(tattooViewModel?.rotation == tattooViewModel?.model.defaultRotation)
    
    }
    
    func setModelPositionsOnViewModel(){
        //Test method to set model tattoo positions on the view model
        tattooViewModel?.x = (tattooViewModel?.model.x)!
        tattooViewModel?.y = (tattooViewModel?.model.y)!
        tattooViewModel?.width = (tattooViewModel?.model.width)!
        tattooViewModel?.height = (tattooViewModel?.model.height)!
        tattooViewModel?.rotation = (tattooViewModel?.model.rotation)!
     
    }

}
