//
//  ViewController.swift
//  TideDemo
//
//  Created by Andrew Aquino on 6/4/16.
//  Copyright © 2016 Andrew Aquino. All rights reserved.
//

import UIKit
import SwiftyTimer

public class ViewController: UIViewController {
  
  public var imageView: UIImageView?
  public var button: UIButton?
  
  override public func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
//    imageView = UIImageView(frame: CGRectMake(0, 0, 256, 256))
//    imageView?.backgroundColor = .redColor()
//    imageView?.contentMode = .Center
//    imageView?.image = UIImage(named: "tide-example.jpg")
//    view.addSubview(imageView!)
    
//    imageView?.imageFromUrl("http://www.planwallpaper.com/static/images/001_Fish-Wallpaper-HD.jpg", maskWithEllipse: true)
    button = UIButton(frame: CGRectMake(0, 0, 100, 100))
    button?.backgroundColor = .redColor()
    view.addSubview(button!)
    
    button?.imageFromSource("http://www.planwallpaper.com/static/images/001_Fish-Wallpaper-HD.jpg", forState: .Normal)
    button?.imageFromSource("http://www.planwallpaper.com/static/images/a601cb579cc9a289bc51cd41d8bcf478_large.jpg", mask: .Rounded, forState: .Highlighted)
//    test0()
//    
//    NSTimer.every(10.0) { [weak self] in
//      self?.test0()
//    }
  }

  override public func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  public func test0(imageView: UIImageView?) {
    
    imageView?.image = UIImage(named: "tide-example.jpg")
    test()
    
    NSTimer.after(5.0) { [weak self] in
      self?.imageView?.image = UIImage(named: "profile-pic-example.jpg")
      self?.test()
    }
    
    NSTimer.after(10.0) { [weak self] in
      self?.imageView?.image = UIImage(named: "profile-pic-example2.jpg")
      self?.test()
    }
  }

  public func test() {
    NSTimer.after(3.0) { [weak self] in
      self?.imageView?.fitClip()
    }
    
    NSTimer.after(4.0) { [weak self] in
      self?.imageView?.backgroundColor = .whiteColor()
      self?.imageView?.rounded()
    }
  }
}

import SDWebImage

extension UIImageView {
  
  public func imageFromUrl (
    url: String?,
    placeholder: UIImage? = nil,
    maskWithEllipse: Bool = false,
    block: ((image: UIImage?) -> Void)? = nil)
  {
    if let url = url, let nsurl = NSURL(string: url) {
      // set the tag with the url's unique hash value
      if tag == url.hashValue { return }
      // else set the new tag as the new url's hash value
      tag = url.hashValue
      image = nil
      // show activity
//      showActivityView(nil, width: frame.width, height: frame.height)
      // begin image download
      SDWebImageManager.sharedManager().downloadImageWithURL(nsurl, options: [], progress: { (received: NSInteger, actual: NSInteger) -> Void in
        }) { [weak self] (image, error, cache, finished, nsurl) -> Void in
          block?(image: image)
          if maskWithEllipse {
            self?.fitClip(image) { [weak self] image in self?.rounded(image) }
          } else {
            self?.fitClip(image)
          }
//          self?.dismissActivityView()
      }
    } else {
      image = placeholder
      fitClip()
    }
  }
}