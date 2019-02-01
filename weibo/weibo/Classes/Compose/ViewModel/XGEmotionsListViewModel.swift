//
//  XGEmotionsListViewModel.swift
//  weibo
//
//  Created by monkey on 2019/2/1.
//  Copyright © 2019 itcast. All rights reserved.
//

import UIKit
import SDWebImage

class XGEmotionsListViewModel
{
    /// 表情分组模型
    private(set) open var emotionsGroupList:[XGEmotionGroupModel] = [XGEmotionGroupModel]()
}

// MARK: - 加载数据

extension XGEmotionsListViewModel
{
    /// 获取微博官方表情的详细信息
    ///
    /// - Parameter completion: 完成回调
    open func loadEmotionsList(completion:@escaping (Bool) -> Void) -> Void
    {
        XGDataManager.loadEmotionsList { (dataArray, error) in
            if error != nil || dataArray == nil {
                completion(false)
                return
            } else {
                // 缓存表情图片
                self.cacheEmoticonImage(emotionsList: dataArray ?? [], completion: completion)
            }
        }
    }
    
    private func cacheEmoticonImage(emotionsList:[XGEmotionModel],completion:@escaping (Bool) -> Void) -> Void
    {
        // 调度组
        let group = DispatchGroup()
        
        for emoticonModel in emotionsList {
           
            // 如果没有图片才进行下载
            if SDWebImageManager.shared().imageCache?.diskImageDataExists(withKey: emoticonModel.icon) == false {
                group.enter()
                SDWebImageManager.shared().loadImage(with: URL(string: emoticonModel.icon ?? ""), options: [.refreshCached,.retryFailed], progress: nil) { (image, _, error, _, _, _) in
                    group.leave()
                    if error != nil {
                        XGPrint("表情图片缓存失败!")
                        return
                    }
                }
            }
        }

        // 所有表情图片下载完毕
        group.notify(queue: DispatchQueue.main) {
            XGPrint("表情图片缓存完毕")
            // 筛选出分组
            var categoryGroup:[String] = [String]()
            for emotionModel in emotionsList {
                let category = emotionModel.category ?? ""
                !categoryGroup.contains(category) ? categoryGroup.append(category) : ()
            }
            
            // 将模型归入不同的分组
            for category in categoryGroup {
                let emotions = emotionsList.filter({ (emotionModel) -> Bool in
                    emotionModel.category?.compare(category) ==  ComparisonResult.orderedSame
                })
                
                self.emotionsGroupList.append(XGEmotionGroupModel(category: category, emotions: emotions))
            }
            
            completion(true)
        }
    }
}
