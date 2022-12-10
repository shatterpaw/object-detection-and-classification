//
//  CameraViewControllerViewModel.swift
//  Object Detection and Classification
//
//  Created by Chris Jarvi on 12/9/22.
//

import AVFoundation
import SwiftUI

extension CameraViewController {
    final class ViewModel: NSObject {
        private(set) var cameraPermissionGranted: Bool = false
        private var sessionQueue = DispatchQueue(label: "cameraViewModelSessionQueue")
        private var sampleQueue = DispatchQueue(label: "sampleBufferQueue")
        private(set) var captureSession: AVCaptureSession?
        private(set) var detector: ObjectDetectionHelper
        
        init(objectDetectionHelper: ObjectDetectionHelper) {
            self.detector = objectDetectionHelper
            super.init()
        }
        
        func requestCameraPermissions() {
            if case .authorized = AVCaptureDevice.authorizationStatus(for: .video) {
                cameraPermissionGranted = true
                return
            }
            
            AVCaptureDevice.requestAccess(for: .video) { [weak self] permissionStatus in
                self?.cameraPermissionGranted = permissionStatus
            }
        }
        
        func configureCaptureSession(_ closure: (AVCaptureSession?) -> Void) {
            defer {
                closure(captureSession)
            }
            
            guard let device = AVCaptureDevice.default(.builtInDualWideCamera, for: .video, position: .back),
                  let deviceInput = try? AVCaptureDeviceInput(device: device) else {
                print("Video device input not found")
                return
            }
            
            captureSession = AVCaptureSession()
            guard captureSession?.canAddInput(deviceInput) ?? false else {
                print("Capture session cannot add the specified input")
                return
            }
            captureSession?.addInput(deviceInput)
            
            let dataOutput = AVCaptureVideoDataOutput()
            dataOutput.setSampleBufferDelegate(self, queue: sampleQueue)
            dataOutput.alwaysDiscardsLateVideoFrames = true
            dataOutput.videoSettings = [ String(kCVPixelBufferPixelFormatTypeKey): kCMPixelFormat_32BGRA]
            
            guard captureSession?.canAddOutput(dataOutput) ?? false else {
                print("Capture session cannot add the specified output")
                return
            }
            captureSession?.addOutput(dataOutput)
            dataOutput.connection(with: .video)?.videoOrientation = .portrait
            
            captureSession?.commitConfiguration()
        }
        
        func startCapture() {
            guard !(captureSession?.isRunning ?? true) else { return }
            
            sessionQueue.async { [weak self] in
                self?.captureSession?.startRunning()
            }
        }
        
        func stopCapture() {
            sessionQueue.async { [weak self] in
                self?.captureSession?.stopRunning()
            }
        }
    }
}

extension CameraViewController.ViewModel: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        detector.didOutput(buffer: sampleBuffer)
    }
}
