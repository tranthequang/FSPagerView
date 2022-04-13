//
//  FSPagerViewCell.swift
//  FSPagerView
//
//  Created by Wenchao Ding on 17/12/2016.
//  Copyright © 2016 Wenchao Ding. All rights reserved.
//

import UIKit

open class FSPagerViewCell: UICollectionViewCell {
    
    /// Returns the label used for the main textual content of the pager view cell.
    @objc
    open var textLabel: UILabel? {
        if let _ = _textLabel {
            return _textLabel
        }
        let textLabel = UILabel(frame: .zero)
        textLabel.textColor = .white
        textLabel.numberOfLines = 2
        textLabel.font = UIFont.systemFont(ofSize: 32.5, weight: .bold)
        self.contentView.addSubview(textLabel)
        
        textLabel.addObserver(self, forKeyPath: "font", options: [.old,.new], context: kvoContext)
        
        _textLabel = textLabel
        return textLabel
    }
    
    /// Returns the label used for the main textual content of the pager view cell.
    @objc
    open var descLabel: UILabel? {
        if let _ = _descLabel {
            return _descLabel
        }
        let textLabel = UILabel(frame: .zero)
        textLabel.textColor = .white
        textLabel.numberOfLines = 0
        textLabel.font = UIFont.systemFont(ofSize: 16)
        self.contentView.addSubview(textLabel)
        
        textLabel.addObserver(self, forKeyPath: "font", options: [.old,.new], context: kvoContext)
        
        _descLabel = textLabel
        return textLabel
    }
    
    /// Returns the image view of the pager view cell. Default is nil.
    @objc
    open var imageView: UIImageView? {
        if let _ = _imageView {
            return _imageView
        }
        let imageView = UIImageView(frame: .zero)
        self.contentView.addSubview(imageView)
        _imageView = imageView
        return imageView
    }
    
    /// Returns the image view of the pager view cell. Default is nil.
    @objc
    open var shopButton: UIButton? {
        if let _ = _shopButton {
            return _shopButton
        }
        let shopButton = UIButton(type: .custom)
        shopButton.frame = .zero
        shopButton.setTitle("SHOP NOW", for: .normal)
        shopButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        shopButton.backgroundColor = UIColor(red: 1/255, green: 111/255, blue: 52/255, alpha: 1)
        self.contentView.addSubview(shopButton)
        _shopButton = shopButton
        return shopButton
    }
    
    fileprivate weak var _textLabel: UILabel?
    fileprivate weak var _descLabel: UILabel?
    fileprivate weak var _imageView: UIImageView?
    fileprivate weak var _shopButton: UIButton?
    
    fileprivate let kvoContext = UnsafeMutableRawPointer(bitPattern: 0)
    fileprivate let selectionColor = UIColor(white: 0.2, alpha: 0.2)
    var shopPressed: ((Int) -> Void)?
    
    fileprivate weak var _selectedForegroundView: UIView?
    fileprivate var selectedForegroundView: UIView? {
        guard _selectedForegroundView == nil else {
            return _selectedForegroundView
        }
        guard let imageView = _imageView else {
            return nil
        }
        let view = UIView(frame: imageView.bounds)
        imageView.addSubview(view)
        _selectedForegroundView = view
        return view
    }
    
    open override var isHighlighted: Bool {
        set {
            super.isHighlighted = newValue
            if newValue {
                self.selectedForegroundView?.layer.backgroundColor = self.selectionColor.cgColor
            } else if !super.isSelected {
                self.selectedForegroundView?.layer.backgroundColor = UIColor.clear.cgColor
            }
        }
        get {
            return super.isHighlighted
        }
    }
    
    open override var isSelected: Bool {
        set {
            super.isSelected = newValue
            self.selectedForegroundView?.layer.backgroundColor = newValue ? self.selectionColor.cgColor : UIColor.clear.cgColor
        }
        get {
            return super.isSelected
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    fileprivate func commonInit() {
        self.contentView.backgroundColor = UIColor.clear
        self.backgroundColor = UIColor.clear
        self.contentView.layer.shadowColor = UIColor.black.cgColor
        self.contentView.layer.shadowRadius = 5
        self.contentView.layer.shadowOpacity = 0.75
        self.contentView.layer.shadowOffset = .zero
    }
    
    fileprivate func buttonTapped() {
        self.shopPressed?(_shopButton?.tag ?? 0)
    }
    
    deinit {
        if let textLabel = _textLabel {
            textLabel.removeObserver(self, forKeyPath: "font", context: kvoContext)
        }
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        if let imageView = _imageView {
            imageView.frame = self.contentView.bounds
        }
        
        if let shopButton = _shopButton {
            shopButton.frame = CGRect(x: 30, y: self.contentView.bounds.height - 64, width: 107, height: 34)
        }
        
        if let textLabel = _textLabel {
            print("Height of label: \(textLabel.retrieveTextHeight(width: self.contentView.bounds.width - 60))")
            textLabel.frame = CGRect(x: 30, y: 30, width: self.contentView.bounds.width - 60, height: textLabel.retrieveTextHeight(width: self.contentView.bounds.width - 60))
        }
        
        if let descLabel = _descLabel {
            print("Height of desc label: \(descLabel.retrieveTextHeight(width: self.contentView.bounds.width - 60))")
            descLabel.frame = CGRect(x: 30, y: 84 + (_textLabel?.retrieveTextHeight(width: self.contentView.bounds.width - 60) ?? 0), width: self.contentView.bounds.width - 60, height: descLabel.retrieveTextHeight(width: self.contentView.bounds.width - 60))
        }
        if let selectedForegroundView = _selectedForegroundView {
            selectedForegroundView.frame = self.contentView.bounds
        }
    }

    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if context == kvoContext {
            if keyPath == "font" {
                self.setNeedsLayout()
            }
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
}

extension UILabel {

                func retrieveTextHeight(width: CGFloat) -> CGFloat {
        guard let text = self.text, !text.isEmpty else { return 0 }
        let attributedText = NSAttributedString(string: text, attributes: [NSAttributedString.Key.font: self.font])

        let rect = attributedText.boundingRect(with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, context: nil)

        return ceil(rect.size.height)
    }

}
