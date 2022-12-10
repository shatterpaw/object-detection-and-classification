//
//  CameraViewControllerViewModelTests.swift
//  Object Detection and ClassificationTests
//
//  Created by Chris Jarvi on 12/9/22.
//

import AVFoundation
@testable import Object_Detection_and_Classification
import XCTest

final class CameraViewControllerViewModelTests: XCTestCase {
    var viewModel: CameraViewController.ViewModel!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        let objectDetectionHelper = try XCTUnwrap(ObjectDetectionHelper(modelName: "cereal_model", modelExtension: "tflite"))
        viewModel = CameraViewController.ViewModel(objectDetectionHelper: objectDetectionHelper)
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
        try super.tearDownWithError()
    }
    
    #if !targetEnvironment(simulator)
    func testConfigureCaptureSessionIsNotNil() throws {
        let expectation = expectation(description: "configure capture session closure expectation")
        let closure = { (captureSession: AVCaptureSession?) -> Void in
            XCTAssertNotNil(captureSession)
            expectation.fulfill()
        }
        
        viewModel.configureCaptureSession(closure)
        
        waitForExpectations(timeout: 5.0)
    }
    
    func testConfigureCaptureSessionHasOneInputAndOneOutput() throws {
        let expectation = expectation(description: "configure capture session closure expectation")
        let closure = { (captureSession: AVCaptureSession?) -> Void in
            XCTAssertEqual(captureSession?.inputs.count, 1)
            XCTAssertEqual(captureSession?.outputs.count, 1)
            expectation.fulfill()
        }
        
        viewModel.configureCaptureSession(closure)
        
        waitForExpectations(timeout: 5.0)
    }
    #endif
}
