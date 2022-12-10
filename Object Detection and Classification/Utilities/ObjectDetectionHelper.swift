//
//  ObjectDetectionHelper.swift
//  Object Detection and Classification
//
//  Created by Chris Jarvi on 12/9/22.
//

import AVFoundation
import MLKit
import MLKitObjectDetectionCustom
import SwiftUI

final class ObjectDetectionHelper: ObservableObject {
    @Published var detectedObject: DetectedObject = DetectedObject.empty
    private var detector: ObjectDetector
    private let confidenceThreshold = 0.5
    
    init?(modelName: String, modelExtension: String) {
        guard let modelPath = Bundle.main.path(forResource: modelName, ofType: modelExtension) else {
            print("Model '\(modelName).\(modelExtension)' not found")
            return nil
        }
        
        let localModel = LocalModel(path: modelPath)
        let options = CustomObjectDetectorOptions(localModel: localModel)
        options.detectorMode = .stream
        options.shouldEnableClassification = true
        options.shouldEnableMultipleObjects = false
        options.classificationConfidenceThreshold = NSNumber(value: confidenceThreshold)
        
        self.detector = ObjectDetector.objectDetector(options: options)
    }
    
    func didOutput(buffer: CMSampleBuffer) {
        let image = VisionImage(buffer: buffer)
        image.orientation = imageOrientation(deviceOrientation: UIDevice.current.orientation, cameraPosition: .front)
        detector.process(image) { [weak self] objects, error in
            guard let self = self else { return }
            if let error = error {
                print("Error processing image. Error: \(error)")
                return
            }
            guard let firstObject = objects?.first else { return }
            let label = firstObject.labels.compactMap { $0.text }.joined(separator: "; ")
            let confidence = Double(firstObject.labels.first?.confidence ?? 0.0)
            
            // TODO: The frame returned by MLKit appears to be off.  Would need investigating
            if confidence >= self.confidenceThreshold {
                self.detectedObject = DetectedObject(frame: firstObject.frame, label: label, confidence: confidence)
            } else {
                self.detectedObject = DetectedObject.empty
            }
        }
    }
    
    private func imageOrientation(deviceOrientation: UIDeviceOrientation, cameraPosition: AVCaptureDevice.Position) -> UIImage.Orientation {
        switch deviceOrientation {
        case .portrait:
            return cameraPosition == .front ? .leftMirrored : .right
        case .landscapeLeft:
            return cameraPosition == .front ? .downMirrored : .up
        case .portraitUpsideDown:
            return cameraPosition == .front ? .rightMirrored : .left
        case .landscapeRight:
            return cameraPosition == .front ? .upMirrored : .down
        default:
            return .up
        }
    }
}
