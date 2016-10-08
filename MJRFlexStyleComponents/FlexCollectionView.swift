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
    func onFlexCollectionItemSelected(view: FlexCollectionView, item: FlexCollectionItem)
    func onFlexCollectionItemMoved(view: FlexCollectionView, item: FlexCollectionItem)
}

@IBDesignable
public class FlexCollectionView: FlexView, UICollectionViewDataSource, UICollectionViewDelegate, FlexCollectionViewCellTouchedDelegate {
    let simpleHeaderViewID = "SimpleHeaderView"
    let emptyHeaderViewID = "EmptyHeaderView"
    
    private var _itemCollectionView: UICollectionView?
    public var collectionItemTypeMap: [String:String] = [:]
    
    public var contentDic : [String:[FlexCollectionItem]]?
    var sections : [FlexCollectionSection] = []
    
    public var flexCollectionDelegate: FlexCollectionViewDelegate?
   
    public var itemCollectionView: UICollectionView {
        get {
            return _itemCollectionView!
        }
    }
    
    public var collectionCellAppearance: FlexStyleAppearance? {
        didSet {
            self._itemCollectionView?.reloadData()
        }
    }
    
    @IBInspectable
    public var viewMargins: UIEdgeInsets = UIEdgeInsetsZero {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    @IBInspectable
    public var defaultCellSize: CGSize = CGSizeMake(120, 50) {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    @IBInspectable
    public var allowsMultipleSelection = false {
        didSet {
            self._itemCollectionView?.allowsMultipleSelection = self.allowsMultipleSelection
        }
    }
    
    @IBInspectable
    public var allowsSelection = true {
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
    
    func handleLongGesture(gesture: UILongPressGestureRecognizer) {
        switch(gesture.state) {
        case UIGestureRecognizerState.Began:
            guard let selectedIndexPath = self.itemCollectionView.indexPathForItemAtPoint(gesture.locationInView(self.itemCollectionView)) else {
                break
            }
            self.itemCollectionView.beginInteractiveMovementForItemAtIndexPath(selectedIndexPath)
        case UIGestureRecognizerState.Changed:
            self.itemCollectionView.updateInteractiveMovementTargetPosition(gesture.locationInView(gesture.view!))
        case UIGestureRecognizerState.Ended:
            self.itemCollectionView.endInteractiveMovement()
        default:
            self.itemCollectionView.cancelInteractiveMovement()
        }
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        self.setupView()
    }
    
    func createView() {
        self._itemCollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: UICollectionViewFlowLayout())
        self.itemCollectionView.dataSource = self
        self.itemCollectionView.delegate = self
        self.itemCollectionView.backgroundColor = .clearColor()

        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(FlexCollectionView.handleLongGesture(_:)))
        self.itemCollectionView.addGestureRecognizer(longPressGesture)

        if self.contentDic == nil {
            self.contentDic = [:]
        }
        
        if let collectionViewLayout = self.itemCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            collectionViewLayout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 0, right: 5)
            collectionViewLayout.headerReferenceSize = CGSizeMake(0, 0) // was 0,30
        }
        
        self.registerDefaultCells()
        
        self.itemCollectionView.registerClass(SimpleHeaderCollectionReusableView.classForCoder(), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: simpleHeaderViewID)
        self.itemCollectionView.registerClass(EmptyHeaderCollectionReusableView.classForCoder(), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: emptyHeaderViewID)

        self.itemCollectionView.allowsMultipleSelection = self.allowsMultipleSelection
        self.itemCollectionView.allowsSelection = self.allowsSelection
        
