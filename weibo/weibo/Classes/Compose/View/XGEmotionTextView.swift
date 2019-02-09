//
//  XGTextView.swift
//  04-UITextView封装
//
//  Created by monkey on 2019/2/3.
//  Copyright © 2019 itcast. All rights reserved.
//

import UIKit

class XGEmotionTextView: UITextView
{
    /// 占位字符串
    open var placeholder:String? {
        didSet {
            placeholderLabel.text = placeholder
            placeholderLabel.sizeToFit()
        }
    }
    
    /// 插入表情
    ///
    /// - Parameter emotionModel: 表情模型
    open func insertEmotionModel(emotionModel:XGEmotionModel?) -> Void
    {
        if emotionModel == nil {
            // 删除
            deleteBackward()
        } else {
            // 表情图片
            let emotionTextM = NSMutableAttributedString(attributedString: attributedText)
            let range = selectedRange
            if let emotionText = emotionModel?.emotionText(fontSize: font?.pointSize ?? 0) {
                // 插入表情属性字符串
                emotionTextM.replaceCharacters(in: range, with: emotionText)
            }
           // 设置属性
            emotionTextM.addAttributes([NSAttributedString.Key.foregroundColor:textColor!,NSAttributedString.Key.font:font!], range: NSRange(location: 0, length: emotionTextM.length))
            // 替换
            attributedText = emotionTextM.copy() as? NSAttributedString
            // 重设光标
            selectedRange = NSRange(location: range.location + 1, length: 0)
            // 默认插入表情不会触发文本改变 手动调用
            textDidChangeAction()
        }
    }
    
    /// 返回文本视图内的字符串内容
    ///
    /// - Returns: String
    open func textValue() -> String
    {
        var strValue = ""
        attributedText.enumerateAttributes(in: NSRange(location: 0, length: attributedText.length), options: []) { (attributedText, range, _) in
            if let attachment = attributedText[NSAttributedString.Key.attachment] as? XGEmotionTextAttachment {
                // 表情
                strValue += (attachment.emotionValue ?? "")
            } else {
                // 文本内容
                strValue += (self.attributedText.string as NSString).substring(with: range)
            }
        }
        
        return strValue
    }
    
    // MARK: - 构造方法
    
    override init(frame: CGRect, textContainer: NSTextContainer?)
    {
        super.init(frame: frame, textContainer: textContainer)
        
        setUpUI()
        registerNotification()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        setUpUI()
        registerNotification()
    }
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        placeholderLabel.isHidden = hasText
    }
    
    deinit {
        // 注销通知
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - 懒加载
    
    /// 占位文本
    private lazy var placeholderLabel:UILabel = { [weak self] in
        let label = UILabel()
        label.text = "请输入内容..."
        let font = (self?.font == nil ? UIFont.systemFont(ofSize: 12) : self?.font)
        label.font = font
        label.textColor = UIColor.lightGray
        sizeToFit()
        return label
    }()
}

// MARK: - 其他方法

extension XGEmotionTextView
{
    /// textView文本改变通知监听方法
    @objc private func textDidChangeAction() -> Void
    {
        // textView有文字时隐藏
        placeholderLabel.isHidden = hasText
    }
    
    /// 字体
    override var font: UIFont? {
        didSet {
            placeholderLabel.font = font
            placeholderLabel.sizeToFit()
        }
    }
    
    /// 文本内容
    override var text: String! {
        didSet {
            placeholderLabel.isHidden = hasText
        }
    }
    
    /// 注册通知
    private func registerNotification() -> Void
    {
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChangeAction), name: UITextView.textDidChangeNotification, object: nil)
    }
    
    /// 设置界面
    private func setUpUI() -> Void
    {
        // 初始化操作
        alwaysBounceVertical = true
        keyboardDismissMode = .onDrag
        
        // 添加子控件
        addSubview(placeholderLabel)
        
        // 设置自动布局
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addConstraint(NSLayoutConstraint(item: placeholderLabel, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 8))
        addConstraint(NSLayoutConstraint(item: placeholderLabel, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 5))
    }
}
