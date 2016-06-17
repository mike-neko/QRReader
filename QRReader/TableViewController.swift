//
//  TableViewController.swift
//  QRReader
//
//  Created by M.Ike on 2016/06/18.
//  Copyright © 2016年 M.Ike. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
        
        // Configure the cell...
        cell.imageView?.contentMode = .ScaleAspectFit
        cell.imageView?.image = codes[indexPath.row].image
        cell.textLabel?.text = codes[indexPath.row].text
        
        return cell
    }
    
    // MARK: - UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        codes = []
        picker.dismissViewControllerAnimated(true) {
            self.tableView.reloadData()
        }
        
        guard let ciimg = CIImage(image: image) else {
            print("画像変換に失敗")
            return
        }
        
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: nil)
        
        guard let results = detector.featuresInImage(ciimg) as? [CIQRCodeFeature] else {
            print("画像認識に失敗")
            return
        }
        
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