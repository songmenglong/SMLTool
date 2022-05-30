//
//  ImagePickerTool.swift
//  Gem_Home
//
//  Created by SongMenglong on 2020/9/15.
//  Copyright © 2020 gemvary. All rights reserved.
//

import UIKit

/// 系统相册工具
class ImagePickerTool: NSObject {
    /// 创建单例
    @objc static var share: ImagePickerTool = {
        let share = ImagePickerTool()
        return share
    }()
    /// 照片
//    private var imageView: UIImageView = {
//        let imageView = UIImageView()
//        return imageView
//    }()
    /// 相片选择器
    private lazy var imagePicker: UIImagePickerController = {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        return imagePicker
    }()
    /// 创建闭包返回内容
    private var selectImageClosure: ((_ image: UIImage?) -> Void)?
    
    ///  选择相机
    @objc func selectCamera() -> Void {
        guard let keyWindow = UIApplication.shared.keyWindow, let mianVC = keyWindow.rootViewController else {
            //swiftDebug("获取 根控制器 为空")
            return
        }
        self.imagePicker.sourceType = UIImagePickerController.SourceType.camera
        mianVC.present(self.imagePicker, animated: true, completion: nil)
    }
    
    /// 选择系统图库
    @objc func selelctPhotoLibrary() -> Void {
        guard let keyWindow = UIApplication.shared.keyWindow, let mianVC = keyWindow.rootViewController else {
            //swiftDebug("获取 根控制器 为空")
            return
        }
        self.imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        mianVC.present(self.imagePicker, animated: true, completion: nil)
    }
    
    /// 选择系统相册
    @objc func selelctSavedPhotosAlbum() -> Void {
        guard let keyWindow = UIApplication.shared.keyWindow, let mianVC = keyWindow.rootViewController else {
            //swiftDebug("获取 根控制器 为空")
            return
        }
        self.imagePicker.sourceType = UIImagePickerController.SourceType.savedPhotosAlbum
        mianVC.present(self.imagePicker, animated: true, completion: nil)
    }
        
}


extension ImagePickerTool: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    /// 获取选择的图片
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        //let mediaType = info[UIImagePickerController.InfoKey.mediaType]
        
        
        
        switch picker.sourceType {
        case UIImagePickerController.SourceType.camera:
            //swiftDebug("返回代理 选择相机")
            // 获取图片
            guard let image = info[UIImagePickerController.InfoKey.originalImage] else {
                //swiftDebug("相册获取照片内容为空")
                return
            }
            
            if let image: UIImage = image as? UIImage {
                // 裁剪大小
                let clipImage = self.clipImage(image: image, size: CGSize(width: 100, height: 100))
                // 质量变换
                let reziseImage = self.convertImage(image: clipImage)
                // 无损压缩
                //let imagess = reziseImage.jpegData(compressionQuality: 0.9)
                //self.selectImageClosure!(image)
                
                if self.selectImageClosure != nil {
                    self.selectImageClosure!(reziseImage)
                }
            }
            break
        case UIImagePickerController.SourceType.savedPhotosAlbum:
            //swiftDebug("返回代理 选择系统相册")
            // 获取图片
            guard let image = info[UIImagePickerController.InfoKey.originalImage] else {
                //swiftDebug("相册获取照片内容为空")
                return
            }
            
            if let image: UIImage = image as? UIImage {
                // 裁剪大小
                let clipImage = self.clipImage(image: image, size: CGSize(width: 100, height: 100))
                // 质量变换
                let reziseImage = self.convertImage(image: clipImage)
                // 无损压缩
                //let imagess = reziseImage.jpegData(compressionQuality: 0.9)
                //self.selectImageClosure!(image)
                
                if self.selectImageClosure != nil {
                    self.selectImageClosure!(reziseImage)
                }
            }
            break
        case UIImagePickerController.SourceType.photoLibrary:
            //swiftDebug("返回代理 选择系统图库")
            // 获取图片
            guard let image = info[UIImagePickerController.InfoKey.originalImage] else {
                //swiftDebug("相册获取照片内容为空")
                return
            }
            
            if let image: UIImage = image as? UIImage {
                // 裁剪大小
                let clipImage = self.clipImage(image: image, size: CGSize(width: 100, height: 100))
                // 质量变换
                let reziseImage = self.convertImage(image: clipImage)
                // 无损压缩
                //let imagess = reziseImage.jpegData(compressionQuality: 0.9)
                //self.selectImageClosure!(image)
                
                if self.selectImageClosure != nil {
                    self.selectImageClosure!(reziseImage)
                }
            }
            break
        default:
            break
        }
        
    }
    
    /// 从相机或相册页面弹出
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    /// 选择照片返回
    @objc func selectPhotoLibrary(callBack: @escaping (UIImage?) -> Void) -> Void {
        //self.chooseImage()
        // 闭包
        self.selectImageClosure = callBack
    }
}


