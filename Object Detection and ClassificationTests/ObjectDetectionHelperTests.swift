//
//  ObjectDetectionHelperTests.swift
//  Object Detection and ClassificationTests
//
//  Created by Chris Jarvi on 12/9/22.
//

@testable import Object_Detection_and_Classification
import XCTest

final class ObjectDetectionHelperTests: XCTestCase {
    var helper: ObjectDetectionHelper!

    override func setUpWithError() throws {
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        helper = nil
        try super.tearDownWithError()
    }

    func testInitWithInvalidModelFileReturnsNil() throws {
        helper = .init(modelName: "", modelExtension: "")
        XCTAssertNil(helper)
    }

    func testInitWithValidModelSucceeds() throws {
        helper = .init(modelName: "cereal_model", modelExtension: "tflite")
        XCTAssertNotNil(helper)
    }
}
