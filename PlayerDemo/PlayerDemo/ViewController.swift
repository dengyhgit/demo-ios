//
//  ViewController.swift
//  PlayerDemo
//
//  Created by deng on 2017/3/11.
//  Copyright © 2017年 dengyonghao. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import MobileCoreServices

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private lazy var picker: UIImagePickerController = {
        var picker = UIImagePickerController()
        picker.mediaTypes = [kUTTypeMovie as String]
        picker.sourceType = .camera
        picker.cameraCaptureMode = .video
        picker.delegate = self
        return picker
    }()
    private lazy var playVC: AVPlayerViewController = AVPlayerViewController()
    private var videoUrl: URL?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func playVideo(_ sender: AnyObject) {
        
        if videoUrl != nil {
            let player = AVPlayer(url: videoUrl!)
            playVC.player = player
            present(playVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func recordVideo(_ sender: AnyObject) {
        present(picker, animated: true, completion: nil)
    }
    
    // MARK: - UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        videoUrl = info[UIImagePickerControllerMediaURL] as! URL?
        picker.dismiss(animated: true, completion: nil)
    }
}