        self.addSubview(self.itemCollectionView)
    }
    
    func registerDefaultCells() {
        self.registerCell(FlexBaseCollectionItem.classForCoder(), cellClass: FlexBaseCollectionViewCell.classForCoder())
        self.registerCell(FlexColorCollectionItem.classForCoder(), cellClass: FlexColorCollectionViewCell.classForCoder())
        self.registerCell(FlexSwitchCollectionItem.classForCoder(), cellClass: FlexSwitchCollectionViewCell.classForCoder())
        self.registerCell(FlexSliderCollectionItem.classForCoder(), cellClass: FlexSliderCollectionViewCell.classForCoder())
    }
    
    public func registerCell(itemClass: AnyClass, cellClass: AnyClass) {
        self.collectionItemTypeMap[itemClass.description()] = cellClass.description()
        self.itemCollectionView.registerClass(cellClass, forCellWithReuseIdentifier: cellClass.description())
    }
    
    func setupView() {
        self.setupCollectionView()
    }
    
    func setupCollectionView() {
        let collectionViewRect = UIEdgeInsetsInsetRect(self.getViewRect(), self.viewMargins)
        self.itemCollectionView.frame = collectionViewRect
        
        let clipRect = CGRectOffset(self.bounds, -collectionViewRect.origin.x, -collectionViewRect.origin.y)
        let maskShapeLayer = StyledShapeLayer.createShape(self.getStyle(), bounds: clipRect, color: UIColor.blackColor())
        
        self.itemCollectionView.layer.mask = maskShapeLayer
    }
    
    // MARK: - public
    
    public func removeAllSections() {
        self.sections.removeAll()
        self.contentDic?.removeAll()
    }
    
    public func addSection(title: String? = nil) -> String {
        let s = FlexCollectionSection(reference: NSUUID().UUIDString, title: title)
        self.sections.append(s)
        self.contentDic?[s.reference] = []
        return s.reference
    }
    
    public func addItem(sectionReference: String, item: FlexCollectionItem) {
        self.contentDic?[sectionReference]?.append(item)
        item.sectionReference = sectionReference
    }
    
    public func selectItem(itemReference: String) {
        self.itemCollectionView.selectItemAtIndexPath(self.getIndexPathForItem(itemReference), animated: true, scrollPosition: .None)
    }
    
    public func updateCellForItem(itemReference: String) {
        if let indexPath = self.getIndexPathForItem(itemReference) {
            self.itemCollectionView.cellForItemAtIndexPath(indexPath)?.setNeedsLayout()
        }
    }
    
    // MARK: - Collection View Callbacks
    
    public func getIndexPathForItem(itemReference: String) -> NSIndexPath? {
        var s: Int = 0
        for sec in self.sections {
            var row: Int = 0
            if let items = self.contentDic?[sec.reference] {
                for item in items {
                    if item.reference == itemReference {
                        return NSIndexPath(forRow: row, inSection: s)
                    }
                    row += 1
                }
            }
            s += 1
        }
        return nil
    }
    
    public func getItemForIndexPath(index: NSIndexPath) -> FlexCollectionItem? {
        let row: Int = index.row
        let section: Int = index.section
        let sec = self.sections[section]
        if let items = self.contentDic?[sec.reference] {
            return items[row]
        }
        return nil
    }

    public func getItemForReference(itemReference: String) -> FlexCollectionItem? {
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
    
    public func removeItem(item: FlexCollectionItem) {
        if let items = self.contentDic?[item.sectionReference!] {
            if let idx = items.indexOf(item) {
                self.contentDic?[item.sectionReference!]?.removeAtIndex(idx)
            }
        }
    }
    
    public func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return self.sections.count
    }
    
    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sec = self.sections[section]
        if let items = self.contentDic?[sec.reference] {
            return items.count
        }
        return 0
    }
    
    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if let item = self.getItemForIndexPath(indexPath) {
            if let cellClassStr = collectionItemTypeMap[item.classForCoder.description()] {
                if let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellClassStr, forIndexPath:indexPath) as? FlexCollectionViewCell {
                    cell._item = item
                    cell.reference = item.reference
                    cell.flexCellTouchDelegate = self
                    cell.appearance = item.cellAppearance ?? self.collectionCellAppearance
                    return cell
                }
            }
        }
        return UICollectionViewCell()
    }
    
    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        if let item = self.getItemForIndexPath(indexPath) {
            if let preferredSize = item.preferredCellSize {
                return preferredSize
            }
        }
        return self.defaultCellSize
    }

    public func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            let sec = self.sections[indexPath.section]
            if let title = sec.title {
                if let headerView = self.itemCollectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: simpleHeaderViewID, forIndexPath: indexPath) as? SimpleHeaderCollectionReusableView {
                    headerView.title?.text = title
                    return headerView
                }
            }
            if let headerView = self.itemCollectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: emptyHeaderViewID, forIndexPath: indexPath) as? EmptyHeaderCollectionReusableView {
                return headerView
            }
        }
        return UICollectionReusableView()
    }

    public func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let item = self.getItemForIndexPath(indexPath) {
            self.flexCollectionDelegate?.onFlexCollectionItemSelected(self, item: item)
        }
    }
    
    public func collectionView(collectionView: UICollectionView, moveItemAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        let ssec = self.sections[sourceIndexPath.section]
        let tsec = self.sections[destinationIndexPath.section]
        
        if let item = self.getItemForIndexPath(sourceIndexPath) {
            self.contentDic?[ssec.reference]?.removeAtIndex(sourceIndexPath.row)
            self.contentDic?[tsec.reference]?.insert(item, atIndex: destinationIndexPath.row)
            item.sectionReference = tsec.reference
            self.flexCollectionDelegate?.onFlexCollectionItemMoved(self, item: item)
        }
    }
    
    // MARK: - FlexCollectionViewCellTouchedDelegate
    
    public func onFlexCollectionViewCellTouched(item: FlexCollectionItem?) {
        if let item = item {
            self.flexCollectionDelegate?.onFlexCollectionItemSelected(self, item: item)
        }
    }
}
