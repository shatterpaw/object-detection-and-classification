//
//  ContentView.swift
//  Object Detection and Classification
//
//  Created by Chris Jarvi on 12/9/22.
//

import SwiftUI

struct ContentView: View {
    @StateObject var objectDetectionHelper: ObjectDetectionHelper
    
    init() {
        guard let detectionHelper = ObjectDetectionHelper(modelName: "cereal_model", modelExtension: "tflite") else {
            fatalError("Unable to create object detection helper")
        }
        _objectDetectionHelper = StateObject(wrappedValue: detectionHelper)
    }
    
    var body: some View {
        ZStack {
            HostedViewController()
            OverlayView(objectDetectionHelper: objectDetectionHelper)
        }
        .ignoresSafeArea()
        .environmentObject(objectDetectionHelper)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
