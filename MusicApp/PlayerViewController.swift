//
//  PlayerViewController.swift
//  MusicApp
//
//  Created by 叶墨沫 on 2024/7/9.
//

import UIKit

class PlayerViewController: UIViewController {

    @IBOutlet var Player: UIView!
    public var songs:[Song] = []   
    //get Position to derect the last and next song for to switch
    public var position:Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    //作用:创建播放器视图,DidLayout 是在视图布局完成后调用的方法
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //create player view
        configure()
    }
    
    func configure(){
        //setup user interface elements 
    }
    /*
    // MARK: - Navigation
     
     */
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
    }
}
