//
//  XGStatusViewModel.swift
//  weibo
//
//  Created by monkey on 2019/1/25.
//  Copyright © 2019 itcast. All rights reserved.
//
import UIKit
import SDWebImage

class XGStatusViewModel
{
    // MARK: - 微博属性
    
    /// 文本
    private(set) open var text:String?
    /// 昵称
    private(set) open var screenName:String?
    /// 头像图片地址
    private(set) open var profileImageUrl:String?
    /// 微博id
    private(set) open var id:Int64 = 0
    /// 微博配图模型数组
    private(set) open var picUrls: [XGPictureModel]?
    /// 是否是转发微博
    private(set) open var isRetweetedStatus:Bool
    /// VIP图片
    private(set) open var vipImage:UIImage?
    /// 认证图片
    private(set) open var verifiedImage:UIImage?
    /// 转发数
    private(set) open var repostsCountString:String?
    /// 评论数
    private(set) open var commentsCountString:String?
    /// 点赞数
    private(set) open var attitudesCountString:String?
    /// 配图视图大小
    private(set) open var picturesViewSize:CGSize = CGSize.zero
    /// 转发微博上的文字
    private(set) open var retweetedStatusText:String?
    /// 行高
    private(set) open var rowHeight:CGFloat = 0
    
    /// 头像图片
    open var profileImage:UIImage? {
        return SDWebImageManager.shared().imageCache?.imageFromCache(forKey: profileImageUrl)
    }
    
    /// 微博配图图片数组
    open var pictures:[UIImage?]? {
        if picUrls == nil || picUrls?.count == 0 {
            return nil
        }
        
        var images = [UIImage?]()
        for pictureModel in picUrls! {
            let image = SDWebImageManager.shared().imageCache?.imageFromCache(forKey: pictureModel.thumbnailPic)
            images.append(image)
        }
        
        return (images.count > 0 ? images : nil)
    }
    
    // MARK: - 构造方法
    
    init(model:XGStatusModel)
    {
        // 模型赋值
        statusModel = model
        
        // 文本
        text = statusModel.text
        
        // 昵称
        screenName = statusModel.user?.screenName
        
        // 头像
        profileImageUrl = statusModel.user?.profileImageUrl
        
        // 微博id
        id = statusModel.id
        
        // 配图
        //  测试四张图
        //  if statusModel.picUrls != nil && statusModel.picUrls!.count > 4 {
        //      let startIndex = statusModel.picUrls!.startIndex + 4
        //      let endIndex = statusModel.picUrls!.endIndex
        //      statusModel.picUrls!.removeSubrange(startIndex..<endIndex)
        //      return  statusModel.picUrls
        //}
        
        // 如果是转发微博 返回转发微博图片 否则返回原创微博图片
        picUrls = (statusModel.retweetedStatus != nil ? statusModel.retweetedStatus?.picUrls : statusModel.picUrls)
        
        // 是否是转发微博
        isRetweetedStatus = statusModel.retweetedStatus != nil
        
        // VIP图片
        var mbrank = statusModel.user?.mbrank ?? -1
        if mbrank > 0 {
            mbrank = mbrank > 6 ? 6 : mbrank
            let imageName = "common_icon_membership_level" + String(mbrank)
            vipImage = UIImage(named: imageName)
        }
        
        // 认证图片
        let verifiedType = statusModel.user?.verifiedType ?? -1
        // 认证类型，-1：没有认证，0，认证用户，2,3,5: 企业认证，220: 达人
        switch verifiedType {
        case 0:
            verifiedImage = UIImage(named: "avatar_vip")
        case 2,3,5:
            verifiedImage = UIImage(named: "avatar_enterprise_vip")
        case 220:
            verifiedImage = UIImage(named: "avatar_grassroot")
        default:
            verifiedImage = nil
        }
        
        // 转发数量
        repostsCountString = countString(count: statusModel.repostsCount, defaultString: "转发")
        
        // 评论数量
        commentsCountString = countString(count: statusModel.commentsCount, defaultString: "评论")
        
        // 点赞数量
        attitudesCountString = countString(count: statusModel.attitudesCount, defaultString: "点赞")
        
        // 配图视图大小
        if picUrls == nil || picUrls?.count == 0 {
            // 没有配图
            picturesViewSize = CGSize.zero
        } else {
            // 多少行
            let rows = (picUrls!.count - 1) / kStatusPicturesViewColumns + 1
            let height = CGFloat(rows) * kStatusPicturesViewItemWidth + CGFloat(rows - 1) * kStatusCellPictureInnerMargin + kStatusCellPictureOuterMargin
            picturesViewSize = CGSize(width: kPicturesViewMaxWidth, height: height)
        }
        
        // 转发微博文字
        if statusModel.retweetedStatus != nil {
            var str = "@" + (statusModel.retweetedStatus?.user?.screenName ?? "") + ":"
            str += "  " + (statusModel.retweetedStatus?.text ?? "")
            retweetedStatusText = str
        }
        
        // 行高
        rowHeight = calcRowHeight()
    }
    
