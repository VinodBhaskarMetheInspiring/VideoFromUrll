//
//  VideoTableViewCell.swift
//  PlayVideoFromServerTask
//
//  Created by Vinod Bhaskar on 28/09/20.
//  Copyright © 2020 Metheinspiring. All rights reserved.
//

import UIKit

class VideoTableViewCell: UITableViewCell {
    @IBOutlet weak var backGroundView: UIView!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var urlLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
