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
    @IBOutlet weak var checkView: UIView!

    var count: Int! = 0
    var myMotionManager: CMMotionManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        checkView.layer.cornerRadius = self.checkView.layer.bounds.width/2
        checkView.clipsToBounds = true

    
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
    //写真が保存された時
    func imagePickerController(imagePicker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.contentMode = .ScaleAspectFit
            //imageView.image = pickedImage
            //ジャイロ
            // MotionManagerを生成.
            myMotionManager = CMMotionManager()
            
            // 更新周期を設定.
            myMotionManager.accelerometerUpdateInterval = 0.1
            
            myMotionManager.accelerometerData
            
            // 加速度の取得を開始.
            myMotionManager.startAccelerometerUpdatesToQueue(NSOperationQueue.mainQueue(), withHandler: { data, error in
                
                let returnPic = Image(image: pickedImage, x: data!.acceleration.x, y: data!.acceleration.y, z: data!.acceleration.z)
                self.imageView.image = returnPic.image
                self.myMotionManager.stopAccelerometerUpdates()
                self.setUpLayout((data?.acceleration.x)!, y: (data?.acceleration.y)! , z: (data?.acceleration.z)!)
    
                print("x=\(round(data!.acceleration.x * 180 / M_PI)),y=\(round(data!.acceleration.y * 180 / M_PI)):z=\(round(data!.acceleration.z * 180 / M_PI))")
            })
            
            
        }
               //閉じる処理
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        print("Tap the [Save] to save a picture")
        
    }
    @IBAction func picSaved(sender: AnyObject) {
        let image:UIImage! = imageView.image
        
        if image != nil {
            UIImageWriteToSavedPhotosAlbum(image, self, "image:didFinishSavingWithError:contextInfo:", nil)
        }else{
            print("error")
        }
    }
    
    //撮影がキャンセルされた時に呼び出される
        func imagePickerControllerDidCancel(picker: UIImagePickerController) {
            picker.dismissViewControllerAnimated(true, completion: nil)
            
        }
    //ユーザに判別
    private func setUpLayout(x: Double , y: Double ,z:Double){
        checkView.layer.cornerRadius = self.checkView.layer.bounds.width/2
        checkView.clipsToBounds = true
        
        //のちに考える」
            if y > 45.00 && y < 55.00 {
            self.checkView.backgroundColor? = UIColor.redColor()
            }else{
                return
        }
    }

}



