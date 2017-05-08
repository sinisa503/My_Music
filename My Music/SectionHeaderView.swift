//
//  SectionHeaderView.swift
//  My Music
//
//  Created by Sinisa Vukovic on 08/05/2017.
//  Copyright © 2017 Sinisa Vukovic. All rights reserved.
//

import UIKit

class SectionHeaderView: UICollectionReusableView {
    
    @IBOutlet weak var sectionTitle: UILabel!
    
    var title: String? {
        didSet {
            sectionTitle.text = title
        }
    }
    
}
