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
    // MARK: - 微博属性 不需要计算
    
    /// 文本
    open var text:String? {
        return statusModel.text
    }
    
    /// 昵称
    open var screenName:String? {
        return statusModel.user?.screenName
    }
    
    /// 头像图片地址
    open var profileImageUrl:String? {
        return statusModel.user?.profileImageUrl
    }
    
    /// 微博id
    open var id:Int64 {
        return statusModel.id
    }
    
    /// 头像图片
    open var profileImage:UIImage? {
        return SDWebImageManager.shared().imageCache?.imageFromCache(forKey: profileImageUrl)
    }
    
    /// 微博配图模型数组
    open var picUrls: [XGPictureModel]? {
        //         测试四张图
        //        if statusModel.picUrls != nil && statusModel.picUrls!.count > 4 {
        //            let startIndex = statusModel.picUrls!.startIndex + 4
        //            let endIndex = statusModel.picUrls!.endIndex
        //            statusModel.picUrls!.removeSubrange(startIndex..<endIndex)
        //            return  statusModel.picUrls
        //        }
        
        // 如果是转发微博 返回转发微博图片 否则返回原创微博图片
        return (statusModel.retweetedStatus != nil ? statusModel.retweetedStatus?.picUrls : statusModel.picUrls)
    }
    
    /// 微博配图图片数组
    open var pictures:[UIImage]? {
        if picUrls == nil || picUrls?.count == 0 {
            return nil
        }
        
        var images = [UIImage]()
        for pictureModel in picUrls! {
            let image = SDWebImageManager.shared().imageCache?.imageFromCache(forKey: pictureModel.thumbnailPic)
            image != nil ? images.append(image!) : ()
        }
        
        return (images.count > 0 ? images : nil)
    }
    
    /// 是否是转发微博
    open var isRetweetedStatus:Bool {
        return statusModel.retweetedStatus != nil
    }
    
     // MARK: - 微博属性 需要计算
    
    /// VIP图片
    open lazy var vipImage:UIImage? = {
        var mbrank = statusModel.user?.mbrank ?? -1
        if mbrank <= 0 {
            return nil
        } else {
            mbrank = mbrank > 6 ? 6 : mbrank
            let imageName = "common_icon_membership_level" + String(mbrank)
            return UIImage(named: imageName)
        }
    }()
    
    /// 认证图片
    open lazy var verifiedImage:UIImage? = {
        let verifiedType = statusModel.user?.verifiedType ?? -1
        // 认证类型，-1：没有认证，0，认证用户，2,3,5: 企业认证，220: 达人
        switch verifiedType {
        case 0:
            return UIImage(named: "avatar_vip")
        case 2,3,5:
            return UIImage(named: "avatar_enterprise_vip")
        case 220:
            return UIImage(named: "avatar_grassroot")
        default:
            return nil
        }
    }()
    
    /// 转发数
    open lazy var repostsCountString:String? = {
        return countString(count: statusModel.repostsCount, defaultString: "转发")
    }()
    
    /// 评论数
    open lazy var commentsCountString:String? = {
         return countString(count: statusModel.commentsCount, defaultString: "评论")
    }()
    
    /// 点赞数
    open lazy var attitudesCountString:String? = {
         return countString(count: statusModel.attitudesCount, defaultString: "点赞")
    }()

    
    /// 配图视图高度
    open lazy var picturesViewHeight:CGFloat = {
        if picUrls == nil || picUrls?.count == 0 {
            // 没有配图
            return 0
        } else {
            // 多少行
            let rows = (picUrls!.count - 1) / kStatusPicturesViewColumns + 1
            return CGFloat(rows) * kStatusPicturesViewItemWidth + CGFloat(rows - 1) * kStatusCellPictureInnerMargin + kStatusCellPictureOuterMargin
        }
    }()
    
    /// 转发微博上的文字
    open lazy var retweetedStatusText:String? = {
        if statusModel.retweetedStatus == nil {
            return nil
        } else {
            var str = "@" + (statusModel.retweetedStatus?.user?.screenName ?? "") + ":"
            str += "  " + (statusModel.retweetedStatus?.text ?? "")
            return str
        }
    }()
    
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
    
    // MARK: - 构造方法
    
    init(model:XGStatusModel)
    {
        statusModel = model
    }
    
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
    
    // MARK: - 私有属性
    
    private var statusModel:XGStatusModel
}
