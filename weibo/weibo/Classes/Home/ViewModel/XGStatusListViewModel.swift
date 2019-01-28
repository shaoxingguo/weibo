//
//  XGStatusListViewModel.swift
//  weibo
//
//  Created by monkey on 2019/1/28.
//  Copyright © 2019 itcast. All rights reserved.
//

import UIKit

class XGStatusListViewModel
{
//     MARK: - 微博属性 需要计算
    /// 视图模型数组
    private(set) open var statusList:[XGStatusViewModel] = [XGStatusViewModel]()
}

// MARK: - 加载数据

extension XGStatusListViewModel
{
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
                completion(viewModlArray,nil)
            }
        }
    }
    
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
                self.statusList += (statusList ?? [])
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
                self.statusList = (statusList ?? []) + self.statusList
                completion(true,statusList?.count ?? 0)
            }
        }
    }
}
