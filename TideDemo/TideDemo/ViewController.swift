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
  
  override public func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    imageView = UIImageView(frame: CGRectMake(0, 0, 256, 256))
    imageView?.backgroundColor = .redColor()
    imageView?.contentMode = .Center
    imageView?.image = UIImage(named: "tide-example.jpg")
    view.addSubview(imageView!)
    
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

  override public func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
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

