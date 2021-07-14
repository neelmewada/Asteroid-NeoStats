//
//  UIViewExtensions.swift
//  Progress Tracker
//
//  Created by Neel Mewada on 23/06/21.
//

import UIKit

// MARK: - UIView

extension UIView {
    
    /// Returns the original frame by removing the transform and applying it back again.
    var originalFrame: CGRect {
        let origTransform = self.transform
        self.transform = .identity
        let origFrame = self.frame
        self.transform = origTransform
        return origFrame
    }
    
    var isVisible: Bool {
        get { return !isHidden }
        set { isHidden = !newValue }
    }
    
    @discardableResult
    func constraints(top: NSLayoutYAxisAnchor? = nil,
                     left: NSLayoutXAxisAnchor? = nil,
                     bottom: NSLayoutYAxisAnchor? = nil,
                     right: NSLayoutXAxisAnchor? = nil,
                     spacingTop: CGFloat = 0,
                     spacingLeft: CGFloat = 0,
                     spacingBottom: CGFloat = 0,
                     spacingRight: CGFloat = 0,
                     width: CGFloat? = nil,
                     height: CGFloat? = nil,
                     centerXIn centerXView: UIView? = nil,
                     spacingCenterX: CGFloat = 0,
                     centerYIn centerYView: UIView? = nil,
                     spacingCenterY: CGFloat = 0,
                     activate: Bool = true) -> [NSLayoutConstraint] {
        
        translatesAutoresizingMaskIntoConstraints = false
        var constraints = [NSLayoutConstraint]()
        
        if let top = top {
            constraints.append(topAnchor.constraint(equalTo: top, constant: spacingTop))
        }
        
        if let left = left {
            constraints.append(leftAnchor.constraint(equalTo: left, constant: spacingLeft))
        }
        
        if let bottom = bottom {
            constraints.append(bottomAnchor.constraint(equalTo: bottom, constant: -spacingBottom))
        }
        
        if let right = right {
            constraints.append(rightAnchor.constraint(equalTo: right, constant: -spacingRight))
        }
        
        if let width = width {
            constraints.append(widthAnchor.constraint(equalToConstant: width))
        }
        
        if let height = height {
            constraints.append(heightAnchor.constraint(equalToConstant: height))
        }
        
        if let centerXView = centerXView {
            constraints.append(centerXAnchor.constraint(equalTo: centerXView.centerXAnchor, constant: spacingCenterX))
        }
        
        if let centerYView = centerYView {
            constraints.append(centerYAnchor.constraint(equalTo: centerYView.centerYAnchor, constant: spacingCenterY))
        }
        
        if activate {
            NSLayoutConstraint.activate(constraints)
        }
        
        return constraints
    }
    
    /// Centers `this` view in it's superview.
    func centerInSuperview() {
        translatesAutoresizingMaskIntoConstraints = false
        if let superview = superview {
            center(inView: superview)
        }
    }
    
    /// Center the view horizontally and vertically with an optional vertical offset with respect to `inView`
    func center(inView view: UIView, xConstant: CGFloat = 0, yConstant: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: xConstant).isActive = true
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: yConstant).isActive = true
    }
    
    /// Center the view horizontally with respect to `inView`
    func centerX(inView view: UIView, topAnchor: NSLayoutYAxisAnchor? = nil, spacingTop: CGFloat? = 0, constant: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: constant).isActive = true
        
        if let topAnchor = topAnchor {
            self.topAnchor.constraint(equalTo: topAnchor, constant: spacingTop!).isActive = true
        }
    }
    
    /// Center the view vertically with respect to `inView`
    func centerY(inView view: UIView, leftAnchor: NSLayoutXAxisAnchor? = nil,
                 spacingLeft: CGFloat = 0, constant: CGFloat = 0) {
        
        translatesAutoresizingMaskIntoConstraints = false
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: constant).isActive = true
        
        if let left = leftAnchor {
            constraints(left: left, spacingLeft: spacingLeft)
        }
    }
    
    /// Set width and height constraints
    func setDimensions(height: CGFloat, width: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: height).isActive = true
        widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    
    func setHeight(minHeight: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(greaterThanOrEqualToConstant: minHeight).isActive = true
    }
    
    func setHeight(maxHeight: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(lessThanOrEqualToConstant: maxHeight).isActive = true
    }
    
    func setHeight(height: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
    func setWidth(minWidth: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(greaterThanOrEqualToConstant: minWidth).isActive = true
    }
    
    func setWidth(maxWidth: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(lessThanOrEqualToConstant: maxWidth).isActive = true
    }
    
    func setWidth(width: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    
    /// Make this view fill the entire superview perfectly. It modifies top, left, bottom and right anchor constraints.
    func fillSuperview() {
        translatesAutoresizingMaskIntoConstraints = false
        guard let view = superview else { return }
        constraints(top: view.topAnchor, left: view.leftAnchor,
                    bottom: view.bottomAnchor, right: view.rightAnchor)
    }
    
    /// Make this view fill the entire superview according to the safeAreaLayoutGuide. It modifies top, left, bottom and right anchor constraints.
    func fillSuperviewSafe() {
        translatesAutoresizingMaskIntoConstraints = false
        guard let view = superview else { return }
        constraints(top: view.safeAreaLayoutGuide.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor,
                    bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.safeAreaLayoutGuide.rightAnchor)
    }
}
