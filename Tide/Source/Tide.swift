//
//  Tide.swift
//  Tide
//
//  Created by Andrew Aquino on 6/4/16.
//  Copyright © 2016 Andrew Aquino. All rights reserved.
//

import UIKit
import CoreGraphics
import SDWebImage

open class Tide {
  
  public enum Mask {
    case rounded
    case squared
    case none
  }
  
  public enum fitMode {
    case clip
    case crop
    case scale
    case none
  }
  
  open var image: UIImage?
  
  public init(image: UIImage?) {
    self.image = image
  }
  
  open func fitClip(_ size: CGSize?) -> Tide {
    image = Tide.resizeImage(image, size: size)
    return self
  }
  
  open func rounded() -> Tide {
    image = Tide.Util.maskImageWithEllipse(image)
    return self
  }
  
  open static func resizeImage(_ image: UIImage?, size: CGSize?, fitMode: Tide.fitMode = .clip) -> UIImage? {
    guard let image = image, let size = size, size.height > 0 && size.width > 0 else { return nil }
    
    let imgRef = Util.CGImageWithCorrectOrientation(image)
    let originalWidth  = CGFloat((imgRef?.width)!)
    let originalHeight = CGFloat((imgRef?.height)!)
    let widthRatio = size.width / originalWidth
    let heightRatio = size.height / originalHeight
    
    let scaleRatio = widthRatio > heightRatio ? widthRatio : heightRatio
    
    let resizedImageBounds = CGRect(x: 0, y: 0, width: round(originalWidth * scaleRatio), height: round(originalHeight * scaleRatio))
    
    switch (fitMode) {
    case .clip:
      
      let scaleOffWidth: Bool = originalWidth > originalHeight
      
      let width: CGFloat = scaleOffWidth ? size.width : round(size.height * originalWidth / originalHeight)
      let height: CGFloat = !scaleOffWidth ? size.height : round(size.width * originalHeight / originalWidth)
      
      return Util.drawImageInBounds(image, bounds: CGRect(x: 0, y: 0, width: width, height: height))
    case .crop:
      if let resizedImage = Util.drawImageInBounds(image, bounds: resizedImageBounds) {
        let croppedRect = CGRect(x: (resizedImage.size.width - size.width) / 2,
                                 y: (resizedImage.size.height - size.height) / 2,
                                 width: size.width, height: size.height)
        return Util.croppedImageWithRect(resizedImage, rect: croppedRect)
      }
      return nil
    case .scale:
      return Util.drawImageInBounds(image, bounds: CGRect(x: 0, y: 0, width: size.width, height: size.height))
    case .none:
      return image
    }
  }
  
  internal struct Util {
    
    static func maskImageWithEllipse(
      _ image: UIImage?,
      borderWidth: CGFloat = 0,
      borderColor: UIColor = UIColor.white
      ) -> UIImage? {
      
      guard let image = image else { return nil }
      
      let imgRef = Util.CGImageWithCorrectOrientation(image)
      let size = CGSize(width: CGFloat((imgRef?.width)!) / image.scale, height: CGFloat((imgRef?.height)!) / image.scale)
      
      return Util.drawImageWithClosure(size) { (size: CGSize, context: CGContext) -> () in
        
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        context.addEllipse(in: rect)
        context.clip()
        image.draw(in: rect)
        
        if (borderWidth > 0) {
          context.setStrokeColor(borderColor.cgColor);
          context.setLineWidth(borderWidth);
          context.addEllipse(in: CGRect(x: borderWidth / 2,
                                        y: borderWidth / 2,
                                        width: size.width - borderWidth,
                                        height: size.height - borderWidth));
          context.strokePath();
        }
      }
    }
    
