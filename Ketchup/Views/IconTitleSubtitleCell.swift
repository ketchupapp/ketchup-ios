//
//  IconTitleSubtitleCell.swift
//  Ketchup
//
//  Created by Brian Dorfman on 2/25/18.
//  Copyright © 2018 Ketchup. All rights reserved.
//

import UIKit
import FSQCellManifest
import PINRemoteImage

class StaticIntrinsicSizeImageView: UIImageView {
    override var intrinsicContentSize: CGSize {
        return self.frame.size
    }
}

struct IconTitleSubtitleCellModel {
    var title: String
    var subtitle: String?
    var iconURL: URL?
}

class IconTitleSubtitleCell: UITableViewCell, FSQCellManifestTableViewCellProtocol {
    static let CellHeight: CGFloat = 50
    
    var mainStack: UIStackView
    var textStack: UIStackView
    var iconView: UIImageView
    var titleLabel: UILabel
    var subtitleLabel: UILabel
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        titleLabel = UILabel(frame: .zero)
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        subtitleLabel = UILabel(frame: .zero)
        subtitleLabel.font = UIFont.systemFont(ofSize: 12)
        subtitleLabel.textColor = UIColor.gray
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        iconView = StaticIntrinsicSizeImageView(frame: CGRect(x: 0,
                                                              y: 0,
                                                              width: IconTitleSubtitleCell.CellHeight,
                                                              height: IconTitleSubtitleCell.CellHeight))
        iconView.setContentCompressionResistancePriority(.defaultHigh,
                                                         for: .horizontal)
        iconView.setContentHuggingPriority(.defaultHigh,
                                           for: .horizontal)
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.isHidden = true
        iconView.contentMode = .scaleAspectFit
        
        textStack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        textStack.axis = .vertical
        textStack.alignment = .leading
        textStack.spacing = 2
        textStack.translatesAutoresizingMaskIntoConstraints = false
        textStack.setContentCompressionResistancePriority(.defaultLow,
                                                          for: .horizontal)
        textStack.setContentHuggingPriority(.defaultLow,
                                           for: .horizontal)
        
        mainStack = UIStackView(arrangedSubviews: [iconView, textStack])
        mainStack.axis = .horizontal
        mainStack.alignment = .leading
        mainStack.spacing = 2
        mainStack.layoutMargins = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        mainStack.isLayoutMarginsRelativeArrangement = true
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        mainStack.frame = contentView.bounds
        contentView.addSubview(mainStack)
        mainStack.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    static func manifest(_ manifest: FSQTableViewCellManifest!, heightForModel model: Any!, maximumSize: CGSize, indexPath: IndexPath!, record: FSQCellRecord!) -> CGFloat {
//        guard let model = model as? IconTitleSubtitleCellModel else {
//            return 0
//        }
//        
        return CellHeight
    }
    
    func manifest(_ manifest: FSQCellManifest!, configureWithModel model: Any!, indexPath: IndexPath!, record: FSQCellRecord!) {
        guard let model = model as? IconTitleSubtitleCellModel else {
            return
        }
        titleLabel.text = model.title
        subtitleLabel.isHidden = (model.subtitle == nil)
        subtitleLabel.text = model.subtitle
        
        if let url = model.iconURL {
            iconView.isHidden = false
            iconView.pin_setImage(from: url)
//            iconView.pin_setImage(from: url,
//                                  processorKey: "avatarsize",
//                                  processor: { (result, cost) -> UIImage? in
//                                    result.image
//            })
        } else {
            iconView.isHidden = true
            iconView.pin_clearImages()
        }
        textStack.setNeedsLayout()
        mainStack.setNeedsLayout()
    }
    
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
}
