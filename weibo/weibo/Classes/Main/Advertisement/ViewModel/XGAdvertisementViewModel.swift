//
//  XGAdvertisementViewModel.swift
//  weibo
//
//  Created by monkey on 2019/1/19.
//  Copyright © 2019 itcast. All rights reserved.
//

import UIKit
import SDWebImage

class XGAdvertisementViewModel
{
    // MARK: - 公开方法和属性
    public static let sharedViewModel:XGAdvertisementViewModel = XGAdvertisementViewModel()
    
    /// 广告图片
    public var advertisementImage:UIImage? {
        if advertisementModel != nil {
            let data = try! Data(contentsOf: URL(fileURLWithPath: imageCachePath))
            return UIImage(data: data)
        } else {
            return nil
        }
    }
    
    /// 广告详情
    public var webURL:URL? {
        if advertisementModel != nil {
            return URL(string: advertisementModel?.webURL ?? "")
        } else {
            return nil
        }
    }
    
    /// 是否需要展示广告
    public var isNeedShowAdvertisement:Bool {
        if advertisementModel != nil {
            loadData()
            return true
        } else {
            loadData()
            return false
        }
    }
    
    // MARK: - 私有属性
    /// 广告模型数据
    private var advertisementModel:XGAdvertisementModel?
    /// 图片缓存路径
    private lazy var imageCachePath:String = {
        let cachePath =  NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
        return (cachePath as NSString).appendingPathComponent("Advertisement.png")
    }()
    /// 模型缓存路径
    private lazy var modelCachePath:String = {
        let cachePath =  NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
       return (cachePath as NSString).appendingPathComponent("XGAdvertisement.plist")
    }()
    
    // MARK: - 构造方法
    private init()
    {
        advertisementModel = NSKeyedUnarchiver.unarchiveObject(withFile: modelCachePath) as? XGAdvertisementModel
    }
}

// MARK: - 下载图片
extension XGAdvertisementViewModel
{
    /// 加载广告页数据
    private func loadData() -> Void
    {
        XGDataManager.loadAdvertisementData { (advertisementModel, error) in
            if error != nil {
                XGPrint("广告图片下载失败")
                return
            }
            
            if self.advertisementModel?.pictureImageURL?.compare(advertisementModel!.pictureImageURL ?? "") ==  ComparisonResult.orderedSame {
                // 图片已经存在
                return
            } else {
                // 记录模型
                self.advertisementModel = advertisementModel!
                // 保存模型
                NSKeyedArchiver.archiveRootObject(advertisementModel!, toFile: self.modelCachePath)
                // 下载图片
                self.downloadImage()
            }
        }
    }
    
    /// 下载广告图片
    private func downloadImage() -> Void
    {
        SDWebImageManager.shared().loadImage(with: URL(string: advertisementModel?.pictureImageURL ?? ""), options: [], progress: nil) { (image, data, error, _, _, _) in
            if error != nil {
                XGPrint("广告图片下载失败")
                return
            }
            
            // 广告图片下载成功 保存广告图片到沙盒中 如果已经存在旧图片 先删除旧图片 然后保存新图片
            if FileManager.default.fileExists(atPath: self.imageCachePath) {
                try? FileManager.default.removeItem(atPath: self.imageCachePath)
            }
            
            try? data!.write(to: URL(fileURLWithPath: self.imageCachePath))
        }
    }
    
    open func demo() -> Void
    {
        
    }
}