    static func maskImageWithRoundedRect(
      _ image: UIImage?,
      cornerRadius: CGFloat,
      borderWidth: CGFloat = 0,
      borderColor: UIColor = UIColor.white
      ) -> UIImage? {
      guard let image = image else { return nil }
      let imgRef = Util.CGImageWithCorrectOrientation(image)
      let size = CGSize(width: CGFloat((imgRef?.width)!) / image.scale, height: CGFloat((imgRef?.height)!) / image.scale)
      
      return Tide.Util.drawImageWithClosure(size) { (size: CGSize, context: CGContext) -> () in
        
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        UIBezierPath(roundedRect:rect, cornerRadius: cornerRadius).addClip()
        image.draw(in: rect)
        
        if (borderWidth > 0) {
          context.setStrokeColor(borderColor.cgColor);
          context.setLineWidth(borderWidth);
          
          let borderRect = CGRect(x: 0, y: 0,
                                  width: size.width, height: size.height)
          
          let borderPath = UIBezierPath(roundedRect: borderRect, cornerRadius: cornerRadius)
          borderPath.lineWidth = borderWidth * 2
          borderPath.stroke()
        }
      }
    }
    
    static func CGImageWithCorrectOrientation(_ image : UIImage?) -> CGImage? {
      guard let image = image else { return nil }
      
      if (image.imageOrientation == UIImageOrientation.up) { return image.cgImage! }
      
      var transform : CGAffineTransform = CGAffineTransform.identity;
      
      switch (image.imageOrientation) {
      case UIImageOrientation.right, UIImageOrientation.rightMirrored:
        transform = transform.translatedBy(x: 0, y: image.size.height)
        transform = transform.rotated(by: CGFloat(-1.0 * M_PI_2))
        break
      case UIImageOrientation.left, UIImageOrientation.leftMirrored:
        transform = transform.translatedBy(x: image.size.width, y: 0)
        transform = transform.rotated(by: CGFloat(M_PI_2))
        break
      case UIImageOrientation.down, UIImageOrientation.downMirrored:
        transform = transform.translatedBy(x: image.size.width, y: image.size.height)
        transform = transform.rotated(by: CGFloat(M_PI))
        break
      default:
        break
      }
      
      switch (image.imageOrientation) {
      case UIImageOrientation.rightMirrored, UIImageOrientation.leftMirrored:
        transform = transform.translatedBy(x: image.size.height, y: 0);
        transform = transform.scaledBy(x: -1, y: 1);
        break
      case UIImageOrientation.downMirrored, UIImageOrientation.upMirrored:
        transform = transform.translatedBy(x: image.size.width, y: 0);
        transform = transform.scaledBy(x: -1, y: 1);
        break
      default:
        break
      }
      
      let contextWidth : Int
      let contextHeight : Int
      
      switch (image.imageOrientation) {
      case UIImageOrientation.left, UIImageOrientation.leftMirrored,
           UIImageOrientation.right, UIImageOrientation.rightMirrored:
        contextWidth = (image.cgImage?.height)!
        contextHeight = (image.cgImage?.width)!
        break
      default:
        contextWidth = (image.cgImage?.width)!
        contextHeight = (image.cgImage?.height)!
        break
      }
      
      let context : CGContext = CGContext(data: nil, width: contextWidth, height: contextHeight,
                                          bitsPerComponent: image.cgImage!.bitsPerComponent,
                                          bytesPerRow: image.cgImage!.bytesPerRow,
                                          space: image.cgImage!.colorSpace!,
                                          bitmapInfo: image.cgImage!.bitmapInfo.rawValue)!;
      
      context.concatenate(transform);
      context.draw(image.cgImage!, in: CGRect(x: 0, y: 0, width: CGFloat(contextWidth), height: CGFloat(contextHeight)));
      
      let cgImage = context.makeImage();
      return cgImage!;
    }
    
    static func drawImageInBounds(_ image: UIImage?, bounds : CGRect?) -> UIImage? {
      return drawImageWithClosure(bounds?.size) { [weak image] (size: CGSize, context: CGContext) -> () in
        var _bounds: CGRect? = bounds
        if let bounds = _bounds { image?.draw(in: bounds) }
        image = nil
        _bounds = nil
      };
    }
    
    static func croppedImageWithRect(_ image: UIImage?, rect: CGRect?) -> UIImage? {
      return drawImageWithClosure(rect?.size) { [weak image] (size: CGSize, context: CGContext) -> () in
        guard let image = image else { return }
        var _rect: CGRect? = rect
        let drawRect = CGRect(x: -_rect!.origin.x, y: -_rect!.origin.y, width: image.size.width, height: image.size.height)
        context.clip(to: CGRect(x: 0, y: 0, width: _rect!.size.width, height: _rect!.size.height))
        image.draw(in: drawRect)
        _rect = nil
      }
    }
    
