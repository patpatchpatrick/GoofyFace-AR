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

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        self.viewController = UIStoryboard(name: "Main", bundle:nil).instantiateViewController(withIdentifier: "PrimaryViewController") as! ViewController
        self.viewController?.loadView()
        self.viewController?.viewDidLoad()
        
    }

    override func tearDown() {
        self.viewController = nil
        super.tearDown()
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testSettingAndResettingArImagePosition(){
        
        //Change AR Image (Tattoo) Position to a non-default position (leftBrow)
        viewController?.tattooViewModel?.positionType = .auto
        viewController?.tattooViewModel?.changeTattooType(type: .leftBrow)
        viewController?.tattooViewModel?.acceptPosition()
        
        
        //Ensure positions are no longer default
        XCTAssertFalse(viewController?.tattooViewModel?.x == viewController?.tattooViewModel?.model.defaultXPosition)
        XCTAssertFalse(viewController?.tattooViewModel?.y == viewController?.tattooViewModel?.model.defaultYPosition)
        XCTAssertFalse(viewController?.tattooViewModel?.rotation == viewController?.tattooViewModel?.model.defaultRotation)
        
        //Reset tattoo positions
        viewController?.tattooViewModel?.reset()
        sleep(5) //Wait for async code to run
      
        //Assert that positions are now default
        XCTAssertTrue(viewController?.tattooViewModel?.x == viewController?.tattooViewModel?.model.defaultXPosition)
        XCTAssertTrue(viewController?.tattooViewModel?.y == viewController?.tattooViewModel?.model.defaultYPosition)
        XCTAssertTrue(viewController?.tattooViewModel?.width == viewController?.tattooViewModel?.model.defaultWidth)
        XCTAssertTrue(viewController?.tattooViewModel?.height == viewController?.tattooViewModel?.model.defaultHeight)
        XCTAssertTrue(viewController?.tattooViewModel?.rotation == viewController?.tattooViewModel?.model.defaultRotation)
    
    }
    
    func testPremiumModeAccesInAppPurchase(){
        
        //Test premium mode access
        
        //1.  Set premium mode to false
        viewController?.mainUIViewModel?.model.premiumModePurchased = false
        viewController?.configureViewsForPremiumMode(isPremium:false)
        
        //2.  Verify premium access is unavailable
        XCTAssertTrue(viewController?.drawnImageViewFullScreenButton.imageView?.image == UIImage(named: "iconFullScreenLocked.png"))
        XCTAssertTrue(viewController?.colorPickerButton.imageView?.image == UIImage(named: "iconColorWheelLocked.png"))
        XCTAssertTrue(viewController?.purchasePremiumButton.isEnabled == true)
        XCTAssertTrue(viewController?.watermark.isHidden == false)
        XCTAssertTrue(viewController?.removeWatermarkButton.isHidden  == false)
   
        //3.  Activate premium mode for user
        viewController?.mainUIViewModel?.activatePremiumAccess()
        
        //4.  Verify premium access is available
        XCTAssertTrue(viewController?.drawnImageViewFullScreenButton.imageView?.image == UIImage(named: "iconFullScreen.png"))
        XCTAssertTrue(viewController?.colorPickerButton.imageView?.image == UIImage(named: "iconColorWheel.png"))
        XCTAssertTrue(viewController?.purchasePremiumButton.isEnabled == false)
        XCTAssertTrue(viewController?.watermark.isHidden == true)
        XCTAssertTrue(viewController?.removeWatermarkButton.isHidden  == true)
        
    }
    
    
    

}
