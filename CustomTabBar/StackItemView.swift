//
//  StackItemView.swift
//  CustomTabBar
//
//  Created by 远路蒋 on 2024/7/23.
//

import UIKit
import SnapKit

protocol StackItemViewDelegate: AnyObject {
    func handleTap(_ view: StackItemView)
}

class StackItemView: UIView {
    var titleLabel: UILabel!
    var imgView: UIImageView!
    var highlightView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        titleLabel = UILabel()
        imgView = UIImageView()
        highlightView = UIView()
        
        setupViews()
        
        self.isUserInteractionEnabled = true
    
        
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleGesture(_:))))
    }
    
    @objc
    func handleGesture(_ sender: UITapGestureRecognizer) {
        self.delegate?.handleTap(self)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        

        
        self.contentMode = .scaleToFill
        
        addSubview(highlightView)
        highlightView.addSubview(titleLabel)
        highlightView.addSubview(imgView)
        
        
        highlightView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(10)
            make.leading.trailing.equalToSuperview()
        }
        imgView.snp.makeConstraints { make in
            make.width.equalTo(20)
            make.height.equalTo(24)
            make.centerY.equalTo(highlightView)
            make.leading.equalTo(highlightView).offset(15)
        }
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(imgView.snp.trailing)//.offset(5)
            make.trailing.equalTo(highlightView).offset(-15)
            make.centerY.equalTo(highlightView)
        }
        
        imgView.contentMode = .scaleAspectFit
        titleLabel.font = UIFont(name: "Avenir Next", size: 14)
        self.highlightView.layer.cornerRadius = 15
        self.highlightView.layer.masksToBounds = true
    }
    
    private let highlightBgColor = UIColor(hexString: "#F0F0F2")
    
    static var newInstance: StackItemView {
        return StackItemView()
    }
    
    weak var delegate: StackItemViewDelegate?
    
    var isSelected: Bool = false {
        willSet {
            self.updateUI(isSelected: newValue)
        }
    }
    
    var item: Any? {
        didSet {
            self.configure(self.item)
        }
    }
    
    
    
    private func configure(_ item: Any?) {
        guard let model = item as? BottomStackItem else { return }
        self.titleLabel.text = model.title
        self.imgView.image = UIImage(named: model.image)
        self.isSelected = model.isSelected
    }
    
    private func updateUI(isSelected: Bool) {
        guard let model = item as? BottomStackItem else { return }
        model.isSelected = isSelected
        
        let options: UIView.AnimationOptions = isSelected ? [.curveEaseIn] : [.curveEaseOut]
        
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.5, options: options) {
            self.titleLabel.text = isSelected ? model.title : ""
//            if isSelected {
                self.imgView.snp.updateConstraints { make in
                    make.width.equalTo(isSelected ? 0 : 20)
                }
//            }
            self.highlightView.backgroundColor = isSelected ? self.highlightBgColor : .white
            (self.superview as? UIStackView)?.layoutIfNeeded()
        }
    }

}
