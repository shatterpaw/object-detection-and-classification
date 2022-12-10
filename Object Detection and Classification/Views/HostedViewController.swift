//
//  HostedViewController.swift
//  Object Detection and Classification
//
//  Created by Chris Jarvi on 12/9/22.
//

import SwiftUI

struct HostedViewController: UIViewControllerRepresentable {
    @EnvironmentObject var objectDetectionHelper: ObjectDetectionHelper
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        CameraViewController(objectDetectionHelper: objectDetectionHelper)
    }
}
