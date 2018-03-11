//
//  FriendListViewController.swift
//  Ketchup
//
//  Created by Brian Dorfman on 2/25/18.
//  Copyright © 2018 Ketchup. All rights reserved.
//

import UIKit

import Alamofire
import AlamofireObjectMapper
import FSQCellManifest

import ObjectMapper

class FriendListViewController: UITableViewController {

    var manifest: FSQTableViewCellManifest!
    
    init() {
        super.init(style: .plain)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        manifest = FSQTableViewCellManifest(delegate: self, plugins: nil, tableView: self.tableView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        reloadFromTestJSON()
        reloadFromNetwork()
    }

    func reloadFromNetwork() {
        let urlString = "https://ketchupapp.co/friends"
        LoggedInUser.current?.sessionManager.request(urlString).responseArray { (response: DataResponse<[Friend]>) in
            guard let friends = response.result.value else {
                return
            }
            self.reloadWithFriends(friends)
        }
    }
    
    func reloadFromTestJSON() {
        guard let path = Bundle.main.path(forResource: "Friends", ofType: "json"),
            let contents = try? String(contentsOfFile: path),
            let friends = Mapper<Friend>().mapArray(JSONString: contents) else {
            return
        }
        reloadWithFriends(friends)

    }
    
    func reloadWithFriends(_ friends: [Friend]) {
        // Reload table view/manifest
        let cellRecords = friends.map { (friend) -> FSQCellRecord in
            
            var subtitle: String? = nil
            
            if let lastDate = friend.lastKetchup {
                subtitle = DateFormatter.localizedString(from: lastDate,
                                                         dateStyle: .medium,
                                                         timeStyle: .short)
            }
            
            let model = IconTitleSubtitleCellModel(title: friend.name,
                                                   subtitle: subtitle,
                                                   iconURL: friend.avatarURL)
            return FSQCellRecord(model: model,
                                 cellClass: IconTitleSubtitleCell.self,
                                 onConfigure: nil,
                                 onSelection: nil)
        }
        
        manifest.sectionRecords = [FSQSectionRecord(cellRecords: cellRecords,
                                                   header: nil,
                                                   footer: nil)]
    }
}

