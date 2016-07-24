//
//  FlexMenuItem.swift
//  MJRFlexStyleComponents
//
//  Created by Martin Rehder on 24.07.16.
//  Copyright © 2016 Martin Rehder. All rights reserved.
//

import UIKit

public class FlexMenuItem {
    let title: String
    let titleShortcut: String
    let color: UIColor
    let thumbColor: UIColor
    
    public init(title: String, titleShortcut: String, color: UIColor, thumbColor: UIColor) {
        self.title = title
        self.titleShortcut = titleShortcut
        self.color = color
        self.thumbColor = thumbColor
    }
}
