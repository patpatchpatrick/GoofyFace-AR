//
//  WeirdFaceUITests.swift
//  WeirdFaceUITests
//
//  Created by Patrick Doyle on 6/26/19.
//  Copyright © 2019 Patrick Doyle. All rights reserved.
//

import XCTest

class WeirdFaceUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testDrawTattooMode(){
        
        //Ensure all of the correct views appear when draw mode is accessed
        
        let app = XCUIApplication()
        let drawTattooButton = app.buttons["Draw Tattoo"]
        self.expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: drawTattooButton, handler: nil)
        self.waitForExpectations(timeout: 30, handler: nil)
        drawTattooButton.tap()
        XCTAssertTrue( app.buttons["iconFullScreen"].exists)
        XCTAssertTrue( app.buttons["iconColorWheel"].exists)
        XCTAssertTrue( app.buttons["iconDiscard"].exists)
        XCTAssertTrue( app.buttons["iconCheckMark"].exists)
        XCTAssertTrue( app.buttons["iconReset"].exists)
        
        
    }
    
    func testUploadTattooMode(){
        
        //Ensure all of the correct views appear when upload mode is accessed
        
        let app = XCUIApplication()
        let uploadTattooButton = app.buttons["Upload Tattoo"]
        self.expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: uploadTattooButton, handler: nil)
        self.waitForExpectations(timeout: 30, handler: nil)
        uploadTattooButton.tap()
        let cancelButton = app.navigationBars["Photos"].buttons["Cancel"]
        cancelButton.tap()
        XCTAssertTrue( app.buttons["iconDiscard"].exists)
        XCTAssertTrue( app.buttons["iconCheckMark"].exists)
        XCTAssertTrue( app.buttons["iconReset"].exists)
        
        
        
        
    }
    
    func testThatButtonsAreEnabledInProperOrder(){
        
        //Test to ensure buttons are enabled in the proper order
        // 1. Select/Draw/Upload Image -> Place Button Enabled
        // 2. Place Image -> Position Buttons Enabled ("Tested using Hide Button")
        // 3. Image placed -> Add Button Enabled
        // 4. Add Image -> process restarts
        
        
        let app = XCUIApplication()
        let selectButton = app.buttons["Select Tattoo"]
        let drawButton = app.buttons["Draw Tattoo"]
        let uploadButton = app.buttons["Upload Tattoo"]
        let placeButton = app.buttons["Place Tattoo"]
        let addButton = app.buttons["Add Tattoo"]
        let shareButton = app.buttons["Share Image"]
        self.expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: drawButton, handler: nil)
        self.waitForExpectations(timeout: 30, handler: nil)
        
        //Ensure correct buttons enabled/disabled by default
        XCTAssertTrue( selectButton.isEnabled)
        XCTAssertTrue( drawButton.isEnabled)
        XCTAssertTrue( uploadButton.isEnabled)
        placeButton.tap()
        XCTAssertFalse( app.pickerWheels["2"].exists) //Pickerwheel only shows if place button can be tapped
        shareButton.tap()
        XCTAssertFalse( app.buttons["Cancel"].exists) //Cancel button only shows if share button can be tapped
        
        //Tattoo drawn, place button should be enabled
        drawButton.tap()
        let iconcheckmarkButton = app.buttons["iconCheckMark"]
        iconcheckmarkButton.tap()
        XCTAssertTrue( placeButton.isEnabled)
        
        //Place tattoo, position buttons "i.e. hide button" should appear and add button should be enabled
        placeButton.tap()
        app.pickerWheels.element.adjust(toPickerWheelValue: "2")
        iconcheckmarkButton.tap()
        XCTAssertTrue( app.buttons["iconHide"].exists)
        XCTAssertTrue( addButton.isEnabled)
        app.buttons["iconHide"].tap()
        app.buttons["Add Tattoo"].tap()
        
        //Add button tapped, share button should be enabled
        XCTAssertTrue( shareButton.isEnabled)
        app.buttons["Share Image"].tap()
        app.buttons["Cancel"].tap()
        
        //Restart the process, and ensure it works a second time
        //When process restarts, buttons should be back to default state
        
        //Ensure buttons are in default state
        XCTAssertTrue( selectButton.isEnabled)
        XCTAssertTrue( drawButton.isEnabled)
        XCTAssertTrue( uploadButton.isEnabled)
        placeButton.tap()
        XCTAssertFalse( app.pickerWheels["2"].exists) //Pickerwheel only shows if place button can be tapped
        
        //Tattoo drawn, place button should be enabled
        drawButton.tap()
        iconcheckmarkButton.tap()
        XCTAssertTrue( placeButton.isEnabled)
        
        //Place tattoo, ensure add button is enabled
        placeButton.tap()
        app.pickerWheels.element.adjust(toPickerWheelValue: "4")
        iconcheckmarkButton.tap()
        XCTAssertTrue( app.buttons["iconHide"].exists)
        XCTAssertTrue( addButton.isEnabled)
        app.buttons["iconHide"].tap()
        app.buttons["Add Tattoo"].tap()
        
        //Add button tapped, share button should be enabled
        XCTAssertTrue( shareButton.isEnabled)
        app.buttons["Share Image"].tap()
        app.buttons["Cancel"].tap()
        
    }


}
