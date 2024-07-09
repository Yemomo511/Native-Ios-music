//
//  PlayerViewController.swift
//  MusicApp
//
//  Created by 叶墨沫 on 2024/7/9.
//

import AVFoundation
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
        return label
    }
}

class PlayerViewController: UIViewController {

    @IBOutlet var Player: UIView!
    //内部的常用View, 内部使用， Private
    private var ImageView:UIImageView = UtilsCustomView.createImageView()
    private var NameLabel = UtilsCustomView.createLableView()
    private var AuthorLabel = UtilsCustomView.createLableView()
    private var DescriptionLabel = UtilsCustomView.createLableView()
    
    public var songs:[Song] = []
    public var position:Int = 0
    
    
    //把他转为全局属性，因为每个不同的 view 都需要对他进行操作
    var player: AVAudioPlayer?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    //作用:创建播放器视图,DidLayout 是在视图布局完成后调用的方法
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configure()
    }
    
    func configure(){
        //先配置一下音频配置 ，让打开页面就能播放音乐
        let song = songs[position]
        let songUrlString = Bundle.main.path(forResource: song.Audio, ofType: "mp3")
        guard let songUrlString = songUrlString else {
            print("error to not found song")
            return
        }
        do{
            //播放音频前的准备，默认模式，激活等
            try AVAudioSession.sharedInstance().setMode(.default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: URL(string: songUrlString)!)
            //类型保护， audioPlayer 为可选类型，需要进行推断才能具体决定
            guard let player = player else{
                print("create player error")
                return
            }
            
            player.play();
            }catch{
            print("error found ")
        }
    }
    /*
    MARK: - Navigation
     */
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // View Controller 将要消失要执行的事
        super .viewWillDisappear(true)
        // 卸载 player
        if let player = player{
            player.stop()
        }
    }
}
