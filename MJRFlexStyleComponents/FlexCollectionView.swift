//
//  FlexCollectionView.swift
//  MJRFlexStyleComponents
//
//  Created by Martin Rehder on 21.09.16.
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
import StyledLabel

public protocol FlexCollectionViewDelegate {
    func onFlexCollectionItemSelected(_ view: FlexCollectionView, item: FlexCollectionItem)
    func onFlexCollectionItemMoved(_ view: FlexCollectionView, item: FlexCollectionItem)
}

@IBDesignable
open class FlexCollectionView: FlexView, UICollectionViewDataSource, UICollectionViewDelegate, FlexCollectionViewCellTouchedDelegate, UICollectionViewDelegateFlowLayout {
    let simpleHeaderViewID = "SimpleHeaderView"
    let emptyHeaderViewID = "EmptyHeaderView"
    
    fileprivate var _itemCollectionView: UICollectionView?
    open var collectionItemTypeMap: [String:String] = [:]
    
    open var contentDic : [String:[FlexCollectionItem]]?
    var sections : [FlexCollectionSection] = []
    
    open var flexCollectionDelegate: FlexCollectionViewDelegate?
    
    fileprivate var cellSwipeMenuActiveCell: IndexPath?

    open var itemCollectionView: UICollectionView {
        get {
            return _itemCollectionView!
        }
    }
    
