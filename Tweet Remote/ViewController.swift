//
//  ViewController.swift
//  Tweet Remote
//
//  Created by Bryan Johnson on 2/18/16.
//  Copyright © 2016 bryguy. All rights reserved.
//
import Social
import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {
    var pickerController:UIImagePickerController = UIImagePickerController()
    
    var window = false
    
    @IBOutlet weak var tLabel: UILabel!
    @IBOutlet weak var sLabel: UILabel!
    @IBOutlet weak var pLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var photo: UIButton!
    @IBOutlet weak var tweetTxt: UITextView!
    @IBOutlet weak var clear: UIButton!
    @IBOutlet weak var enterText: UILabel!
    @IBOutlet weak var quickStart: UILabel!
    
    
    @IBAction func saveBtn(_ sender: UIButton) {
        let txtLine:String = tweetTxt.text!
        let paths = NSSearchPathForDirectoriesInDomains(
            FileManager.SearchPathDirectory.documentDirectory,
            FileManager.SearchPathDomainMask.userDomainMask, true)
        let docDir:String=paths[0]
        let txtFile:String=(docDir as NSString).appendingPathComponent("data.txt")
        
        if !FileManager.default.fileExists(atPath: txtFile) {
            FileManager.default.createFile(atPath: txtFile,
                contents: nil, attributes: nil)
            
        }
        
        let fileHandle:FileHandle=FileHandle(forUpdatingAtPath:txtFile)!
        fileHandle.truncateFile(atOffset: 0)
        fileHandle.write(txtLine.data(using: String.Encoding.utf8)!)
        fileHandle.closeFile()

    }
    
    func tweetWindow() {
        let text: String = tweetTxt.text!
        var timestamp = DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .long)
        
        if timeSwitch.isOn == false{
            timestamp = ""
        }
        
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter) {
            
            let tweetShare:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            tweetShare .setInitialText("\(text) \(timestamp)")
            if timestamp == "" {
                tweetShare .setInitialText("\(text)")
            }
            tweetShare.add(tweetPic.image)
            
            self.present(tweetShare, animated: true, completion: nil)
          
            
        } else {
            
            let alert = UIAlertController(title: "Accounts", message: "Please login to a Twitter account.", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func tweetBtn(_ sender: AnyObject) {
        tweetWindow()
    }
    @IBOutlet weak var tweetPic: UIImageView!
    @IBOutlet weak var removeTxt: UILabel!
    @IBOutlet weak var switchBtn: UISwitch!
    var switchState = true
    var switchState2 = true
    let switchKey2 = "switchState2"
    let switchKey = "switchState"
    @IBAction func quickSwitch(_ sender: AnyObject) {
        UserDefaults.standard.set(switchBtn.isOn, forKey: "switchState")
    }
    @IBAction func photoBtn(_ sender: AnyObject) {
        // 1
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
        // 2
        self.present(pickerController, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        tweetPic.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        self.dismiss(animated: true, completion: nil)
        
        removeTxt.isHidden = false
    }
    @IBOutlet weak var save: UIButton!
    @IBOutlet weak var tweet: UIButton!
    @IBAction func hidekeyboard(_ sender: AnyObject) {
        tweetTxt.resignFirstResponder()
    }
    
    func loadText(){
        let paths = NSSearchPathForDirectoriesInDomains(
            FileManager.SearchPathDirectory.documentDirectory,
            FileManager.SearchPathDomainMask.userDomainMask, true)
        let docDir:String=paths[0] as String
        let txtFile:String=(docDir as NSString).appendingPathComponent("data.txt")
        
        if FileManager.default.fileExists(atPath: txtFile) {
            let fileHandle:FileHandle=FileHandle(forReadingAtPath:txtFile)!
            let txtResults:String=NSString(data: fileHandle.availableData, encoding: String.Encoding.utf8.rawValue)! as String
            fileHandle.closeFile()
            tweetTxt.text=txtResults
        }
    }
    @IBAction func clearTxt(_ sender: AnyObject) {
        
        if tweetTxt.text.isEmpty == false{
            
            tweetTxt.text = ""
        }
        
        if tweetTxt.text == ""{
            
            clear.setTitle("LOAD", for: UIControlState())
            
        }
        
        if clear.titleLabel?.text == "LOAD"{
            
            loadText()
            clear.setTitle("CLEAR", for: UIControlState())
        }
    }
    
    @IBOutlet weak var timeSwitch: UISwitch!
    @IBAction func timeState(_ sender: AnyObject) {
        UserDefaults.standard.set(timeSwitch.isOn, forKey: "switchState2")
    }
    override func viewWillAppear(_ animated: Bool) {
        
        let nav = self.navigationController?.navigationBar
        nav?.tintColor = UIColor.darkGray
        
    }
    
    override func viewWillLayoutSubviews() {
        
        let screenSize = UIScreen.main.bounds.size
        let width = screenSize.width
        let height = screenSize.height
        
        /*if UIDevice.currentDevice().orientation == UIDeviceOrientation.Portrait{
        var rect = tweetTxt.frame
        rect.size.width = 270
        rect.size.height = 107
        tweetTxt.frame = rect
        
        }*/
        
        if height == 480 && width == 320 {
            var rect = tweetTxt.frame
            rect.size.width = 270
            rect.size.height = 107
            rect.origin.x =  25
            rect.origin.y = 87
            tweetTxt.frame = rect
            
            var button1 = tweet.frame
            button1.size.width = 50
            button1.size.height = 50
            button1.origin.x = 25
            button1.origin.y = 202
            tweet.frame = button1
            
            var button2 = save.frame
            button2.size.width = 50
            button2.size.height = 50
            button2.origin.x = 95
            button2.origin.y = 202
            save.frame = button2
            
            var button3 = photo.frame
            button3.size.width = 50
            button3.size.height = 50
            button3.origin.x = 168
            button3.origin.y = 202
            photo.frame = button3
            
            var switch1 = timeSwitch.frame
            switch1.origin.x = 239
            switch1.origin.y = 211
            timeSwitch.frame = switch1
            
            var switch2 = switchBtn.frame
            switch2.origin.x = 82
            switch2.origin.y = 444
            switchBtn.frame = switch2
            
            var label1 = tLabel.frame
            label1.origin.x = 30
            label1.origin.y = 260
            tLabel.frame = label1
            
            var label2 = sLabel.frame
            label2.origin.x = 101
            label2.origin.y = 260
            sLabel.frame = label2
            
            var label3 = pLabel.frame
            label3.origin.x = 168
            label3.origin.y = 263
            pLabel.frame = label3
            
            var label4 = timeLabel.frame
            label4.origin.x = 234
            label4.origin.y = 260
            timeLabel.frame = label4
            
            var label5 = removeTxt.frame
            label5.origin.x = 81
            label5.origin.y = 294
            removeTxt.frame = label5
            
            var label6 = quickStart.frame
            label6.origin.x = 139
            label6.origin.y = 451
            quickStart.frame = label6
            
            var label7 = enterText.frame
            label7.origin.x = 30
            label7.origin.y = 67
            enterText.frame = label7
            
            var label8 = clear.frame
            label8.origin.x = 246
            label8.origin.y = 65
            clear.frame = label8
            
            var image = tweetPic.frame
            image.size.width = 120
            image.size.height = 120
            image.origin.x =  95
            image.origin.y = 316
            tweetPic.frame = image
            
        }
        if height == 568 && width == 320 {
            var rect = tweetTxt.frame
            rect.size.width = 270
            rect.size.height = 107
            rect.origin.x =  25
            rect.origin.y = 87
            tweetTxt.frame = rect
            
            var button1 = tweet.frame
            button1.size.width = 50
            button1.size.height = 50
            button1.origin.x = 25
            button1.origin.y = 202
            tweet.frame = button1
            
            var button2 = save.frame
            button2.size.width = 50
            button2.size.height = 50
            button2.origin.x = 95
            button2.origin.y = 202
            save.frame = button2
            
            var button3 = photo.frame
            button3.size.width = 50
            button3.size.height = 50
            button3.origin.x = 168
            button3.origin.y = 202
            photo.frame = button3
            
            var switch1 = timeSwitch.frame
            switch1.origin.x = 239
            switch1.origin.y = 211
            timeSwitch.frame = switch1
            
            var switch2 = switchBtn.frame
            switch2.origin.x = 82
            switch2.origin.y = 444
            switchBtn.frame = switch2
            
            var label1 = tLabel.frame
            label1.origin.x = 30
            label1.origin.y = 260
            tLabel.frame = label1
            
            var label2 = sLabel.frame
            label2.origin.x = 101
            label2.origin.y = 260
            sLabel.frame = label2
            
            var label3 = pLabel.frame
            label3.origin.x = 168
            label3.origin.y = 263
            pLabel.frame = label3
            
            var label4 = timeLabel.frame
            label4.origin.x = 234
            label4.origin.y = 260
            timeLabel.frame = label4
            
            var label5 = removeTxt.frame
            label5.origin.x = 81
            label5.origin.y = 294
            removeTxt.frame = label5
            
            var label6 = quickStart.frame
            label6.origin.x = 139
            label6.origin.y = 451
            quickStart.frame = label6
            
            var label7 = enterText.frame
            label7.origin.x = 30
            label7.origin.y = 67
            enterText.frame = label7
            
            var label8 = clear.frame
            label8.origin.x = 246
            label8.origin.y = 65
            clear.frame = label8
            
            var image = tweetPic.frame
            image.size.width = 120
            image.size.height = 120
            image.origin.x =  95
            image.origin.y = 316
            tweetPic.frame = image
            
        }
        if height == 667 && width == 375 {
            var rect = tweetTxt.frame
            rect.size.width = 335
            rect.size.height = 115
            rect.origin.x =  20
            rect.origin.y = 87
            tweetTxt.frame = rect
            
            var button1 = tweet.frame
            button1.size.width = 64
            button1.size.height = 64
            button1.origin.x = 29
            button1.origin.y = 216
            tweet.frame = button1
            
            var button2 = save.frame
            button2.size.width = 64
            button2.size.height = 64
            button2.origin.x = 114
            button2.origin.y = 216
            save.frame = button2
            
            var button3 = photo.frame
            button3.size.width = 64
            button3.size.height = 64
            button3.origin.x = 199
            button3.origin.y = 216
            photo.frame = button3
            
            var switch1 = timeSwitch.frame
            switch1.origin.x = 289
            switch1.origin.y = 232
            timeSwitch.frame = switch1
            
            var switch2 = switchBtn.frame
            switch2.origin.x = 114
            switch2.origin.y = 616
            switchBtn.frame = switch2
            
            var label1 = tLabel.frame
            label1.origin.x = 40
            label1.origin.y = 288
            tLabel.frame = label1
            
            var label2 = sLabel.frame
            label2.origin.x = 127
            label2.origin.y = 288
            sLabel.frame = label2
            
            var label3 = pLabel.frame
            label3.origin.x = 206
            label3.origin.y = 291
            pLabel.frame = label3
            
            var label4 = timeLabel.frame
            label4.origin.x = 283
            label4.origin.y = 288
            timeLabel.frame = label4
            
            var label5 = removeTxt.frame
            label5.origin.x = 108
            label5.origin.y = 351
            removeTxt.frame = label5
            
            var label6 = quickStart.frame
            label6.origin.x = 171
            label6.origin.y = 623
            quickStart.frame = label6
            
            var label7 = enterText.frame
            label7.origin.x = 20
            label7.origin.y = 67
            enterText.frame = label7
            
            var label8 = clear.frame
            label8.origin.x = 306
            label8.origin.y = 65
            clear.frame = label8
            
            var image = tweetPic.frame
            image.size.width = 227
            image.size.height = 227
            image.origin.x =  74
            image.origin.y = 381
            tweetPic.frame = image
            
        }
        if height == 736 && width == 414 {
            var rect = tweetTxt.frame
            rect.size.width = 335
            rect.size.height = 115
            rect.origin.x =  40
            rect.origin.y = 88
            tweetTxt.frame = rect
            
            var button1 = tweet.frame
            button1.size.width = 64
            button1.size.height = 64
            button1.origin.x = 49
            button1.origin.y = 217
            tweet.frame = button1
            
            var button2 = save.frame
            button2.size.width = 64
            button2.size.height = 64
            button2.origin.x = 134
            button2.origin.y = 217
            save.frame = button2
            
            var button3 = photo.frame
            button3.size.width = 64
            button3.size.height = 64
            button3.origin.x = 219
            button3.origin.y = 217
            photo.frame = button3
            
            var switch1 = timeSwitch.frame
            switch1.origin.x = 309
            switch1.origin.y = 233
            timeSwitch.frame = switch1
            
            var switch2 = switchBtn.frame
            switch2.origin.x = 134
            switch2.origin.y = 685
            switchBtn.frame = switch2
            
            var label1 = tLabel.frame
            label1.origin.x = 60
            label1.origin.y = 289
            tLabel.frame = label1
            
            var label2 = sLabel.frame
            label2.origin.x = 147
            label2.origin.y = 289
            sLabel.frame = label2
            
            var label3 = pLabel.frame
            label3.origin.x = 226
            label3.origin.y = 292
            pLabel.frame = label3
            
            var label4 = timeLabel.frame
            label4.origin.x = 303
            label4.origin.y = 289
            timeLabel.frame = label4
            
            var label5 = removeTxt.frame
            label5.origin.x = 128
            label5.origin.y = 365
            removeTxt.frame = label5
            
            var label6 = quickStart.frame
            label6.origin.x = 191
            label6.origin.y = 692
            quickStart.frame = label6
            
            var label7 = enterText.frame
            label7.origin.x = 40
            label7.origin.y = 65
            enterText.frame = label7
            
            var label8 = clear.frame
            label8.origin.x = 326
            label8.origin.y = 66
            clear.frame = label8
            
            var image = tweetPic.frame
            image.size.width = 227
            image.size.height = 227
            image.origin.x =  94
            image.origin.y = 395
            tweetPic.frame = image
            
        }
        
     
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        performAction()
    }
    
    func performAction() {
        
        clear.setTitle("CLEAR", for: UIControlState())
    }

    override func viewDidLoad() {
        
        print(UIScreen.main.bounds)
        
        self.tweetTxt.delegate = self
            
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false 
        loadText()
        self.timeSwitch.isOn = UserDefaults.standard.bool(forKey: switchKey2)
        self.switchBtn.isOn = UserDefaults.standard.bool(forKey: switchKey)
        if switchBtn.isOn == true{
            tweetWindow()
        }
        
        removeTxt.isHidden = true
        tweetTxt.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        tweetTxt.layer.borderWidth = 2.0
        tweetTxt.layer.cornerRadius = 10
        
        
        self.tweetPic.isUserInteractionEnabled = true
        
        // Create a UITapGestureRecognizer
        let gestureRecogniser = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissImageView(_:)))
        
        // Add the UITapGestureRecognizer to the image view
        self.tweetPic.addGestureRecognizer(gestureRecogniser)
        
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    func dismissImageView(_ gestureRecognizer: UITapGestureRecognizer) {
        // Remove the image view
        tweetPic.image = nil
        removeTxt.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    


}

