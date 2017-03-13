//
//  ViewController.swift
//  YHQRC
//
//  Created by deng on 2017/3/13.
//  Copyright © 2017年 dengyonghao. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        previewLayer.frame = view.frame
        view.layer.addSublayer(previewLayer)
        session.startRunning()
        view.addSubview(qrCodeFrameView)
        view.bringSubview(toFront: qrCodeFrameView)
    }
    
    fileprivate lazy var qrCodeFrameView: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.blue.cgColor
        view.layer.borderWidth = 2
        return view
    }()
    private lazy var session: AVCaptureSession = {
        var session = AVCaptureSession()
        var device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        var input: AVCaptureDeviceInput?
        do {
            input = try AVCaptureDeviceInput(device: device)
        } catch {
            print(error)
        }
        if input != nil {
            session.addInput(input)
        }
        
        var output = AVCaptureMetadataOutput()
        session.addOutput(output)
        output.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        
        return session
    }()
    fileprivate lazy var previewLayer: AVCaptureVideoPreviewLayer = {
        var previewLayer = AVCaptureVideoPreviewLayer(session: self.session)
        return previewLayer!
    }()
}

// MARK: - AVCaptureMetadataOutputObjectsDelegate
extension ViewController: AVCaptureMetadataOutputObjectsDelegate {
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        qrCodeFrameView.frame = .zero
        for metadataObject in metadataObjects {
            guard let object = metadataObject as? AVMetadataMachineReadableCodeObject else {
                return
            }
            if object.type == AVMetadataObjectTypeQRCode {
                guard let url = URL(string: object.stringValue) else {
                    return
                }
                let barCodeObject = previewLayer.transformedMetadataObject(for: object)
                qrCodeFrameView.frame = barCodeObject!.bounds
                UIApplication.shared.openURL(url)
            }
        }
    }
}

