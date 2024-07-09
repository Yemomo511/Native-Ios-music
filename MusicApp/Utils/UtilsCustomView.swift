//
//  UtilsCustomView.swift
//  MusicApp
//
//  Created by 叶墨沫 on 2024/7/9.
//
import UIKit

class UtilsCustomView {
    static func createImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }
    
    static func createLableView() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }
    
    static func createButtonWithSizeColor(_ size: Int, Color color: UIColor) -> (String)->UIButton{
        func createButtonWizeString(_ image: String)->UIButton{
            let button = UIButton()
            button.frame = CGRect(x: 0, y: 0, width: size, height: size)
            button.setBackgroundImage(UIImage(systemName: image), for: .normal)
            button.tintColor = color
            return button
        }
        return createButtonWizeString
    }
    static let createMusicButton = createButtonWithSizeColor(20, Color: .red)
    
}