    static func drawImageWithClosure(_ size: CGSize?, closure: @escaping (_ size: CGSize, _ context: CGContext) -> ()) -> UIImage? {
      var _closure: ((_ size: CGSize, _ context: CGContext) -> ())? = closure
      var _size: CGSize? = size
      var _image: UIImage?
      UIGraphicsBeginImageContextWithOptions(_size!, false, 0)
      if let context = UIGraphicsGetCurrentContext() {
        _closure?(_size!, context)
        _image = UIGraphicsGetImageFromCurrentImageContext()
      }
      UIGraphicsEndImageContext()
      _size = nil
      _closure = nil
      return _image
    }
  }
}

extension UIImageView {
  
  @discardableResult
  public func fitClip(image: UIImage? = nil, fitMode: Tide.fitMode = .clip, completionHandler: ((_ image: UIImage?) -> Void)? = nil) -> Self {
    DispatchQueue.global(qos: .utility).async { [weak self] in
      var imageMod: UIImage? = Tide.resizeImage(image ?? self?.image, size: self?.frame.size, fitMode: fitMode)
      DispatchQueue.main.async { [weak self] in
        if let completionHandler = completionHandler {
          completionHandler(imageMod ?? image)
        } else {
          self?.image = imageMod ?? image
        }
        imageMod = nil
      }
    }
    return self
  }
  
  @discardableResult
  public func rounded(
    _ image: UIImage? = nil,
    borderWidth: CGFloat = 0,
    borderColor: UIColor = UIColor.white,
    completionHandler: ((_ image: UIImage?) -> Void)? = nil
    ) -> Self {
    DispatchQueue.global(qos: .utility).async { [weak self] in
      var imageMod: UIImage? = Tide.Util.maskImageWithEllipse(
        image != nil ? image : self?.image,
        borderWidth: borderWidth,
        borderColor: borderColor
      )
      DispatchQueue.main.async { [weak self] in
        if let completionHandler = completionHandler {
          completionHandler(imageMod ?? image)
        } else {
          self?.image = imageMod ?? image
        }
        imageMod = nil
      }
    }
    return self
  }
  
