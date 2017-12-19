//
//  FlexViewSearchTopBar.swift
//  MJRFlexStyleComponents
//
//  Created by Martin Rehder on 01.03.2017.
/*
 * Copyright 2017-present Martin Jacob Rehder.
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

open class FlexViewSearchTopBar: FlexViewTopBar, UISearchBarDelegate {
    open var searchBar: UISearchBar?
    var searchBarActive = false

    open var filterContentForSearchText: ((String) -> Void)?
    open var filterContentForSearchTextTyping: ((String) -> Void)?
    open var searchEnded: (() -> Void)?

    @objc open dynamic var barStyleColor: UIColor = .lightGray {
        didSet {
            self.setNeedsLayout()
        }
    }

    @objc open dynamic var barBackgroundColor: UIColor = .clear {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    @objc open dynamic var searchBarPlaceholder: String = "Search Text" {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.createSearchBar()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.createSearchBar()
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        self.layoutSearchBar()
    }
    
    open func layoutSearchBar() {
        self.searchBar?.frame = UIEdgeInsetsInsetRect(self.bounds, self.controlInsets)
        self.searchBar?.searchBarStyle  = UISearchBarStyle.minimal
        self.searchBar?.tintColor       = self.barStyleColor
        self.searchBar?.backgroundColor = self.barBackgroundColor
        self.searchBar?.placeholder     = self.searchBarPlaceholder
    }
    
    open func createSearchBar() {
        self.searchBar = UISearchBar(frame: UIEdgeInsetsInsetRect(self.bounds, self.controlInsets))
        self.searchBar?.delegate = self
        self.addSubview(self.searchBar!)
    }
    
    override open func cancel() {
        self.searchBarActive = false
        self.searchBar!.resignFirstResponder()
        self.searchBar!.text = ""
    }

    // MARK: - UISearchBarDelegate
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count > 0 {
            self.searchBarActive    = true
            self.filterContentForSearchTextTyping?(searchText)
            self.topBarUpdateHandler?()
        }
        else {
            self.searchBarActive = false
            self.topBarUpdateHandler?()
        }
    }
    
    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.cancel()
        self.topBarCancelHandler?()
        self.topBarUpdateHandler?()
        self.searchEnded?()
    }
    
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBarActive = true
        if let searchText = searchBar.text {
            self.filterContentForSearchText?(searchText)
        }
        self.endEditing(true)
    }
    
    public func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar!.setShowsCancelButton(true, animated: true)
    }
    
    public func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchBarActive = false
        self.searchBar!.setShowsCancelButton(false, animated: false)
    }
}
