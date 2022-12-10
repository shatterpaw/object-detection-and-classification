//
//  OverlayView.swift
//  Object Detection and Classification
//
//  Created by Chris Jarvi on 12/9/22.
//

import SwiftUI

struct OverlayView: View {
    @ObservedObject var objectDetectionHelper: ObjectDetectionHelper
    private var frame: CGRect {
        objectDetectionHelper.detectedObject.frame
    }
    
    var body: some View {
        Rectangle()
//            .strokeBorder(.red, lineWidth: 2, style: .init())
            .strokeBorder(.red, lineWidth: 2)
            .background(.clear)
            .frame(width: frame.width, height: frame.height)
            .position(frame.origin)
            .overlay {
                VStack {
                    Text("Label: \(objectDetectionHelper.detectedObject.label)")
                    Text("Confidence: \(String(format: "%0.02f",objectDetectionHelper.detectedObject.confidence))%")
                }
                .font(.system(.title2, weight: .semibold))
            }
    }
}

struct OverlayView_Previews: PreviewProvider {
    static var previews: some View {
        let helper = ObjectDetectionHelper(modelName: "cereal_model", modelExtension: "tflite")!
        OverlayView(objectDetectionHelper: helper)
    }
}
