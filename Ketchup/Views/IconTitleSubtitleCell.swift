//
//  IconTitleSubtitleCell.swift
//  Ketchup
//
//  Created by Brian Dorfman on 2/25/18.
//  Copyright © 2018 Ketchup. All rights reserved.
//

import UIKit
import FSQCellManifest

struct IconTitleSubtitleCellModel {
    var title: String
    var subtitle: String?
    var iconURL: URL?
}

class IconTitleSubtitleCell: UITableViewCell, FSQCellManifestTableViewCellProtocol {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    static func manifest(_ manifest: FSQTableViewCellManifest!, heightForModel model: Any!, maximumSize: CGSize, indexPath: IndexPath!, record: FSQCellRecord!) -> CGFloat {
//        guard let model = model as? IconTitleSubtitleCellModel else {
//            return 0
//        }
//        
        return 100
    }
    
    func manifest(_ manifest: FSQCellManifest!, configureWithModel model: Any!, indexPath: IndexPath!, record: FSQCellRecord!) {
        guard let model = model as? IconTitleSubtitleCellModel else {
            return
        }
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
