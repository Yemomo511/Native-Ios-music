//
//  ViewController.swift
//  MusicApp
//
//  Created by 叶墨沫 on 2024/7/9.
//

import UIKit

struct Song {
    var name: String
    var author: String
    var description: String
    var Cover: String
    var Audio: String
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var table: UITableView!
    var songs: [Song] = .init()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // init songs
        initSongs()
        
        /**You also should check that the connections are correct in your storyboard/xib file, otherwise the values will be nil at runtime, and therefore crash when they are implicitly unwrapped.*/
        //@see https://stackoverflow.com/questions/32170456/what-does-fatal-error-unexpectedly-found-nil-while-unwrapping-an-optional-valu
        table.delegate = self
        table.dataSource = self
    }
    
    // init Songs
    func initSongs() {
        for i in 1 ... 10 {
            songs.append(Song(name: "Music \(i)",
                              author: "Author \(i)",
                              description: "这是第\(i)首歌",
                              Cover: "Cover\(i%3+1)",
                              Audio: "song\(i%3+1)"))
        }
    }
    
    // Table Config
    
    // numberOfRows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let song = songs[indexPath.row]
        // configure
        var content = cell.defaultContentConfiguration()
        content.text = song.name
        content.secondaryText = song.description
        //图片
        content.image = UIImage(named: song.Cover)
        content.imageProperties.maximumSize = CGSize(width: 60, height: 60)
        content.textProperties.font = UIFont(name:"Helvetica-Bold", size: 18)!
        content.secondaryTextProperties.font = UIFont(name: "Helvetica", size: 17)!
        cell.contentConfiguration = content
//        已经被废弃，减少使用
//        cell.textLabel?.text = song.name
//        cell.detailTextLabel?.text = song.description
//        cell.accessoryType = .disclosureIndicator
//        cell.imageView?.image = UIImage(named: song.Cover)
//        cell.textLabel?.font = UIFont(name: "Helvetica-Bold", size: 18)
//        cell.detailTextLabel?.font = UIFont(name: "Helvetica", size: 17)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //点击后先触发新的 icon 的选中 ，如果设置特定的协议回调函数会触发的
        tableView.deselectRow(at: indexPath, animated: true)
        // 创建视图控制器，准备跳转
        let position = indexPath.row
        guard var viewController = storyboard?.instantiateViewController(withIdentifier: "player") as? PlayerViewController else {
            return
        }
        viewController.songs = songs
        viewController.position = position

        present(viewController, animated: true)
    }
}
