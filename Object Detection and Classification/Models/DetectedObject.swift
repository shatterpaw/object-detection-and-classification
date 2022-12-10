//
//  DetectedObject.swift
//  Object Detection and Classification
//
//  Created by Chris Jarvi on 12/9/22.
//

import Foundation

final class DetectedObject: ObservableObject, CustomStringConvertible, Equatable {
    
    let frame: CGRect
    let label: String
    let confidence: Double
    
    var description: String {
        "frame: \(frame) label: \(label) confidence: \(confidence)"
    }
    
    init(frame: CGRect, label: String, confidence: Double) {
        self.frame = frame
        self.label = label
        self.confidence = confidence
    }
    
    static var empty: DetectedObject {
        return DetectedObject(frame: .zero, label: "", confidence: 0)
    }
    
    static func == (lhs: DetectedObject, rhs: DetectedObject) -> Bool {
        return lhs.frame == rhs.frame && lhs.label == rhs.label
    }
    
}
