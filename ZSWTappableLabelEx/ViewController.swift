//
//  ViewController.swift
//  ZSWTappableLabelEx
//
//  Created by burt on 2016. 1. 31..
//  Copyright © 2016년 BurtK. All rights reserved.
//

import UIKit
import ZSWTappableLabel
import ZSWTaggedString

class ViewController: UIViewController {
    
    @IBOutlet weak var label: ZSWTappableLabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        basicTappableLink()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    func basicTappableLink() {

        let options = ZSWTaggedStringOptions()
        options["link"] = .Dynamic({ tagName, tagAttributes, stringAttributes in
            guard let type = tagAttributes["type"] as? String else {
                return [String:AnyObject]()
            }
            
            var foundURL: NSURL?
            
            switch type {
            case "privacy":
                foundURL = NSURL(string: "http://www.google.co.kr")
            case "tos":
                foundURL = NSURL(string: "http://www.daum.net")
            default:
                break
            }
            
            guard let URL = foundURL else {
                return [String:AnyObject]()
            }
            
            return [
                ZSWTappableLabelTappableRegionAttributeName: true,
                ZSWTappableLabelHighlightedBackgroundAttributeName: UIColor.lightGrayColor(),
                ZSWTappableLabelHighlightedForegroundAttributeName: UIColor.whiteColor(),
                NSForegroundColorAttributeName: UIColor.blueColor(),
                NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue,
                
                "URL": URL
                
            ]
        })
        
        let string = "View our <link type='privacy'>Privacy Policy</link> or <link type='tos'>Terms of Service</link>"
        label.attributedText = try? ZSWTaggedString(string: string).attributedStringWithOptions(options)
        label.tapDelegate = self
    }
}

extension ViewController : ZSWTappableLabelTapDelegate {
    func tappableLabel(tappableLabel: ZSWTappableLabel, tappedAtIndex idx: Int, withAttributes attributes: [String : AnyObject]) {
        if let url = attributes["URL"] as? NSURL {
            UIApplication.sharedApplication().openURL(url)
        }
    }
}

