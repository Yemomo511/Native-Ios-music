//
//  PlayerViewController.swift
//  MusicApp
//
//  Created by 叶墨沫 on 2024/7/9.
//

import AVFoundation
import UIKit

// storyBoard 相当于app是一个舞台， 不断的展示 ，切换页面需要移除重新绘制或者直接进行覆盖。
// JAVAFX 和 大部分原生开发都是这种模式， 建议以后使用 swiftUI 节省时间

class PlayerViewController: UIViewController {

    @IBOutlet var PlayerView: UIView!
    //内部的常用View, 内部使用， Private
    private var ImageView:UIImageView = UtilsCustomView.createImageView()
    private var NameLabel = UtilsCustomView.createLableView()
    private var AuthorLabel = UtilsCustomView.createLableView()
    private var DescriptionLabel = UtilsCustomView.createLableView()
    private var ButtonLeft = UtilsCustomView.createMusicButton("")
    private var sliderBar = UISlider()
    let playerPauseButton = UtilsCustomView.createMusicButton("pause.fill")

    public var songs:[Song] = []
    public var position:Int = 0
    private var songsVolumn:Float = 0.5
    
    
    //把他转为全局属性，因为每个不同的 view 都需要对他进行操作
    var player: AVAudioPlayer?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    //作用:创建播放器视图,DidLayout 是在视图布局完成后调用的方法
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if PlayerView.subviews.count == 0 {
            configure()
        }
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
            player.volume = songsVolumn
            player.play();
            }catch{
            print("error found ")
        }
        print("ok")
        //图片视图
        ImageView.frame = CGRect(x: 10,
                                 y: 10,
                                 width: PlayerView.frame.width-10,
                                 height: PlayerView.frame.width-10)
        ImageView.image = UIImage(named: song.Cover)
        PlayerView.addSubview(ImageView)
        //label
        NameLabel.frame = CGRect(x: 10,
                                 y: ImageView.frame.height + 10,
                                 width: PlayerView.frame.width-10,
                                 height: 40)
        NameLabel.text = song.name
        NameLabel.font = UIFont(name: "Helvetica-Bold", size: 30)
        PlayerView.addSubview(NameLabel)
        //作者
        AuthorLabel.frame = CGRect(x: 10,
                                   y: ImageView.frame.height + 10 + 40,
                                   width: PlayerView.frame.width - 10,
                                   height: 40)
        
        DescriptionLabel.frame = CGRect(x: 10,
                                   y: ImageView.frame.height + 10 + 80,
                                   width: PlayerView.frame.width - 10,
                                   height: 40)
        AuthorLabel.text = song.author
        
        AuthorLabel.font = UIFont(name: "Helvetica-Bold", size: 20)
        PlayerView.addSubview(AuthorLabel)
        
        // Player controls
        let nextButton = UtilsCustomView.createMusicButton("forward.fill")
        let backButton = UtilsCustomView.createMusicButton("backward.fill")
        
        // Player View
        let stackView = UIStackView(arrangedSubviews: [backButton, playerPauseButton, nextButton])
        
        stackView.frame = CGRect(x: 10,
                                 y: PlayerView.frame.height - 60,
                                 width: PlayerView.frame.width - 10,
                                 height: 50)
        stackView.distribution = .fillEqually
        PlayerView.addSubview(stackView)
        
        //Action
        //点击时触发 for: .touchUpInside
        nextButton.addTarget(self, action: #selector(didForwardPlayer), for: .touchUpInside)
        playerPauseButton.addTarget(self, action: #selector(didPausePlayer), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(didbackWardPlayer), for: .touchUpInside)
        
        
        //slider配置
        sliderBar.frame = CGRect(x: 10,
                                 y: PlayerView.frame.height - 120,
                                 width: PlayerView.frame.width - 10,
                                 height: 50)
        sliderBar.value = songsVolumn
        
        //sliderAction
        sliderBar.addTarget(self, action: #selector(didSlidePlayer), for: .valueChanged)

        PlayerView.addSubview(sliderBar)
    }
    
    //slider Selector
    @objc func didSlidePlayer(){
        let value = sliderBar.value
        player?.volume = value
        songsVolumn = value
    }
    
    // Button Selector
    
    @objc func didbackWardPlayer(){
        if position > 0 {
            position = position - 1
            player?.stop()
            //推荐采用 swiftUI 这个最新的或者视图与数据绑定 outlet
            //移除所有的view
            for subview in PlayerView.subviews {
                subview.removeFromSuperview()
            }
            //重新配置
            configure()
        }else{
            //弹窗说明
            let alert = UIAlertController(title: "提示", message: "已经是第一首歌", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ok", style: .cancel, handler: nil))
            present(alert, animated: true)
        }
    }
    
    @objc func didForwardPlayer(){
        if position < songs.count {
            position = position + 1
            player?.stop()
            //推荐采用 swiftUI 这个最新的或者视图与数据绑定 outlet
            //移除所有的view
            for subview in PlayerView.subviews {
                subview.removeFromSuperview()
            }
            //重新配置
            configure()
        }else{
            //弹窗说明
            let alert = UIAlertController(title: "提示", message: "已经是最后歌", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ok", style: .cancel, handler: nil))
            present(alert, animated: true)
        }

    }

    @objc func didPausePlayer(){
        if player?.isPlaying == true {
            player?.pause()
            playerPauseButton.setBackgroundImage(UIImage(systemName: "play.fill"), for: .normal)
        }else{
            player?.play()
            playerPauseButton.setBackgroundImage(UIImage(systemName: "pause.fill"), for: .normal)
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
