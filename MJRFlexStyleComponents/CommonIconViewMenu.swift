//
//  CommonIconViewMenu.swift
//  FlexMediaPicker
//
//  Created by Martin Rehder on 10.12.2016.
/*
 * Copyright 2016-present Martin Jacob Rehder.
 * http://www.rehsco.com
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

import UIKit

public enum CommonIconViewMenuType {
    case add
    case refresh
    case settings
    case accept
    case close
    case back
    case share
    case move
    case delete
    case select
    case selectAll
    case folder
    case more
    
    public func iconName() -> String {
        switch self {
        case .add:
            return "plusIcon"
        case .folder:
            return "FolderIcon"
        case .refresh:
            return "refresh"
        case .settings:
            return "settings"
        case .share:
            return "share"
        case .more:
            return "MoreButton"
        case .move:
            return "MoveIcon"
        case .delete:
            return "DeleteIcon"
        case .select:
            return "SelectIcon"
        case .selectAll:
            return "SelectAllIcon"
        case .accept:
            return "Accept"
        case .close:
            return "CloseView"
        case .back:
            return "BackButton"
        }
    }
}

public protocol CommonIconViewMenuDelegate {
    func menuSelected(type: CommonIconViewMenuType)
}

public class CommonIconViewMenu: FlexViewMenu {
    private let menuIconSize: CGFloat
    
    public var viewMenuItems: [FlexMenuItem] = []
    public var viewMenu: FlexMenu?
    
    public var menuDelegate: CommonIconViewMenuDelegate?
    public var menuSelectionHandler: ((CommonIconViewMenuType) -> Void)?

    public init(size: CGSize, hPos: FlexViewMenuHorizontalPosition, vPos: FlexViewMenuVerticalPosition, menuIconSize: CGFloat) {
        self.menuIconSize = menuIconSize
        let menu = FlexMenu(frame: CGRect(x: 0,y: 0,width: 10,height: 10))
        menu.thumbSize = CGSize(width: menuIconSize, height: menuIconSize)
        menu.menuItemStyle = .rounded
        menu.menuInterItemSpacing = 10.0
        menu.menuStyle = .equallySpaces(thumbPos: .right)
        menu.borderColor = nil
        menu.controlInsets = UIEdgeInsets.init(top: 6, left: 0, bottom: 0, right: 0)
        super.init(menu: menu, size: size, hPos: hPos, vPos: vPos)
        self.viewMenu = menu
    }
    
    public func createPlusIconMenuItem() {
        self.createIconMenuItem(ofType: .add)
    }

    public func createFolderIconMenuItem() {
        self.createIconMenuItem(ofType: .folder)
    }

    public func createRefreshIconMenuItem() {
        self.createIconMenuItem(ofType: .refresh)
    }
    
    public func createSettingsIconMenuItem() {
        self.createIconMenuItem(ofType: .settings)
    }
    
    public func createShareIconMenuItem() {
        self.createIconMenuItem(ofType: .share)
    }
    
    public func createMoreIconMenuItem() {
        self.createIconMenuItem(ofType: .more)
    }
    
    public func createMoveIconMenuItem() {
        self.createIconMenuItem(ofType: .move)
    }
    
    public func createDeleteIconMenuItem() {
        self.createIconMenuItem(ofType: .delete)
    }
    
    public func createSelectIconMenuItem() {
        self.createIconMenuItem(ofType: .select)
    }
    
    public func createSelectAllIconMenuItem() {
        self.createIconMenuItem(ofType: .selectAll)
    }
    
    public func createAcceptIconMenuItem() {
        self.createIconMenuItem(ofType: .accept)
    }
    
    public func createCloseIconMenuItem() {
        self.createIconMenuItem(ofType: .close)
    }
    
    public func createIconMenuItem(ofType type: CommonIconViewMenuType) {
        self.createIconMenuItem(imageName: type.iconName()) {
            self.menuDelegate?.menuSelected(type: type)
            self.menuSelectionHandler?(type)
        }
    }
    
    public func createBackIconMenuItem() {
        self.createIconMenuItem(imageName: CommonIconViewMenuType.back.iconName(), iconSize: 36) {
            self.menuDelegate?.menuSelected(type: .back)
            self.menuSelectionHandler?(.back)
        }
    }
    
    @discardableResult
    public func createIconMenuItem(imageName: String, selectedImageName: String? = nil, selectedIconTintColor: UIColor? = nil, iconSize: Int? = nil, selectionHandler: @escaping (() -> Void)) -> FlexMenuItem {
        let size = iconSize ?? Int(menuIconSize)
        let ti1 = self.getImage(named: "\(imageName)_\(size)pt")?.tint(StyleEnvironment.iconsColor)
        var si1: UIImage?
        if let sin = selectedImageName {
            si1 = self.getImage(named: "\(sin)_\(size)pt")?.tint(selectedIconTintColor ?? StyleEnvironment.iconsColor)
        }
        let dis1 = self.getImage(named: "\(imageName)_\(size)pt")?.tint(StyleEnvironment.disabledIconsColor)
        let vm1 = FlexMenuItem(title: "", titleShortcut: "", color: UIColor.clear, thumbColor: UIColor.clear, thumbIcon: ti1, disabledThumbIcon: dis1, selectedThumbIcon: si1)
        vm1.selectionHandler = selectionHandler
        self.viewMenuItems.append(vm1)
        self.viewMenu?.menuItems = self.viewMenuItems
        return vm1
    }
    
    public func getImage(named imageName: String) -> UIImage? {
        return UIImage(named: imageName, in: Bundle(for: CommonIconViewMenu.self), compatibleWith: nil) ?? UIImage(named: imageName)
    }

}
