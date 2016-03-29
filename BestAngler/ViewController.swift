//
//  ViewController.swift
//  BestAngler
//
//  Created by 澤井聖也 on 2016/03/25.
//  Copyright © 2016年 澤井聖也. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController,UIImagePickerControllerDelegate ,UINavigationControllerDelegate{
    
    @IBOutlet weak var imageView: UIImageView!
    var myMotionManager: CMMotionManager!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cameraButton(sender: AnyObject) {
        setUpCamera()
    }
    
    private func setUpCamera(){
        let sourceType:UIImagePickerControllerSourceType = UIImagePickerControllerSourceType.Camera
        // カメラが利用可能かチェック
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera){
            // インスタンスの作成
            let cameraPicker = UIImagePickerController()
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            self.presentViewController(cameraPicker, animated: true, completion: nil)
        }else{
             print("error")
        }
    }
    
    func imagePickerController(imagePicker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.contentMode = .ScaleAspectFit
            // MotionManager設定.
            myMotionManager = CMMotionManager()
            myMotionManager.accelerometerUpdateInterval = 0.1
            myMotionManager.accelerometerData
            
            // 加速度の取得を開始.
            myMotionManager.startAccelerometerUpdatesToQueue(NSOperationQueue.mainQueue(), withHandler: { data, error in
                let returnPic = Image(image: pickedImage, x: data!.acceleration.x, y: data!.acceleration.y, z: data!.acceleration.z)
                self.imageView.image = returnPic.image
                self.myMotionManager.stopAccelerometerUpdates()
                
                print("x=\(data!.acceleration.x * 180 / M_PI),y=\(data!.acceleration.y * 180 / M_PI):z=\(data!.acceleration.z * 180 / M_PI)")
            })
        }
        //閉じる処理
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        print("Tap the [Save] to save a picture")
    }
    
    //撮影がキャンセルされた時に呼び出される
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }

}