  @discardableResult
  public func squared(
    _ image: UIImage? = nil,
    cornerRadius: CGFloat,
    borderWidth: CGFloat = 0,
    borderColor: UIColor = UIColor.white,
    completionHandler: ((_ image: UIImage?) -> Void)? = nil
    ) -> Self {
    DispatchQueue.global(qos: .utility).async { [weak self] in
      var imageMod: UIImage? = Tide.Util.maskImageWithRoundedRect(
        image != nil ? image : self?.image,
        cornerRadius: cornerRadius,
        borderWidth: borderWidth,
        borderColor: borderColor
      )
      DispatchQueue.main.async { [weak self] in
        if let completionHandler = completionHandler {
          completionHandler(imageMod ?? image)
        } else {
          self?.image = imageMod ?? image
        }
        imageMod = nil
      }
    }
    return self
  }
  
  
  public func imageFromSource(
    _ url: String? = nil,
    placeholder: UIImage? = nil,
    fitMode: Tide.fitMode = .clip,
    mask: Tide.Mask = .none,
    cornerRadius: CGFloat = 0,
    borderWidth: CGFloat = 0,
    borderColor: UIColor = UIColor.white,
    animated: Bool = false,
    showActivityAnimation: Bool = false,
    forced: Bool = true,
    progress: ((Float) -> Void)? = nil,
    skipImageSetAfterDownload: Bool = false,
    block: ((_ image: UIImage?) -> Void)? = nil)
  {
    
    func getImageKey() -> String? {
      let widthKey = frame.size.width.description
      let heightKey = frame.size.height.description
      let sourceKey = url?.hashValue.description ?? placeholder?.hashValue.description ?? ""
      let imageKey = sourceKey + widthKey + heightKey
      return imageKey.isEmpty ? nil : imageKey
    }
    
    func cacheImage(_ image: UIImage?) {
      SDImageCache.shared().store(image, forKey: getImageKey(), toDisk: false)
    }
    
    func setImage(_ image: UIImage?) {
      hideActivityIndicator()
      self.image = image ?? placeholder ?? self.image
      if animated {
        alpha = 0.0
        UIView.animate(withDuration: 0.4, animations: { [weak self] in
          self?.alpha = 1.0
        })
      }
      block?(image ?? placeholder)
    }
    
    func fitClip(_ image: UIImage?, fitMode: Tide.fitMode) {
      // default the content mode so the image view does not
      // handle the resizing of the image itself
      contentMode = .center
      if let imageKey = getImageKey(), let image = SDImageCache.shared().imageFromMemoryCache(forKey: imageKey), image.size.equalTo(frame.size) {
        setImage(image)
      } else {
        self.fitClip(image: image, fitMode: fitMode) { [weak self] image in
          switch mask {
          case .rounded:
            self?.rounded(image, borderWidth: borderWidth, borderColor: borderColor) { image in
              cacheImage(image)
              setImage(image)
            }
          case .squared:
            self?.squared(image, cornerRadius: cornerRadius, borderWidth: borderWidth, borderColor: borderColor) { image in
              cacheImage(image)
              setImage(image)
            }
          case .none:
            cacheImage(image)
            setImage(image)
          }
        }
      }
    }
    
    if showActivityAnimation { showActivityIndicator() }
    
    if let imageKey = getImageKey(), let image = SDImageCache.shared().imageFromMemoryCache(forKey: imageKey) {
      setImage(image)
    } else if let url = url, let nsurl = URL(string: url) {
      // show activity
      let _ = SDWebImageManager.shared().imageDownloader?.downloadImage(
        with: nsurl,
        options: [
          .useNSURLCache
        ],
        progress: { (received, actual, url) in
          if let _ = progress?(Float(received) / Float(actual)) {}
      }
      ) { (image, data, error, finished) -> Void in
        if skipImageSetAfterDownload {
          cacheImage(image)
          block?(image)
        } else {
          fitClip(image, fitMode: fitMode)
        }
      }
    } else if let placeholder = placeholder {
      fitClip(placeholder, fitMode: fitMode)
    } else if forced {
      self.image = nil
    } else {
      fitClip(image, fitMode: fitMode)
    }
  }
}

extension UIButton {
  
  @discardableResult
  public func fitClip(
    _ image: UIImage? = nil,
    fitMode: Tide.fitMode = .clip,
    forState: UIControlState,
    completionHandler: ((_ image: UIImage?) -> Void)? = nil
    ) -> Self {
    DispatchQueue.global(qos: .utility).async { [weak self] in
      var imageMod: UIImage? = Tide.resizeImage(image != nil ? image : self?.imageView?.image, size: self?.frame.size)
      DispatchQueue.main.async { [weak self] in
        if let completionHandler = completionHandler {
          completionHandler(imageMod ?? image)
        } else {
          self?.setImage(imageMod ?? image, for: forState)
        }
        imageMod = nil
      }
    }
    return self
  }
  
  @discardableResult
  public func rounded(
    _ image: UIImage? = nil,
    borderWidth: CGFloat = 0,
    borderColor: UIColor = UIColor.white,
    forState: UIControlState,
    completionHandler: ((_ image: UIImage?) -> Void)? = nil
    ) -> Self {
    DispatchQueue.global(qos: .utility).async { [weak self] in
      var imageMod: UIImage? = Tide.Util.maskImageWithEllipse(
        image != nil ? image : self?.imageView?.image,
        borderWidth: borderWidth,
        borderColor: borderColor
      )
      DispatchQueue.main.async { [weak self] in
        if let completionHandler = completionHandler {
          completionHandler(imageMod ?? image)
        } else {
          self?.setImage(imageMod ?? image, for: forState)
        }
        imageMod = nil
      }
    }
    return self
  }
  
