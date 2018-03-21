//
//  NoteCell.swift
//  NotesViews
//
//  Created by Glaphi on 18/03/2018.
//  Copyright © 2018 Glaphi. All rights reserved.
//

import UIKit

class NoteCell: UITableViewCell {
    
    static let id: String = "NoteCellID"
    var note: Note!
    
    convenience init(note: Note) {
        self.init(style: UITableViewCellStyle.subtitle, reuseIdentifier: "NoteCellID")
        self.note = note
    }
    
    lazy var titleLabel: UILabel = {
        var label: UILabel = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .left
        label.text = "Title"
        return label
    }()
    
    lazy var contentLabel: UILabel = {
        var label: UILabel = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.lightGray
        label.text = "Content content content content content content content content content content content content"
        return label
    }()
    
    lazy var updatedAtLabel: UILabel = {
        var label: UILabel = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .left
        return label
    }()
    
    private let offsetX: CGFloat = 5
    private let offsetY: CGFloat = 5
    private let ratioTitleVSDate: CGFloat = 1 / 3
    
    private var titleLabelFrame: CGRect {
        let width: CGFloat = (bounds.width - 2 * offsetX) * 2 * ratioTitleVSDate
        let height: CGFloat = bounds.height / 2
        let frame = CGRect(x: offsetX, y: offsetY, width: width, height: height)
        return frame
    }
    
    private var updatedAtLabelFrame: CGRect {
        var frame = titleLabelFrame
        frame.origin.x = frame.width + offsetX
        frame.size.width = frame.width / 2 + offsetX
        return frame
    }
    
    private var contentLabelFrame: CGRect {
        var frame: CGRect = titleLabelFrame
        frame.size.width = bounds.width - 2 * offsetX
        frame.origin.y = frame.height + offsetY
        return frame
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentLabel.frame = contentLabelFrame
        titleLabel.frame = titleLabelFrame
        updatedAtLabel.frame = updatedAtLabelFrame
        self.addSubview(titleLabel)
        self.addSubview(contentLabel)
        self.addSubview(updatedAtLabel)
        self.backgroundColor = UIColor.cyan
    
    }
    
}

