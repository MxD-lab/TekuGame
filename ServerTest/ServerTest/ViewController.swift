//
//  ViewController.swift
//  ServerTest
//
//  Created by ステファンアレクサンダー on 2014/07/11.
//  Copyright (c) 2014年 ステファンアレクサンダー. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
                            
    @IBOutlet var iphoneText: UITextField
    @IBOutlet var ibeaconText: UITextField
    @IBOutlet var httpOutput: UITextView
    
    @IBAction func postPressed(sender: AnyObject) {
        println("You are posting")
        
        var url = "http://tekugame.mxd.media.ritsumei.ac.jp/form/index.php"
        //var url = "http://posttestserver.com/post.php"
        
        var str = "phone="+iphoneText.text+"&beacon="+ibeaconText.text+"&submit=submit"
        println("the string: \(str)\n")
        
        var post = "POST"
     
        httpRequest(url, method: post, content: str)
    }
    
    @IBAction func getPressed(sender: AnyObject) {
        println("You are getting")
        var url = "http://stefafafan.com"
        var get = "GET"
        httpRequest(url, method: get)
    }
    
    // [Swift]POSTでAPIを叩く方法。（そしてJSONを取得する。）
    // http://qiita.com/mochizukikotaro/items/e2da2d3186ec24e291a6
    // http://www.brianjcoleman.com/tutorial-post-to-web-server-api-in-swift-using-nsurlconnection/
    func httpRequest(urlstring:String, method:String, content:String = "") {
        
        var url = NSURL.URLWithString(urlstring) // URL object from URL string.
        var request = NSMutableURLRequest(URL: url) // Request.
        request.HTTPMethod = method // Could be POST or GET.
        
        // Post has HTTPBody.
        if method == "POST" {
            var strData = content.dataUsingEncoding(NSUTF8StringEncoding)
            request.HTTPBody = strData
            request.setValue("text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
                forHTTPHeaderField: "Accept")
            request.setValue("gzip,deflate,sdch", forHTTPHeaderField: "Accept-Encoding")
            request.setValue("ja,en-US;q=0.8,en;q=0.6", forHTTPHeaderField: "Accept-Language")
            request.setValue("tekugame.mxd.media.ritsumei.ac.jp", forHTTPHeaderField: "Host")
        }
        
        // Values returned from server.
        var response: NSURLResponse? = nil
        var error: NSError? = nil
        
        // Reply from server.
        let reply = NSURLConnection.sendSynchronousRequest(request, returningResponse:&response, error:&error)
        let results = NSString(data:reply, encoding:NSUTF8StringEncoding) // Encoded results.
        
        // Debug.
        println("Request:\n\(request)\n")
        println("Response HTML:\n \(results)\n")
        println("Response:\n \(response)\n")
        println("Error:\n \(error)")
        httpOutput.text = "\(results)"
        
        iphoneText.text = "";
        ibeaconText.text = "";
    }
    
    // Hide keyboard when background touched.
    // http://ios-blog.co.uk/tutorials/developing-ios8-apps-using-swift-create-a-to-do-application/
    override func touchesBegan(touches: NSSet!, withEvent event: UIEvent!) {
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