extension ImagePickerTool {
    // MARK: 方向旋转适配
    /// 方向旋转适配
    private func fixOrientation(aImage: UIImage) -> UIImage {
        // No-op if the orientation is already correct
        if aImage.imageOrientation == UIImage.Orientation.up {
            // 照片方向刚好是对的 直接返回
            return aImage
        }
        var transform = CGAffineTransform.identity

        switch aImage.imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: aImage.size.width, y: aImage.size.height)
            transform = transform.rotated(by: CGFloat.pi) // M_PI
            break
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: aImage.size.width, y: 0)
            transform = transform.rotated(by: CGFloat.pi / 2)
            break
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: aImage.size.height)
            transform = transform.rotated(by: -(CGFloat.pi / 2))
            break
        case .up, .upMirrored:

            break
        default:
            break
        }

        switch aImage.imageOrientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: aImage.size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
            break
        case .up, .down, .left, .right:
            break
        default:
            break
        }

        let ctx = CGContext(data: nil, width: Int(aImage.size.width), height: Int(aImage.size.height), bitsPerComponent: aImage.cgImage!.bitsPerComponent, bytesPerRow: 0, space: aImage.cgImage!.colorSpace!, bitmapInfo: (aImage.cgImage?.bitmapInfo)!.rawValue)
        ctx?.concatenate(transform)

        switch aImage.imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            // Grr...
            ctx?.draw(aImage.cgImage!, in: CGRect(x: 0, y: 0, width: aImage.size.height, height: aImage.size.width))
            break
        default:
            ctx?.draw(aImage.cgImage!, in: CGRect(x: 0, y: 0, width: aImage.size.width, height: aImage.size.height))
            break
        }

        let cgimg = ctx?.makeImage()
        let img = UIImage(cgImage: cgimg!)
        // 释放资源
        return img
    }
    
    // MARK: 转换图片质量
    /// 转换图片质量
    private func convertImage(image: UIImage) -> UIImage {
        let mb = 0.002 //1.0 //1MB
        let uploadMB = 0.002 //1.0 //1MB
        var itemMB = 0 // 把文件转成MB
        
        let cgImageRef = image.cgImage
        let bpp = cgImageRef?.bitsPerPixel
        let bpc = cgImageRef?.bitsPerComponent
        let bytes_per_pixel: Int = bpp! / bpc!
        let lPixelsPerMB: CGFloat = CGFloat(mb) / CGFloat(bytes_per_pixel)
        let totalPixel: CGFloat = CGFloat(cgImageRef!.width * cgImageRef!.height)
        
        itemMB = Int(totalPixel / lPixelsPerMB)
        
        if itemMB < Int(uploadMB) {
            // 小于1M
            return image
        } else {
            // 大于1M 压缩到1M
            var toImageSize = CGSize.zero
            
            if image.size.width > image.size.height {
                toImageSize = CGSize(width: 1024, height: 1024 * image.size.height / image.size.width)
            } else if image.size.width < image.size.height {
                toImageSize = CGSize(width: 1024 * image.size.width / image.size.height, height: 1024)
            } else {
                // 1024
                toImageSize = CGSize(width: sqrt(1048576), height: sqrt(1048576))
            }
            
            let toImage = self.resizeImage(image: image, targetSize: toImageSize)
            return toImage
        }
    }
    
    // MARK: 重新设置大小
    /// 重新设置大小
    private func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    /// 从图片中按指定的位置大小截取图片的一部分
    private func imageFrom(image: UIImage, rect: CGRect) -> UIImage {
        // 将UIImage转换成CGImageRef
        let sourceImageRef: CGImage = image.cgImage!
        // 按照给定的矩形区域进行剪裁 CGImageCreateWithImageInRect
        let newImageRef: CGImage = sourceImageRef.cropping(to: rect)!
        // 将CGImageRef转换成UIImage
        let newImage: UIImage = UIImage(cgImage: newImageRef)
        //返回剪裁后的图片
        return newImage
    }
    
    /// 裁剪图片
    private func clipImage(image: UIImage, size: CGSize) -> UIImage {
        let aImage = self.fixOrientation(aImage: image)
        //被切图片宽比例比高比例小 或者相等，以图片宽进行放大
        if aImage.size.width*size.height <= aImage.size.height*size.width {
            // 以被剪裁图片的宽度为基准，得到剪切范围的大小
            let width = aImage.size.width
            let height = aImage.size.width * size.height / size.width
            // 调用剪切方法
            // 这里是以中心位置剪切，也可以通过改变rect的x、y值调整剪切位置
            
            return self.imageFrom(image: aImage, rect: CGRect(x: 0, y: (aImage.size.height-height)/2, width: width, height: height))
        } else {

            // 被切图片宽比例比高比例大，以图片高进行剪裁
            // 以被剪切图片的高度为基准，得到剪切范围的大小
            let width = aImage.size.height * size.width / size.height
            let height = aImage.size.height
            // 调用剪切方法
            // 这里是以中心位置剪切，也可以通过改变rect的x、y值调整剪切位置
            return self.imageFrom(image: aImage, rect: CGRect(x: (aImage.size.width - width)/2, y: 0, width: width, height: height))
        }
    }
}