    // MARK: - 私有属性
    
    private var statusModel:XGStatusModel
}
// MARK: - 其他方法

extension XGStatusViewModel
{
    /// 根据模型数组返回视图模型数组
    ///
    /// - Parameter statusModelArray: [XGStatusModel]
    /// - Returns: [XGStatusViewModel]
    open class func viewModelArrayWithModelArray(statusModelArray:[XGStatusModel]) -> [XGStatusViewModel]
    {
        var viewModelArray = [XGStatusViewModel]()
        for statusModel in statusModelArray {
            viewModelArray.append(XGStatusViewModel(model: statusModel))
        }
        
        return viewModelArray
    }
    
    // 更新配图视图大小
    open func updatePictureViewSize(imageSize:CGSize) -> Void
    {
        var size = imageSize
        
        let maxWidth:CGFloat = 300
        let minWidth:CGFloat = 40
        let maxHeight:CGFloat = 200
        
        if imageSize.width > maxWidth {
            // 图片过宽处理
            size.height = maxWidth / imageSize.width * imageSize.height
            size.width = maxWidth
        } else if imageSize.width < minWidth {
            // 图片过窄处理
            size.height = minWidth / imageSize.width * imageSize.height
            size.width = minWidth
        }
        
        if size.height > maxHeight {
            // 图片过高处理
            size.height = maxHeight
        }
        
        size.height += kStatusCellPictureOuterMargin
        // 赋值
        picturesViewSize = size
        // 重新计算行高
        rowHeight = calcRowHeight()
    }
    
    /// 根据数字返回字符串
    ///
    /// - Parameters:
    ///   - count: 数字
    ///   - defaultString: 默认字符串
    /// - Returns: String?
    private func countString(count:Int,defaultString:String?)  -> String?
    {
        if count == 0 {
            return defaultString
        } else if count < 10000 {
            return String(count)
        } else {
            // 大于1万
            var format = String(format: "%.2f", CGFloat(count) / 10000.0)
            if format.hasSuffix(".00") {
                // 整数如2.00万 切割成2万
                let location = (format as NSString).range(of: ".00").location
                let toIndex = format.index(format.startIndex, offsetBy: location)
                format = String(format[..<toIndex])
            }  else if format.hasSuffix("0") {
                // 末尾为0 如2.70万 切割成2.7万
                let toIndex = format.index(format.endIndex, offsetBy: -1)
                format = String(format[..<toIndex])
            }
            
            return format + "万"
        }
    }
    
    /// 计算行高
    private func calcRowHeight() -> CGFloat
    {
        let iconWidth:CGFloat = 50 // 顶部视图头像宽高 如果修改了 行高这里也要改
        // 原创 = 分割线(12) + 12间距 + 头像(50) + 12间距 + 正文高度 + 配图高度 + 12间距 + 底部工具栏(44)
        // 转发 = 分割线(12) + 12间距 + 头像(50) + 12间距 + 正文高度 + (12间距 + 3间距 + 转发文字高度) + 配图高度 + 12间距 + 底部工具栏(44)
        
        // 分割线 + 顶部视图高度
        var rowHeight = kStatusCellPictureOuterMargin + kStatusCellPictureOuterMargin + iconWidth + kStatusCellPictureOuterMargin
        
        // 正文高度
        if let text = text {
            rowHeight += (text as NSString).boundingRect(with: CGSize(width: kPicturesViewMaxWidth, height: CGFloat(MAXFLOAT)), options: [.usesLineFragmentOrigin,.usesFontLeading], attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)], context: nil).size.height
        }
        
        // 转发微博
        if statusModel.retweetedStatus != nil {
            rowHeight += kStatusCellPictureOuterMargin + kStatusCellPictureInnerMargin
            if let retweetedStatusText = retweetedStatusText {
                rowHeight += (retweetedStatusText as NSString).boundingRect(with: CGSize(width: kPicturesViewMaxWidth, height: CGFloat(MAXFLOAT)), options: [.usesLineFragmentOrigin,.usesFontLeading], attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)], context: nil).size.height
            }
        }
        
        // 配图
        rowHeight += picturesViewSize.height
        
        // 底部工具栏
        rowHeight += kStatusCellPictureOuterMargin + kToolBarHeight
        // 解决像素不对齐 行高带小数 转换为整数
        rowHeight = ceil(rowHeight)
        return rowHeight
    }
}
