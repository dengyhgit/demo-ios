//
//  ViewController.swift
//  RequestCancel
//
//  Created by 邓永豪 on 2017/9/27.
//  Copyright © 2017年 dengyonghao. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func loadImage(_ sender: Any) {
        for _ in 0..<10 {
            requestData()
        }
    }

    let url = "http://upload-images.jianshu.io/upload_images/1834458-ee0479ca2cdb4df6.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/2240"
    var cacheTask: Dictionary<String, URLSessionDataTask> = [:]
    private lazy var request: NSMutableURLRequest = {
        let request = NSMutableURLRequest()
        request.timeoutInterval = 30
        request.httpMethod = "GET"
        return request
    }()

    private func requestData() {
        let url = URL(string: self.url)
        request.url = url
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        let session = URLSession.shared
        var dataTask: URLSessionDataTask!

        dataTask = session.dataTask(with: request as URLRequest) { [unowned self] (data, response, error) -> Void in
            if error != nil {
                print(error?.localizedDescription ?? "not exist error info")
            } else {
                print("request success")
            }
            self.cacheTask.removeValue(forKey: self.url)
        }
        if cacheTask.keys.contains(where: { (id) -> Bool in
            id == self.url
        }) {
            let task = cacheTask[self.url]
            task?.cancel()
            print("-------- cancel task ---------")
        }
        cacheTask[self.url] = dataTask
        dataTask.resume()
    }

}

