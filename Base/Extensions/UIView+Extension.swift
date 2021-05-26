

//
//  UIView+Extension.swift
//  SwiftReLearn
//
//  Created by runlong on 2021/5/24.
//  Copyright © 2021 JoyTomi. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    // MARK: - 尺寸相关
    var tm_x:CGFloat{
        get{
            return self.frame.origin.x
        } set{
            self.frame.origin.x = newValue
        }
    }
    
    var tm_y:CGFloat{
        get{
            return self.frame.origin.y
        }set{
            self.frame.origin.y = newValue
        }
    }
    
    var tm_width:CGFloat{
        get{
            return self.frame.size.width
        }set{
            self.frame.size.width = newValue
        }
    }
    
    var tm_height:CGFloat{
        get{
            return self.frame.size.height
        }set{
            self.frame.size.height = newValue
        }
    }
    
    var tm_size:CGSize{
        get{
            return self.frame.size
        }
        set{
            self.frame.size = newValue
        }
    }
    var tm_centerX:CGFloat{
        get{
            return self.center.x
        }
        
    }
    var tm_centerY:CGFloat{
        get{
            return self.center.y
        }
    }
    // MARK: - 尺寸裁剪相关
    /// 添加圆角  radius: 圆角半径
    func tm_addRounded(radius:CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    
    /// 切圆
    func tm_cutRoundImageView() {
        let radius = self.frame.size.width / 2;
        tm_addRounded(radius: radius, corners: .allCorners)
    }
    
    /// 添加部分圆角(有问题右边且不了) corners: 需要实现为圆角的角，可传入多个 radius: 圆角半径
    func tm_addRounded(radius:CGFloat, corners: UIRectCorner) {
        let maskPath = UIBezierPath.init(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize.init(width: radius, height: radius))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer;
    }
    
    // MARK: - 添加边框
    /// 添加边框 width: 边框宽度 默认黑色
    func tm_addBorder(width : CGFloat) { // 黑框
        self.layer.borderWidth = width;
        self.layer.borderColor = UIColor.black.cgColor;
    }
    /// 添加边框 width: 边框宽度 borderColor:边框颜色
    func tm_addBorder(width : CGFloat, borderColor : UIColor) { // 颜色自己给
        self.layer.borderWidth = width;
        self.layer.borderColor = borderColor.cgColor;
    }
    /// 添加圆角和阴影
    func tm_addRoundedOrShadow(radius:CGFloat)  {
        self.layer.cornerRadius = radius
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.1 // 不透明度
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 1
        self.layer.masksToBounds = false
    }
    
    /// UIView 转 UIImage
    func tm_imageFromView() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
extension UIView {
    
    private struct AssociatedKeys {
        static var descriptiveName = "AssociatedKeys.DescriptiveName.blurView"
    }
    
    private (set) var tm_blurView: BlurView {
        get {
            if let tm_blurView = objc_getAssociatedObject(
                self,
                &AssociatedKeys.descriptiveName
                ) as? BlurView {
                return tm_blurView
            }
            self.tm_blurView = BlurView(to: self)
            return self.tm_blurView
        }
        set(tm_blurView) {
            objc_setAssociatedObject(
                self,
                &AssociatedKeys.descriptiveName,
                tm_blurView,
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
    }
    
    class BlurView {
        
        private var superview: UIView
        private var blur: UIVisualEffectView?
        private var editing: Bool = false
        private (set) var blurContentView: UIView?
        private (set) var vibrancyContentView: UIView?
        
        var animationDuration: TimeInterval = 0.1
        
        /**
         * Blur style. After it is changed all subviews on
         * blurContentView & vibrancyContentView will be deleted.
         */
        var style: UIBlurEffect.Style = .light {
            didSet {
                guard oldValue != style,
                    !editing else { return }
                tm_applyBlurEffect()
            }
        }
        /**
         * Alpha component of view. It can be changed freely.
         */
        var alpha: CGFloat = 0 {
            didSet {
                guard !editing else { return }
                if blur == nil {
                    tm_applyBlurEffect()
                }
                let alpha = self.alpha
                UIView.animate(withDuration: animationDuration) {
                    self.blur?.alpha = alpha
                }
            }
        }
        
        init(to view: UIView) {
            self.superview = view
        }
        
        func setup(style: UIBlurEffect.Style, alpha: CGFloat) -> Self {
            self.editing = true
            
            self.style = style
            self.alpha = alpha
            
            self.editing = false
            
            return self
        }
        
        func enable(isHidden: Bool = false) {
            if blur == nil {
                tm_applyBlurEffect()
            }
            
            self.blur?.isHidden = isHidden
        }
        
        private func tm_applyBlurEffect() {
            blur?.removeFromSuperview()
            
            tm_applyBlurEffect(
                style: style,
                blurAlpha: alpha
            )
        }
        
        private func tm_applyBlurEffect(style: UIBlurEffect.Style,
                                        blurAlpha: CGFloat) {
            superview.backgroundColor = UIColor.clear
            
            let blurEffect = UIBlurEffect(style: style)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            
            let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
            let vibrancyView = UIVisualEffectView(effect: vibrancyEffect)
            blurEffectView.contentView.addSubview(vibrancyView)
            
            blurEffectView.alpha = blurAlpha
            
            superview.insertSubview(blurEffectView, at: 0)
            
            blurEffectView.tm_addAlignedConstrains()
            vibrancyView.tm_addAlignedConstrains()
            
            self.blur = blurEffectView
            self.blurContentView = blurEffectView.contentView
            self.vibrancyContentView = vibrancyView.contentView
        }
    }
    
    private func tm_addAlignedConstrains() {
        translatesAutoresizingMaskIntoConstraints = false
        tm_addAlignConstraintToSuperview(attribute: NSLayoutConstraint.Attribute.top)
        tm_addAlignConstraintToSuperview(attribute: NSLayoutConstraint.Attribute.leading)
        tm_addAlignConstraintToSuperview(attribute: NSLayoutConstraint.Attribute.trailing)
        tm_addAlignConstraintToSuperview(attribute: NSLayoutConstraint.Attribute.bottom)
    }
    
    private func tm_addAlignConstraintToSuperview(attribute: NSLayoutConstraint.Attribute) {
        superview?.addConstraint(
            NSLayoutConstraint(
                item: self,
                attribute: attribute,
                relatedBy: NSLayoutConstraint.Relation.equal,
                toItem: superview,
                attribute: attribute,
                multiplier: 1,
                constant: 0
            )
        )
    }
    
    
    /** 切割UIView、UIButton和UILabel圆角
     * @param view 需要进行切割的对象
     * @param direction 切割的方向
     * @param cornerRadii 圆角半径
     * @param borderWidth 边框宽度
     * @param borderColor 边框颜色
     * @param backgroundColor 背景色
     */
    public class func cuttingView(view: UIView, direction: UIRectCorner, cornerRadii: CGFloat, borderWidth: CGFloat, borderColor: UIColor, backgroundColor: UIColor)
    {
        var cornerRadii = cornerRadii
        if view.bounds.size.height != 0 && view.bounds.size.width != 0 {// 使用Masonry布局后，view的bounds是异步返回的，这里需要做初步的判断
            let width = view.bounds.size.width
            let height = view.bounds.size.height
            
            // 先利用CoreGraphics绘制一个圆角矩形
            UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, UIScreen.main.scale)
            let currentContext = UIGraphicsGetCurrentContext()
            
            if (currentContext != nil) {
                currentContext?.setFillColor(backgroundColor.cgColor)// 设置填充颜色
                currentContext?.setStrokeColor(borderColor.cgColor)// 设置画笔颜色
                
                if cornerRadii == 0 {
                    cornerRadii = view.bounds.size.height / 2
                }
                // 单切圆角
                if direction == UIRectCorner.allCorners {
                    currentContext?.move(to: CGPoint.init(x: width - borderWidth, y: cornerRadii + borderWidth))// 从右下开始
                    currentContext?.addArc(tangent1End: CGPoint.init(x: width - borderWidth, y: height - borderWidth), tangent2End: CGPoint.init(x: width - cornerRadii - borderWidth, y: height - borderWidth), radius: cornerRadii)
                    currentContext?.addArc(tangent1End: CGPoint.init(x: borderWidth, y: height - borderWidth), tangent2End: CGPoint.init(x: borderWidth, y: height - cornerRadii - borderWidth), radius: cornerRadii)
                    currentContext?.addArc(tangent1End: CGPoint.init(x: borderWidth, y: borderWidth), tangent2End: CGPoint.init(x: width - borderWidth, y: borderWidth), radius: cornerRadii)
                    currentContext?.addArc(tangent1End: CGPoint.init(x: width - borderWidth, y: borderWidth), tangent2End: CGPoint.init(x: width - borderWidth, y:  cornerRadii + borderWidth), radius: cornerRadii)
                    
                } else {
                    currentContext?.move(to: CGPoint.init(x: cornerRadii + borderWidth, y: borderWidth))// 从左上开始
                    if direction.contains(UIRectCorner.topLeft) {
                        currentContext?.addArc(tangent1End: CGPoint.init(x: borderWidth, y: borderWidth), tangent2End: CGPoint.init(x: borderWidth, y: cornerRadii + borderWidth), radius: cornerRadii)
                    } else {
                        currentContext?.addLine(to: CGPoint.init(x: borderWidth, y: borderWidth))
                    }
                    if direction.contains(UIRectCorner.bottomLeft) {
                        currentContext?.addArc(tangent1End: CGPoint.init(x: borderWidth, y: height - borderWidth), tangent2End: CGPoint.init(x: borderWidth + cornerRadii, y: height - borderWidth), radius: cornerRadii)
                    } else {
                        currentContext?.addLine(to: CGPoint.init(x: borderWidth, y: height - borderWidth))
                    }
                    if direction.contains(UIRectCorner.bottomRight) {
                        currentContext?.addArc(tangent1End: CGPoint.init(x: width - borderWidth, y: height - borderWidth), tangent2End: CGPoint.init(x: width - borderWidth, y: height - borderWidth - cornerRadii), radius: cornerRadii)
                    } else {
                        currentContext?.addLine(to: CGPoint.init(x: width - borderWidth, y: height - borderWidth))
                    }
                    if direction.contains(UIRectCorner.topRight) {
                        currentContext?.addArc(tangent1End: CGPoint.init(x: width - borderWidth, y: borderWidth), tangent2End: CGPoint.init(x: width - borderWidth - cornerRadii, y: borderWidth), radius: cornerRadii)
                    } else {
                        currentContext?.addLine(to: CGPoint.init(x: width - borderWidth, y: borderWidth))
                    }
                    currentContext?.addLine(to: CGPoint.init(x: borderWidth + cornerRadii, y: borderWidth))
                    
                }
                currentContext?.drawPath(using: .fillStroke)
                let image = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                
                // 绘制完成后，将UIImageView插入到view视图层级的底部
                if (image?.isKind(of: UIImage.self))! {
                    let baseImageView = UIImageView.init(image: image)
                    view.insertSubview(baseImageView, at: 0)
                }
            }
        } else {// 如果没有获取到view的bounds时
            DispatchQueue.main.async {
                self.cuttingView(view: view, direction: direction, cornerRadii: cornerRadii, borderWidth: borderWidth, borderColor: borderColor, backgroundColor: backgroundColor)
            }
        }
    }
    
    /** 切割UIImageView圆角
     * @param imageView 需要进行切割的对象
     * @param direction 切割的方向
     * @param cornerRadii 圆角半径
     * @param borderWidth 边框宽度
     * @param borderColor 边框颜色
     * @param backgroundColor 背景色
     */
    public class func cuttingImageView(imageView: UIImageView, direction: UIRectCorner, cornerRadii: CGFloat, borderWidth: CGFloat, borderColor: UIColor, backgroundColor: UIColor)
    {
        var cornerRadii = cornerRadii
        if imageView.bounds.size.height != 0 && imageView.bounds.size.width != 0 {
            // 先截取UIImageView视图Layer生成的Image，然后再做渲染
            var image : UIImage? = nil
            if (imageView.image != nil) {
                image = imageView.image
            } else {
                DispatchQueue.main.async {
                    self.cuttingImageView(imageView: imageView, direction: direction, cornerRadii: cornerRadii, borderWidth: borderWidth, borderColor: borderColor, backgroundColor: backgroundColor)
                }
            }
            
            if cornerRadii == 0 {
                cornerRadii = imageView.bounds.size.height / 2
            }
            let rect = CGRect.init(origin: CGPoint.init(x: 0, y: 0), size: CGSize.init(width: imageView.bounds.size.width, height: imageView.bounds.size.height))
            UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.main.scale)
            let currentContext = UIGraphicsGetCurrentContext()
            if (currentContext != nil) {
                let path = UIBezierPath.init(roundedRect: rect, byRoundingCorners: direction, cornerRadii: CGSize.init(width: cornerRadii - borderWidth, height: cornerRadii - borderWidth))
                currentContext?.addPath(path.cgPath)
                currentContext?.clip()
                
                image?.draw(in: rect)
                borderColor.setStroke()// 画笔颜色
                backgroundColor.setFill()// 填充颜色
                path.stroke()
                path.fill()
                image = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
            }
            if (image?.isKind(of: UIImage.self))! {
                imageView.image = image
            } else {// UITableViewCell的UIImageView，第一次创建赋图时，可能无法获取UIImageView视图layer的图片
                DispatchQueue.main.async {
                    self.cuttingImageView(imageView: imageView, direction: direction, cornerRadii: cornerRadii, borderWidth: borderWidth, borderColor: borderColor, backgroundColor: backgroundColor)
                }
            }
        } else {
            DispatchQueue.main.async {
                self.cuttingImageView(imageView: imageView, direction: direction, cornerRadii: cornerRadii, borderWidth: borderWidth, borderColor: borderColor, backgroundColor: backgroundColor)
            }
            
        }
        
    }
    
    //MARK: 添加渐变色
       /// 添加渐变色
       class func addGradientRamp(rect: CGRect, colors: [Any], with view: UIView) {
           let gradient = CAGradientLayer()
           gradient.bounds = rect
           gradient.startPoint = CGPoint(x: 0, y: 0)
           gradient.endPoint = CGPoint(x: 1, y: 0)
           gradient.anchorPoint = CGPoint(x: 0, y: 0)
           gradient.colors = colors
           view.layer.addSublayer(gradient)
       }
       
       class func addGradientRamp(rect: CGRect, colors: [Any],startPotint:CGPoint,endPoint:CGPoint,locations:[NSNumber],with view: UIView) {
           let gradient = CAGradientLayer()
           gradient.bounds = rect
           gradient.startPoint = startPotint
           gradient.endPoint = endPoint
           gradient.anchorPoint = CGPoint(x: 0, y: 0)
           gradient.colors = colors
           gradient.locations = locations
           view.layer.addSublayer(gradient)
       }
    
    
    //MARK: 添加毛玻璃效果
    func addBlurEffect(style:UIBlurEffect.Style,alpha:CGFloat) {
        let effect = UIBlurEffect(style: style)
        let effectView = UIVisualEffectView(effect: effect)
        effectView.alpha = alpha
        self.addSubview(effectView)
        self.layoutIfNeeded()
        effectView.frame = self.bounds
//        //添加约束
//        effectView.snp.makeConstraints { (make) in
//            make.edges.equalTo(self)
//        }
    }
}
