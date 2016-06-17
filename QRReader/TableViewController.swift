//
//  TableViewController.swift
//  QRReader
//
//  Created by M.Ike on 2016/06/18.
//  Copyright © 2016年 M.Ike. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // 検出したQRコードのリスト
    var codes = [(image: UIImage, text: String)]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return codes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
        
        // 縦横比を維持してセルいっぱいに表示
        cell.imageView?.contentMode = .ScaleAspectFit
        cell.imageView?.image = codes[indexPath.row].image
        cell.textLabel?.text = codes[indexPath.row].text
        
        return cell
    }
    
    // MARK: - UIImagePickerControllerDelegate
    
    // 画像を選択した時に呼ばれる
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        codes = []
        
        // 選択画面を閉じてリストの表示を更新
        picker.dismissViewControllerAnimated(true) {
            self.tableView.reloadData()
        }
        
        // 選択された画像をCoreImageへ変換
        guard let ciimg = CIImage(image: image) else {
            print("画像変換に失敗")
            return
        }
        
        // QRコードの検出器を作成
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: nil)
        
        // QR検出
        guard let results = detector.featuresInImage(ciimg) as? [CIQRCodeFeature] else {
            print("画像認識に失敗")
            return
        }
        
        // 結果をリストにまとめる
        for code in results {
            codes += [(image: UIImage(CIImage: ciimg.imageByCroppingToRect(code.bounds)),
                text: code.messageString)]
        }
    }
    
    // MARK: -
    @IBAction func tapRefresh(sender: UIBarButtonItem) {
        let vc = UIImagePickerController()
        vc.sourceType = .PhotoLibrary
        vc.delegate = self
        presentViewController(vc, animated: true, completion: nil)
    }
    
}