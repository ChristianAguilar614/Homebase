//
//  Postcell.swift
//  Homebase
//
//  Created by Justin Oroz on 10/10/15.
//  Copyright © 2015 HomeBase. All rights reserved.
//

import UIKit

class Postcell: UITableViewCell {

    @IBOutlet weak var nameButton: UIButton!
    
    @IBOutlet weak var postText: UILabel!
    
    var posterID:String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
