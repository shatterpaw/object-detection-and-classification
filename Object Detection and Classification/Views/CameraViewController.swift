//
//  CameraViewController.swift
//  Object Detection and Classification
//
//  Created by Chris Jarvi on 12/9/22.
//

import AVFoundation
import UIKit

final class CameraViewController: UIViewController {
    private var viewModel: ViewModel!
    private var previewLayer: AVCaptureVideoPreviewLayer?
    private var screenRect: CGRect = .zero

    init(objectDetectionHelper: ObjectDetectionHelper) {
        self.viewModel = ViewModel(objectDetectionHelper: objectDetectionHelper)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.requestCameraPermissions()
        
        viewModel.configureCaptureSession { [weak self] captureSession in
            guard let self = self,
                  let captureSession = captureSession else {
                print("Unable to configure preview layer")
                return
            }
            
            self.updateScreenRect()
            self.makePreviewLayer(captureSession)
            self.viewModel.startCapture()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.startCapture()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        viewModel.stopCapture()
    }
    
    override func willTransition(to newCollection: UITraitCollection,
                                 with coordinator: UIViewControllerTransitionCoordinator) {
        updateScreenRect()
        updatePreviewLayer()
        previewLayer?.connection?.videoOrientation = getVideoOrientation()
    }
    
    private func getVideoOrientation() -> AVCaptureVideoOrientation {
        switch UIDevice.current.orientation {
        case .portraitUpsideDown:
            return .portraitUpsideDown
        case .landscapeLeft:
            return .landscapeLeft
        case .landscapeRight:
            return .landscapeRight
        default:
            return .portrait
        }
    }
    
    private func updateScreenRect() {
        screenRect = UIScreen.main.bounds
    }
    
    private func updatePreviewLayer() {
        previewLayer?.frame = CGRect(x: 0, y: 0, width: screenRect.width, height: screenRect.height)
    }
    
    private func makePreviewLayer(_ captureSession: AVCaptureSession) {
        let newPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        newPreviewLayer.frame = CGRect(x: 0,
                                       y: 0,
                                       width: screenRect.width,
                                       height: screenRect.height)
        newPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        newPreviewLayer.connection?.videoOrientation = getVideoOrientation()
        previewLayer = newPreviewLayer
        view.layer.addSublayer(newPreviewLayer)
    }
}
