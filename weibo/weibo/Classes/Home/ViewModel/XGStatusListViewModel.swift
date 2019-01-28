//
//  XGStatusListViewModel.swift
//  weibo
//
//  Created by monkey on 2019/1/28.
//  Copyright © 2019 itcast. All rights reserved.
//

import UIKit
import SDWebImage

class XGStatusListViewModel
{
    /// 视图模型数组
    private(set) open var statusList:[XGStatusViewModel] = [XGStatusViewModel]()
}

// MARK: - 加载数据

extension XGStatusListViewModel
{
    /// 加载最新微博数据
    ///
    /// - Parameter completion: 完成回调
    open func loadNewStatusList(completion:@escaping (Bool,Int) -> Void)
    {
        loadData(sinceId: statusList.first?.id ?? 0) { (statusList, error) in
            if error != nil {
                completion(false,0)
                return
            } else {
                self.statusList = (statusList ?? []) + self.statusList
                completion(true,statusList?.count ?? 0)
            }
        }
    }
    
    /// 加载更多微博数据
    ///
    /// - Parameter completion: 完成回调
    open func loadMoreStatuslist(completion:@escaping (Bool,Int) -> Void)
    {
        var maxId = statusList.last?.id ?? 0
        maxId = maxId > 0 ? maxId - 1 : maxId
        loadData(maxId: maxId) { (statusList, error) in
            if error != nil {
                completion(false,0)
                return
            } else {
                self.statusList += (statusList ?? [])
                completion(true,statusList?.count ?? 0)
            }
        }
    }
    
    /// 加载微博数据
    ///
    /// - Parameters:
    ///   - sinceId:  若指定此参数，则返回ID比since_id大的微博（即比since_id时间晚的微博），默认为0
    ///   - maxId: 若指定此参数，则返回ID小于或等于max_id的微博，默认为0
    ///   - completion: 完成回调
    private func loadData(sinceId:Int64 = 0,maxId:Int64 = 0,completion:@escaping ([XGStatusViewModel]?,Error?) -> Void) -> Void
    {
        XGDataManager.loadStatusList(sinceId: sinceId, maxId: maxId) { (dataArray, error) in
            if error != nil || dataArray == nil {
                completion(nil,error)
                return
            } else {
                let viewModlArray = XGStatusViewModel.viewModelArrayWithModelArray(statusModelArray: dataArray!)
                // 缓存单图
                self.cacheSinglePicture(statusList: viewModlArray, completion: completion)
            }
        }
    }
    
    private func cacheSinglePicture(statusList:[XGStatusViewModel]?,completion:@escaping ([XGStatusViewModel]?,Error?) -> Void) -> Void
    {
        // 调度组
        let group = DispatchGroup()
        for viewModel in (statusList ?? []) {
            if viewModel.picUrls?.count != 1 {
                continue
            }
            
            // 缓存单图
            group.enter()
            let URLString = viewModel.picUrls?.first?.thumbnailPic ?? ""
            SDWebImageManager.shared().loadImage(with: URL(string: URLString), options: [.retryFailed,.refreshCached], progress: nil) { (image, data, error, _, _, _) in
                group.leave()
                if error != nil {
                    XGPrint("单图缓存失败!")
                    return
                }

                // 重新计算配图视图大小
                viewModel.updatePictureViewSize(imageSize: image!.size)
                XGPrint(image?.size)
            }
        }
        
        // 单图下载完毕监听
        group.notify(queue: DispatchQueue.main) {
            completion(statusList,nil)
        }
    }
}
