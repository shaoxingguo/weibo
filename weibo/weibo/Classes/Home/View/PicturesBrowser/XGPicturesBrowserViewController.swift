//
//  XGPicturesBrowserViewController.swift
//  weibo
//
//  Created by monkey on 2019/2/18.
//  Copyright © 2019 itcast. All rights reserved.
//

import UIKit
import SDWebImage
import SVProgressHUD
import Photos

/// cell重用标识符
private let kReuseIdentifier = "XGPicturesBrowserCollectionViewCell"
/// 图片cell间距
public let kPicturesCellMargin:CGFloat = 20

class XGPicturesBrowserViewController: UIViewController
{
    
    // MARK: - 构造方法
    
    init(selectedIndex:Int,pictures:[XGPictureModel])
    {
        self.selectedIndex = selectedIndex
        self.pictures = pictures
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 控制器生命周期方法
    
    override func loadView()
    {
        super.loadView()
        view.backgroundColor = UIColor.black
        setUpUI()
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        setUpCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        // 滚动到选中的图片
        let indexPath = IndexPath(item: selectedIndex, section: 0)
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.scrollToItem(at: indexPath, at: [], animated: false)
        }
    }
    
    deinit {
        SDWebImageManager.shared().imageCache?.clearMemory()
    }
    
    // MARK: - 事件监听
    
    /// 关闭按钮事件监听
    @objc private func closeAction() -> Void
    {
        dismiss(animated: true, completion: nil)
    }
    
    /// 保存按钮事件监听
    @objc private func savePictureAction() -> Void
    {
        guard let appName = Bundle.main.appName else {
            return
        }
        
        let pictureModel = pictures[selectedIndex]
        if SDWebImageManager.shared().imageCache?.diskImageDataExists(withKey: pictureModel.bmiddlePic) == false {
            // 图片还没有下载完成
            return
        }

        let completion = { (error:NSError?) -> Void in
            if error == nil {
                SVProgressHUD.showSuccess(withStatus: "保存成功!")
            } else {
                SVProgressHUD.showError(withStatus: "保存失败")
            }
        }
        if pictureModel.isGif {
            let cachePath = SDWebImageManager.shared().imageCache?.defaultCachePath(forKey: pictureModel.bmiddlePic)
            let fileURL = URL(fileURLWithPath: cachePath!)
            PHPhotoLibrary.saveImage(imageFielURL: fileURL, collectionName: appName, completion: completion)
        } else {
            let image = SDWebImageManager.shared().imageCache?.imageFromCache(forKey: pictureModel.bmiddlePic)
            PHPhotoLibrary.saveImage(image: image,collectionName: appName, completion: completion)
        }
    }
    
    // MARK: - 私有属性
    
    /// 选中的图片索引
    private var selectedIndex:Int = 0
    /// 浏览的图片数组模型
    private var pictures:[XGPictureModel]
    /// 容器视图
    private lazy var contentView:UIView = UIView()
    /// collectionView 展示图片
    private lazy var collectionView:UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    /// 关闭按钮
    private lazy var closeButton:UIButton = UIButton(title: "关闭", normalColor: UIColor.white, highlightedColor: UIColor.white, fontSize: 15, backgroundColor: UIColor.darkGray, target: self, action: #selector(closeAction))
    /// 保存按钮
    private lazy var saveButton:UIButton = UIButton(title: "保存", normalColor: UIColor.white, highlightedColor: UIColor.white, fontSize: 15, backgroundColor: UIColor.darkGray, target: self, action: #selector(savePictureAction))
    /// 状态栏样式
    private var statusBarStyle:UIStatusBarStyle = .lightContent
}

// MARK: - UICollectionViewDataSource

extension XGPicturesBrowserViewController: UICollectionViewDataSource,UICollectionViewDelegate
{
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return pictures.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt
        indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kReuseIdentifier, for: indexPath) as! XGPicturesBrowserCollectionViewCell
        cell.pictureModel = pictures[indexPath.item]
        cell.delegate = self
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        selectedIndex = Int(scrollView.contentOffset.x / scrollView.width)
    }
}

// MARK: - XGPicturesBrowserCollectionViewCellDelegate

extension XGPicturesBrowserViewController: XGPicturesBrowserCollectionViewCellDelegate
{
    func picturesBrowserCollectionViewCellDidTapImageView()
    {
        closeAction()
    }
    
    func picturesBrowserCollectionViewCellDidZoom(scale: CGFloat)
    {
        if scale < 0.3 {
            closeAction()
            return
        }
        
        // scale = 0.5 clear scale = 1 black
        var alpha = (scale - 0.5) / 0.5
        alpha = scale < 1 ? fmax(alpha, 0) : fmin(alpha, 1)
        statusBarStyle = alpha < 0.5 ? .default : .lightContent
        setNeedsStatusBarAppearanceUpdate()
        collectionView.backgroundColor = UIColor.black.withAlphaComponent(alpha)
        closeButton.isHidden = scale < 1
        saveButton.isHidden = scale < 1
    }
}

extension XGPicturesBrowserViewController: XGPictureBrowserTransitioningAnimatorDismissDelegate
{
    func showDismissAnimationImageView() -> UIImageView
    {
        let key = pictures[selectedIndex].bmiddlePic
        let image = SDWebImageManager.shared().imageCache?.imageFromCache(forKey: key)
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }
    
    func dismissImageViewIndex() -> Int
    {
        return selectedIndex
    }
    
    func dismissFromRect() -> CGRect
    {
        guard let bigImageView = (collectionView.visibleCells[0] as? XGPicturesBrowserCollectionViewCell)?.bigImageView,
              let rect = bigImageView.superview?.convert(bigImageView.frame, to: UIApplication.shared.keyWindow) else {
                return CGRect.zero
        }
        
        return rect
    }
}

// MARK: - 设置界面

extension XGPicturesBrowserViewController
{
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    // 隐藏状态栏
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return statusBarStyle
    }
    
    /// 设置界面
    private func setUpUI() -> Void
    {
        view.backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        collectionView.backgroundColor = UIColor.black
        
        // 添加子控件
        view.addSubview(contentView)
        contentView.frame = CGRect(x: 0, y: 0, width: kScreenWidth + kPicturesCellMargin, height: kScreenHeight)
        
        // 向容器内添加视图 直接修改self.view.frame无效 因此在控制器内放一个view 大小比屏幕宽20
        contentView.addSubview(collectionView)
        contentView.addSubview(closeButton)
        contentView.addSubview(saveButton)
        
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView)
        }
        
        closeButton.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(12)
            make.bottom.equalTo(contentView).offset(-12)
            make.size.equalTo(CGSize(width: 100, height: 36))
        }
        
        saveButton.snp.makeConstraints { (make) in
            make.right.equalTo(contentView).offset(-12 + -kPicturesCellMargin)
            make.bottom.equalTo(contentView).offset(-12)
            make.size.equalTo(closeButton)
        }
    }
    
    /// 设置collectionView
    private func setUpCollectionView() -> Void
    {
        // 设置cell布局
        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0
        flowLayout.itemSize = contentView.size
        
        // 设置collectionView属性
        collectionView.bounces = false
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        
        // 设置数据源和代理
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // 注册cell
        collectionView.register(XGPicturesBrowserCollectionViewCell.self, forCellWithReuseIdentifier: kReuseIdentifier)
    }
}
