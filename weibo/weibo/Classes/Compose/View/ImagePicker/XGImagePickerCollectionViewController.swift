//
//  XGImagePickerCollectionViewController.swift
//  weibo
//
//  Created by monkey on 2019/2/15.
//  Copyright © 2019 itcast. All rights reserved.
//

import UIKit
import TZImagePickerController

/// cell重用标识符
private let kReuseIdentifier = "XGImagePickerCollectionViewCell"

class XGImagePickerCollectionViewController: UICollectionViewController
{
    /// 图片二进制数据
    open var imageData:Data?
    /// 选中的图片 
    private var selectedImages:[UIImage] = [UIImage]()
    /// 当前选择的索引
    private var selectedIndex:Int = 0
    
    // MARK: - 构造方法
    
    init()
    {
        let flowLayout = UICollectionViewFlowLayout()
        super.init(collectionViewLayout: flowLayout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 控制器生命周期方法
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        collectionView.backgroundColor = UIColor(white: 0.9, alpha: 1)
        setUpCollectionView()
        view.layoutIfNeeded()
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return (selectedImages.count < 9 ? selectedImages.count + 1 : 9)
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kReuseIdentifier, for: indexPath) as! XGImagePickerCollectionViewCell
        cell.delegate = self
        cell.image = indexPath.item < selectedImages.count ? selectedImages[indexPath.item] : nil
        return cell
    }
}

// MARK: - XGImagePickerCollectionViewCellDelegate

extension XGImagePickerCollectionViewController: XGImagePickerCollectionViewCellDelegate
{
    /// 添加照片
    func imagePickerCollectionViewCellAddPicture(cell: XGImagePickerCollectionViewCell)
    {
        selectedIndex = (collectionView.indexPath(for: cell)?.item ?? 0)
        let pickerController:TZImagePickerController = TZImagePickerController(maxImagesCount: 1, columnNumber: 3, delegate: self)
        present(pickerController, animated: true, completion: nil)
    }
    
    /// 移除照片
    func imagePickerCollectionViewCellRemovePicture(cell:
        XGImagePickerCollectionViewCell)
    {
        selectedIndex = (collectionView.indexPath(for: cell)?.item ?? 0)
        selectedImages.remove(at: selectedIndex)
        collectionView.reloadData()
    }
}

// MARK: - TZImagePickerControllerDelegate!

extension XGImagePickerCollectionViewController: TZImagePickerControllerDelegate
{
    /// 选中图片回调
    func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]?,sourceAssets assets: [Any]?, isSelectOriginalPhoto: Bool)
    {
        guard let image = photos?.first,
              let asset = assets?[0] as? PHAsset else {
                return
        }
        
        // 取出选中的图片的二进制数据
        let options = PHImageRequestOptions()
        options.isSynchronous = true
        PHImageManager.default().requestImageData(for: asset, options: options) {[weak self] (data, _, _, _) in
            self?.imageData = data
        }
        
        // index = 0 count = 0 添加 index = 1 count = 1 添加 index = 0 count = 2 覆盖  index == count 添加 index < count 覆盖
        if selectedIndex == selectedImages.count {
            selectedImages.append(image)
        } else {
            selectedImages[selectedIndex] = image
        }
        
        // 刷新表格
        collectionView.reloadData()
    }
}

// MARK: - 其他私有方法

extension XGImagePickerCollectionViewController
{
    /// 设置CollectionView
    private func setUpCollectionView() -> Void
    {
        // 设置布局
        let columns:Int = 3 // 列数
        let itemWidth:CGFloat = 100
        let margin = (collectionView.width - CGFloat(columns) * itemWidth) / CGFloat(columns - 1 + 2)
        
        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        flowLayout.minimumLineSpacing = margin
        flowLayout.minimumInteritemSpacing = margin
        
        collectionView.bounces = false
        collectionView.contentInset = UIEdgeInsets(top: margin, left: margin, bottom: 0, right: margin)
        
        // 注册cell
        collectionView.register(XGImagePickerCollectionViewCell.self, forCellWithReuseIdentifier: kReuseIdentifier)
    }
}
