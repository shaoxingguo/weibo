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
    
    // MARK: - 单例
    
    public static var shared:XGEmotionsListViewModel = XGEmotionsListViewModel()
    private init() {}
    /// 最近分组表情缓存路径
    private lazy var recentEmotionsCachePath:String = {
        let document = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
        return (document as NSString).appendingPathComponent("recentEmotions.plist")
    }()
}

// MARK: - 公开方法

extension XGEmotionsListViewModel
{
    /// 将带表情的字符串转换为属性字符串
    ///
    /// - Parameters:
    ///   - text: 源字符串
    ///   - fontSize: 字体大小
    ///   - textColor: 字体颜色
    /// - Returns: NSAttributedString
    open func emotionAttributedString(text:String?, fontSize:CGFloat,textColor:UIColor) -> NSAttributedString?
    {
        guard let text = text,
              let regularExpression = try? NSRegularExpression(pattern: "\\[.*?\\]", options: [.caseInsensitive]) else {
                return nil
        }
    
        let attributesStringM = NSMutableAttributedString(string: text, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: fontSize),NSAttributedString.Key.foregroundColor: textColor])
        // 正则匹配
        let resultsArray = regularExpression.matches(in: text, options: [.reportCompletion], range: NSRange(location: 0, length: attributesStringM.length))
        // 遍历匹配结果 将表情字符 替换为表情图片
        for result in resultsArray.reversed() {
            let range = result.range(at: 0)
            let value = (text as NSString).substring(with: range)
            if let emotionModel = emotionModelWithValue(str: value),
                let imageAttributesString = emotionModel.emotionText(fontSize: fontSize) {
                    attributesStringM.replaceCharacters(in: range, with: imageAttributesString)
                
            }
        }
        
        // 设置属性字符串属性 使用setAttributes无法给图片属性文本设置属性，造成无法显示图片 因此使用addAttributes
        return attributesStringM.copy() as? NSAttributedString
    }
    
    
    /// 添加最近表情
    ///
    /// - Parameter emotionModel: 表情模型
    open func addRecentEmotion(emotionModel:XGEmotionModel) -> Void
    {
        let recentGroupModel = emotionsGroupList[0]

        // 如果最近分组没有该表情,进行添加;
        if recentGroupModel.emotions?.contains(emotionModel) == false {
            // 如果已经到达最大数量 删除末尾的
            if (recentGroupModel.emotions?.count ?? 0) == kEmotionPageCount {
                recentGroupModel.emotions?.removeLast()
            }
            
            // 使用次数+1
            emotionModel.useTimes += 1
            recentGroupModel.emotions?.append(emotionModel)
        } else {
            // 否则更新次数 因为从缓存生成的模型和网络加载的是不同的模型对象
            let em = recentGroupModel.emotions?.filter({$0.value == emotionModel.value})[0]
            em?.useTimes += 1
        }
        
        // 将最近分组按使用次数进行排序 经常使用的房子前面
        recentGroupModel.emotions?.sort(by: {$0.useTimes > $1.useTimes})
    }
    
    /// 保存最近分组
    open func saveRecentEmotions() -> Void
    {
        // 将模型数组转换为字典数组
        let recentGroupModel = emotionsGroupList[0]
        var jsonArray = [[String:Any]]()
        for emotion in recentGroupModel.emotions ?? [] {
            jsonArray.append(emotion.emotionToKeyValues())
        }
        
        // 保存至缓存
        (jsonArray as NSArray).write(to: URL(fileURLWithPath: recentEmotionsCachePath), atomically: true)
    }
    
    /// 加载最近表情模型
    private func loaRecentEmotions() -> Void
    {
        // 读取最近表情缓存数据
        let emotionList = XGEmotionModel.mj_objectArray(withFile: recentEmotionsCachePath) as? [XGEmotionModel]
        // 向分组表情数组中插入最近分组
        emotionsGroupList.insert(XGEmotionGroupModel(category: "最近", emotions: emotionList ?? []), at: 0)
    }
    
    /// 根据表情文字返回表情模型
    ///
    /// - Parameter str: 表情文字
    /// - Returns: XGEmotionModel
    private func emotionModelWithValue(str:String?) -> XGEmotionModel?
    {
        guard let str = str else {
            return nil
        }
        
        for emotionGroup in emotionsGroupList {
            if let result = emotionGroup.emotions?.filter({$0.value == str}).first {
                return result
            }
        }
        
        return nil
    }
}

// MARK: - 加载数据

extension XGEmotionsListViewModel
{
    /// 获取微博官方表情的详细信息
    ///
    /// - Parameter completion: 完成回调
    open func loadEmotionsList(completion:((Bool) -> Void)?) -> Void
    {
        XGStatusDAL.shared.loadEmotionsList { (responseObject, error) in
            if error != nil || responseObject == nil {
                completion?(false)
                return
            } else {
                // 字典转模型
                let modelArray = XGEmotionModel.mj_objectArray(withKeyValuesArray: responseObject)?.copy() as? [XGEmotionModel]
                // 缓存表情图片
                self.cacheEmoticonImage(emotionsList: modelArray ?? [], completion: completion)
            }
        }
    }
    
    /// 缓存表情图片
    private func cacheEmoticonImage(emotionsList:[XGEmotionModel],completion:((Bool) -> Void)?) -> Void
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
                let emotions = emotionsList.filter {$0.category == category}
                self.emotionsGroupList.append(XGEmotionGroupModel(category: category, emotions: emotions))
            }
            
            // 加载最近表情
            self.loaRecentEmotions()
            completion?(true)
        }
    }
}
