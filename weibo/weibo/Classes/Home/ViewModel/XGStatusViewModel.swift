//
//  XGStatusViewModel.swift
//  weibo
//
//  Created by monkey on 2019/1/25.
//  Copyright © 2019 itcast. All rights reserved.
//
import UIKit

class XGStatusViewModel
{
    // MARK: - 开放方法
    
    /// 文本
    open var text:String? {
        return statusModel.text
    }
    /// 昵称
    open var screenName:String? {
        return statusModel.user?.screenName
    }
    /// 头像图片
    open var profileImage:UIImage?
    /// 头像图片地址
    open var profileImageUrl:String? {
        return statusModel.user?.profileImageUrl
    }
    
    /// 微博id
    open var id:Int64 {
        return statusModel.id
    }
    
    /// VIP图片
    open lazy var vipImage:UIImage? = {
        let mbrank = statusModel.user?.mbrank ?? -1
        if mbrank <= 0 || mbrank > 6 {
            return nil
        } else {
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
    var repostsCount:Int {
        return statusModel.repostsCount
    }
    /// 评论数
    var commentsCount:Int {
        return statusModel.commentsCount
    }
    /// 点赞数
    var attitudesCount:Int {
        return statusModel.attitudesCount
    }
    /// 微博配图模型数组
    var picUrls: [XGPictureModel]? {
        return statusModel.picUrls
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
