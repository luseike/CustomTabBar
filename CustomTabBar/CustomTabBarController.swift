//
//  CustomTabBarController.swift
//  CustomTabBar
//
//  Created by 远路蒋 on 2024/7/23.
//

import UIKit



class CustomTabBarController: UITabBarController {

    var bottomStack = UIStackView()
    var currentIndex = 0
    
    lazy var tabs: [StackItemView] = {
        var items = [StackItemView]()
        
        for _ in 0..<4 {
            items.append(StackItemView.newInstance)
        }
        return items
    }()
    
    lazy var tabModels: [BottomStackItem] = {
        return [
            BottomStackItem(title: "Home", image: "home"),
            BottomStackItem(title: "Search", image: "search"),
            BottomStackItem(title: "Profile", image: "user"),
            BottomStackItem(title: "Settings", image: "settings")
        ]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bottomStack.axis = .horizontal
        bottomStack.alignment = .fill
        bottomStack.distribution = .equalSpacing
        bottomStack.spacing = 0
        
        
        
        // 整个自定义tabbar的容器
        let bottomView = UIView()
        view.addSubview(bottomView)
        bottomView.backgroundColor = .clear
        bottomView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self.view)
            make.bottom.equalTo(self.view)
            make.height.equalTo(self.tabBar.frame.size.height + Double(34))
        }
        
        // 因为要设置圆角和浮在底部的效果，container是tabbar的中间层
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 26
        containerView.layer.masksToBounds = true
        bottomView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(bottomView).inset(15)
            make.top.equalTo(bottomView)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
        
        // bottomStack 是最终排放 tabbarItem的 StackView
        containerView.addSubview(bottomStack)
        bottomStack.snp.makeConstraints { make in
            make.leading.trailing.equalTo(containerView).inset(5)
            make.top.bottom.equalTo(containerView)
//            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
        
        for (index, model) in self.tabModels.enumerated() {
            let tabView = self.tabs[index]
            model.isSelected = index == 0
            tabView.item = model
            tabView.delegate = self
            self.bottomStack.addArrangedSubview(tabView)
        }

        
        tabBar.isHidden = true
        
        setViewControllers([
            UINavigationController(rootViewController: HomeController()),
            UINavigationController(rootViewController: SearchController()),
            UINavigationController(rootViewController: ProfileController()),
            UINavigationController(rootViewController: SettingsController())
        ], animated: true)
    }

}

extension CustomTabBarController: StackItemViewDelegate {
    func handleTap(_ view: StackItemView) {
        self.tabs[self.currentIndex].isSelected = false
        view.isSelected = true
        self.currentIndex = self.tabs.firstIndex(where: {$0 === view}) ?? 0
        self.selectedIndex = currentIndex
    }
}