    @IBInspectable
    open dynamic var viewMargins: UIEdgeInsets = UIEdgeInsets.zero {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    @IBInspectable
    open dynamic var defaultCellSize: CGSize = CGSize(width: 120, height: 50) {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    @IBInspectable
    open var allowsMultipleSelection = false {
        didSet {
            self._itemCollectionView?.allowsMultipleSelection = self.allowsMultipleSelection
        }
    }
    
    @IBInspectable
    open var allowsSelection = true {
        didSet {
            self._itemCollectionView?.allowsSelection = self.allowsSelection
        }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.createView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.createView()
    }
    
    func handleLongGesture(_ gesture: UILongPressGestureRecognizer) {
        switch(gesture.state) {
        case UIGestureRecognizerState.began:
            guard let selectedIndexPath = self.itemCollectionView.indexPathForItem(at: gesture.location(in: self.itemCollectionView)) else {
                break
            }
            self.itemCollectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
        case UIGestureRecognizerState.changed:
            self.itemCollectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
        case UIGestureRecognizerState.ended:
            self.itemCollectionView.endInteractiveMovement()
        default:
            self.itemCollectionView.cancelInteractiveMovement()
        }
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        self.setupView()
    }
    
    func createView() {
        self.backgroundColor = nil
        
        self._itemCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        self.itemCollectionView.dataSource = self
        self.itemCollectionView.delegate = self
        self.itemCollectionView.backgroundColor = .clear
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(FlexCollectionView.handleLongGesture(_:)))
        self.itemCollectionView.addGestureRecognizer(longPressGesture)

        if self.contentDic == nil {
            self.contentDic = [:]
        }
        
        self.registerDefaultCells()
        
        self.itemCollectionView.register(SimpleHeaderCollectionReusableView.classForCoder(), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: simpleHeaderViewID)
        self.itemCollectionView.register(EmptyHeaderCollectionReusableView.classForCoder(), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: emptyHeaderViewID)

        self.itemCollectionView.allowsMultipleSelection = self.allowsMultipleSelection
        self.itemCollectionView.allowsSelection = self.allowsSelection
        
        self.addSubview(self.itemCollectionView)
    }
    
    func registerDefaultCells() {
        self.registerCell(FlexBaseCollectionItem.classForCoder(), cellClass: FlexBaseCollectionViewCell.classForCoder())
        self.registerCell(FlexColorCollectionItem.classForCoder(), cellClass: FlexColorCollectionViewCell.classForCoder())
        self.registerCell(FlexSwitchCollectionItem.classForCoder(), cellClass: FlexSwitchCollectionViewCell.classForCoder())
        self.registerCell(FlexSliderCollectionItem.classForCoder(), cellClass: FlexSliderCollectionViewCell.classForCoder())
        self.registerCell(FlexTextViewCollectionItem.classForCoder(), cellClass: FlexTextViewCollectionViewCell.classForCoder())
        self.registerCell(FlexImageCollectionItem.classForCoder(), cellClass: FlexImageCollectionViewCell.classForCoder())
        self.registerCell(FlexButtonCollectionItem.classForCoder(), cellClass: FlexButtonCollectionViewCell.classForCoder())
        self.registerCell(FlexMenuCollectionItem.classForCoder(), cellClass: FlexMenuCollectionViewCell.classForCoder())
    }
    
    open func registerCell(_ itemClass: AnyClass, cellClass: AnyClass) {
        self.collectionItemTypeMap[itemClass.description()] = cellClass.description()
        self.itemCollectionView.register(cellClass, forCellWithReuseIdentifier: cellClass.description())
    }
    
    func setupView() {
        self.setupCollectionView()
    }
    
    func setupCollectionView() {
        let collectionViewRect = UIEdgeInsetsInsetRect(self.getViewRect(), self.viewMargins)
        self.itemCollectionView.frame = collectionViewRect
    }
    
    // MARK: - public
    
    open func removeAllSections() {
        self.sections.removeAll()
        self.contentDic?.removeAll()
    }
    
    open func addSection(_ title: NSAttributedString? = nil, height: CGFloat? = nil, insets: UIEdgeInsets? = nil) -> String {
        let s = FlexCollectionSection(reference: UUID().uuidString, title: title)
        if let h = height {
            s.height = h
        }
        if let ins = insets {
            s.insets = ins
        }
        self.sections.append(s)
        self.contentDic?[s.reference] = []
        return s.reference
    }
    
    open func getSection(_ sectionReference: String) -> FlexCollectionSection? {
        for sec in self.sections {
            if sec.reference == sectionReference {
                return sec
            }
        }
        return nil
    }
    
    open func sectionReference(atIndex: Int) -> String? {
        if atIndex < self.sections.count {
            let sec = self.sections[atIndex]
            return sec.reference
        }
        return nil
    }
    
    open func addItem(_ sectionReference: String, item: FlexCollectionItem) {
        self.contentDic?[sectionReference]?.append(item)
        item.sectionReference = sectionReference
    }
    
    open func selectItem(_ itemReference: String) {
        self.itemCollectionView.selectItem(at: self.getIndexPathForItem(itemReference), animated: true, scrollPosition: UICollectionViewScrollPosition())
    }

    open func deselectItem(_ itemReference: String) {
        if let ip = self.getIndexPathForItem(itemReference) {
            self.itemCollectionView.deselectItem(at: ip, animated: true)
        }
    }

    open func updateCellForItem(_ itemReference: String) {
        if let indexPath = self.getIndexPathForItem(itemReference) {
            self.itemCollectionView.cellForItem(at: indexPath)?.setNeedsLayout()
        }
    }
    
    // MARK: - Collection View Callbacks
    
    open func getIndexPathForItem(_ itemReference: String) -> IndexPath? {
        var s: Int = 0
        for sec in self.sections {
            var row: Int = 0
            if let items = self.contentDic?[sec.reference] {
                for item in items {
                    if item.reference == itemReference {
                        return IndexPath(row: row, section: s)
                    }
                    row += 1
                }
            }
            s += 1
        }
        return nil
    }
    
    open func getItemForIndexPath(_ index: IndexPath) -> FlexCollectionItem? {
        let row: Int = index.row
        let section: Int = index.section
        let sec = self.sections[section]
        if let items = self.contentDic?[sec.reference], row < items.count {
            return items[row]
        }
        return nil
    }

    open func getItemForReference(_ itemReference: String) -> FlexCollectionItem? {
        for sec in self.sections {
            if let items = self.contentDic?[sec.reference] {
                for item in items {
                    if item.reference == itemReference {
                        return item
                    }
                }
            }
        }
        return nil
    }
    
    open func removeItem(_ item: FlexCollectionItem) {
        if let items = self.contentDic?[item.sectionReference!] {
            if let idx = items.index(of: item) {
                self.contentDic?[item.sectionReference!]?.remove(at: idx)
            }
        }
    }
    
    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.sections.count
    }
    
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sec = self.sections[section]
        if let items = self.contentDic?[sec.reference] {
            return items.count
        }
        return 0
    }
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let item = self.getItemForIndexPath(indexPath) {
            if let cellClassStr = collectionItemTypeMap[item.classForCoder.description()] {
                if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellClassStr, for:indexPath) as? FlexCollectionViewCell {
                    cell._item = item
                    cell.reference = item.reference
                    cell.flexCellTouchDelegate = self
                    if item.swipeLeftMenuItems != nil || item.swipeRightMenuItems != nil {
                        let lswipe = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeLeftGestureAction(_:)))
                        lswipe.direction = .left
                        cell.addGestureRecognizer(lswipe)
                        let rswipe = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeRightGestureAction(_:)))
                        rswipe.direction = .right
                        cell.addGestureRecognizer(rswipe)
                    }
                    return cell
                }
            }
        }
        return UICollectionViewCell()
    }

    func swipeLeftGestureAction(_ recognizer: UISwipeGestureRecognizer) {
        if let cell = recognizer.view as? FlexCollectionViewCell {
            cell.swipeLeft()
            self.cellSwipeMenuActiveCell = self.itemCollectionView.indexPath(for: cell)
        }
    }
    
    func swipeRightGestureAction(_ recognizer: UISwipeGestureRecognizer) {
        if let cell = recognizer.view as? FlexCollectionViewCell {
            cell.swipeRight()
            self.cellSwipeMenuActiveCell = self.itemCollectionView.indexPath(for: cell)
        }
    }

    func resetSwipedCell() {
        if let sip = self.cellSwipeMenuActiveCell {
            if let cell = self.itemCollectionView.cellForItem(at: sip) as? FlexCollectionViewCell {
                cell.animateSwipeReset()
            }
        }
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let item = self.getItemForIndexPath(indexPath) {
            if let preferredSize = item.preferredCellSize {
                return preferredSize
            }
        }
        return self.defaultCellSize
    }

    open func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            let sec = self.sections[indexPath.section]
            if let title = sec.title {
                if let headerView = self.itemCollectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: simpleHeaderViewID, for: indexPath) as? SimpleHeaderCollectionReusableView {
                    headerView.title?.label.attributedText = title
                    return headerView
                }
            }
            if let headerView = self.itemCollectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: emptyHeaderViewID, for: indexPath) as? EmptyHeaderCollectionReusableView {
                return headerView
            }
        }
        return UICollectionReusableView()
    }

    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let item = self.getItemForIndexPath(indexPath) {
            self.flexCollectionDelegate?.onFlexCollectionItemSelected(self, item: item)
        }
    }
    
    open func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let ssec = self.sections[sourceIndexPath.section]
        let tsec = self.sections[destinationIndexPath.section]
        
        if let item = self.getItemForIndexPath(sourceIndexPath) {
            self.contentDic?[ssec.reference]?.remove(at: sourceIndexPath.row)
            self.contentDic?[tsec.reference]?.insert(item, at: destinationIndexPath.row)
            item.sectionReference = tsec.reference
            self.flexCollectionDelegate?.onFlexCollectionItemMoved(self, item: item)
        }
    }
    
    open func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        if let item = self.getItemForIndexPath(indexPath) {
            return item.canMoveItem
        }
        return false
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let sec = self.sections[section]
        return CGSize(width: 0, height: sec.height)
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let sec = self.sections[section]
        return sec.insets
    }
    
    // MARK: - FlexCollectionViewCellTouchedDelegate
    
    open func onFlexCollectionViewCellTouched(_ item: FlexCollectionItem?) {
        if let item = item {
            if let ip = self.getIndexPathForItem(item.reference) {
                if let selIP = self.itemCollectionView.indexPathsForSelectedItems, selIP.contains(ip) {
                    self.itemCollectionView.deselectItem(at: ip, animated: true)
                    item.itemDeselectionActionHandler?()
                }
                else {
                    self.itemCollectionView.selectItem(at: ip, animated: true, scrollPosition: UICollectionViewScrollPosition())
                    self.flexCollectionDelegate?.onFlexCollectionItemSelected(self, item: item)
                    item.itemSelectionActionHandler?()
                    if let autoDeselectTime = item.autoDeselectCellAfter {
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + autoDeselectTime, execute: {
                            self.itemCollectionView.deselectItem(at: ip, animated: true)
                        })
                    }
                }                
            }
        }
    }
}
