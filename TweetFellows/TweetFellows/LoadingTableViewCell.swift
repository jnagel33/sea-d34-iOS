//
//  LoadingTableViewCell.swift
//  TweetFellows
//
//  Created by Josh Nagel on 4/1/15.
//  Copyright (c) 2015 jnagel. All rights reserved.
//

import UIKit

class LoadingTableViewCell: UITableViewCell {

  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    override func awakeFromNib() {
        super.awakeFromNib()
        activityIndicator.startAnimating()
    }
}