  @discardableResult
  public func squared(
    _ image: UIImage? = nil,
    cornerRadius: CGFloat,
    borderWidth: CGFloat = 0,
    borderColor: UIColor = UIColor.white,
    forState: UIControlState,
    completionHandler: ((_ image: UIImage?) -> Void)? = nil
    ) -> Self {
    DispatchQueue.global(qos: .utility).async { [weak self] in
      var imageMod: UIImage? = Tide.Util.maskImageWithRoundedRect(
        image != nil ? image : self?.imageView?.image,
        cornerRadius: cornerRadius,
        borderWidth: borderWidth,
        borderColor: borderColor
      )
      DispatchQueue.main.async { [weak self] in
        if let completionHandler = completionHandler {
          completionHandler(imageMod ?? image)
        } else {
          self?.setImage(imageMod ?? image, for: forState)
        }
        imageMod = nil
      }
    }
    return self
  }
  
  public func imageFromSource(
    _ url: String? = nil,
    placeholder: UIImage? = nil,
    fitMode: Tide.fitMode = .clip,
    mask: Tide.Mask = .none,
    cornerRadius: CGFloat = 0,
    borderWidth: CGFloat = 0,
    borderColor: UIColor = UIColor.white,
    animated: Bool = false,
    showActivityAnimation: Bool = false,
    forced: Bool = true,
    forState: UIControlState,
    progress: ((Float) -> Void)? = nil,
    block: ((_ image: UIImage?) -> Void)? = nil)
  {
    
    func getImageKey() -> String? {
      let widthKey = frame.size.width.description
      let heightKey = frame.size.height.description
      let sourceKey = url?.hashValue.description ?? placeholder?.hashValue.description ?? ""
      let imageKey = sourceKey + widthKey + heightKey
      return imageKey.isEmpty ? nil : imageKey
    }
    
    func cacheImage(_ image: UIImage?) {
      SDImageCache.shared().store(image, forKey: getImageKey(), toDisk: false)
    }
    
    func setImage(_ image: UIImage?) {
      hideActivityIndicator()
      self.setImage(image, for: forState)
      if animated {
        alpha = 0.0
        UIView.animate(withDuration: 0.4, animations: { [weak self] in
          self?.alpha = 1.0
        })
      }
      block?(image ?? placeholder)
    }
    
    func fitClip(_ image: UIImage?, fitMode: Tide.fitMode) {
      // default the content mode so the image view does not
      // handle the resizing of the image itself
      contentMode = .center
      if let imageKey = getImageKey(), let image = SDImageCache.shared().imageFromMemoryCache(forKey: imageKey), image.size.equalTo(frame.size) {
        setImage(image)
      } else {
        self.fitClip(image, fitMode: fitMode, forState: forState) { [weak self] image in
          switch mask {
          case .rounded:
            self?.rounded(image, borderWidth: borderWidth, borderColor: borderColor, forState: forState) { image in
              cacheImage(image)
              setImage(image)
            }
          case .squared:
            self?.squared(image, cornerRadius: cornerRadius, borderWidth: borderWidth, borderColor: borderColor, forState: forState) { image in
              cacheImage(image)
              setImage(image)
            }
          case .none:
            cacheImage(image)
            setImage(image)
          }
        }
      }
    }
    
    if showActivityAnimation { showActivityIndicator() }
    
    if let imageKey = getImageKey(), let image = SDImageCache.shared().imageFromMemoryCache(forKey: imageKey) {
      setImage(image)
    } else if let url = url, let nsurl = URL(string: url) {
      // show activity
      let _ = SDWebImageManager.shared().imageDownloader?.downloadImage(
        with: nsurl,
        options: [
          .useNSURLCache
        ],
        progress: { (received, actual, url) in
          if let _ = progress?(Float(received) / Float(actual)) {}
      }
      ) { (image, data, error, finished) -> Void in
        fitClip(image ?? placeholder, fitMode: fitMode)
      }
    } else if let placeholder = placeholder {
      fitClip(placeholder, fitMode: fitMode)
    } else if forced {
      self.setImage(nil, for: forState)
    } else {
      fitClip(imageView?.image, fitMode: fitMode)
    }
  }
}

extension UIView {
  
  fileprivate func showActivityIndicator() {
    hideActivityIndicator()
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    activityIndicator.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
    activityIndicator.center = center
    addSubview(activityIndicator)
    activityIndicator.startAnimating()
  }
  
  fileprivate func hideActivityIndicator() {
    subviews.forEach {
      if let activityIndicator = $0 as? UIActivityIndicatorView {
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
      }
    }
  }
}







