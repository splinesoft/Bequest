//
//  BQSTHTTPMethodCell.swift
//  Bequest
//
//  Created by Jonathan Hersh on 5/4/15.
//  Copyright (c) 2015 BQST. All rights reserved.
//

import Foundation
import SSDataSources
import SnapKit

public typealias BQSTHTTPMethodChangeBlock = (String) -> Void

private class BQSTHTTPMethodView: UIView, UICollectionViewDelegateFlowLayout, UITextFieldDelegate {

    private var changeBlock: BQSTHTTPMethodChangeBlock?

    private class BQSTSelectableCollectionCell: SSBaseCollectionCell {
        override var selected: Bool {
            willSet {
                self.backgroundColor = newValue ? .grayColor(): .clearColor()
            }
        }
    }

    private class BQSTHTTPMethodButtonCell: BQSTSelectableCollectionCell {
        lazy var label: UILabel = {
            let lbl = UILabel(frame: CGRectZero)
            lbl.textColor = UIColor.whiteColor()
            lbl.font = UIFont.BQSTMonoFont(18)
            lbl.textAlignment = .Center
            return lbl
        }()

        private override func configureCell() {
            super.configureCell()

            self.contentView.addSubview(label)
            label.snp_makeConstraints { make in
                make.edges.equalTo(self.contentView)
            }
        }
    }

    private class BQSTHTTPCustomMethodCell: BQSTSelectableCollectionCell {
        lazy var textField: UITextField = {
            let tf = UITextField(frame: CGRectZero)
            tf.textColor = UIColor.whiteColor()
            tf.font = UIFont.BQSTMonoFont(18)
            tf.returnKeyType = .Done
            tf.autocapitalizationType = .AllCharacters
            tf.accessibilityLabel = BQSTLocalizedString("REQUEST_METHOD_CUSTOM")
            tf.attributedPlaceholder = NSAttributedString(string: BQSTLocalizedString("REQUEST_METHOD_CUSTOM_PLACEHOLDER"),
                attributes: [ NSFontAttributeName: UIFont.BQSTMonoFont(18), NSForegroundColorAttributeName: UIColor.lightGrayColor() ])
            tf.textAlignment = .Center
            return tf
        }()

        private override func configureCell() {
            super.configureCell()

            self.contentView.addSubview(textField)
            textField.snp_makeConstraints { make in
                make.edges.equalTo(self.contentView)
            }
        }
    }

    lazy var dataSource: SSArrayDataSource = {
        let ds = SSArrayDataSource(items: ["GET", "POST", "HEAD", "OPTIONS", "PATCH", "PUT", ""])

        ds.cellCreationBlock = { (value, cv, indexPath) in

            if count(value as! String) == 0 {
                return BQSTHTTPCustomMethodCell(forCollectionView: cv as! UICollectionView, indexPath: indexPath)
            } else {
                return BQSTHTTPMethodButtonCell(forCollectionView: cv as! UICollectionView, indexPath: indexPath)
            }

        }

        return ds
    }()

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .Horizontal

        let cv = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
        cv.backgroundColor = .clearColor()
        cv.registerClass(BQSTHTTPMethodButtonCell.self, forCellWithReuseIdentifier: BQSTHTTPMethodButtonCell.identifier())
        cv.registerClass(BQSTHTTPCustomMethodCell.self, forCellWithReuseIdentifier: BQSTHTTPCustomMethodCell.identifier())
        cv.accessibilityIdentifier = BQSTLocalizedString("REQUEST_METHOD")
        return cv
    }()

    var method: String {
        get {
            let selectedIndexes = collectionView.indexPathsForSelectedItems()

            if let firstItem = selectedIndexes.first as? NSIndexPath {
                return dataSource.itemAtIndexPath(firstItem) as! String
            }

            return "GET"
        }
        set {
            if let indexPath = dataSource.indexPathForItem(newValue) {
                collectionView.selectItemAtIndexPath(indexPath, animated: true, scrollPosition: .CenteredHorizontally)
            } else {
                self.lastCustomMethod = newValue
            }
        }
    }

    private var lastCustomMethod: String?

    override required init(frame: CGRect) {
        super.init(frame: frame)

        dataSource.cellConfigureBlock = { (cell, text, view, indexPath) in
            if let str = text as? String {
                if count(str) == 0 {
                    (cell as! BQSTHTTPCustomMethodCell).textField.delegate = self
                    (cell as! BQSTHTTPCustomMethodCell).textField.text = self.lastCustomMethod
                } else {
                    (cell as! BQSTHTTPMethodButtonCell).label.text = str
                    (cell as! BQSTHTTPMethodButtonCell).accessibilityLabel = str
                }
            }
        }

        self.addSubview(collectionView)
        collectionView.snp_makeConstraints { make in
            make.edges.equalTo(self)
        }

        dataSource.collectionView = collectionView
        collectionView.delegate = self

        method = "GET"
    }

    deinit {
        dataSource.collectionView = nil
        collectionView.delegate = nil
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: UICollectionViewDelegateFlowLayout

    @objc private func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {

        let height: CGFloat = CGRectGetHeight(collectionView.frame)

        if (indexPath.row == Int(dataSource.numberOfItems() - 1)) {
            return CGSize(width: 100, height: height)
        }

        let item = dataSource.itemAtIndexPath(indexPath) as! NSString
        let width = item.sizeWithAttributes([ NSFontAttributeName: UIFont.BQSTMonoFont(18) ]).width

        return CGSize(width: max(width + 12, 70), height: height)
    }

    @objc private func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {

        return 0
    }

    @objc private func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {

        return 0
    }

    @objc private func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {

        return UIEdgeInsetsZero
    }

    // MARK: UICollectionViewDelegate

    @objc private func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {

        if let lastSelected = collectionView.indexPathsForSelectedItems().first as? NSIndexPath {
            collectionView.deselectItemAtIndexPath(lastSelected, animated: true)
        }

        if indexPath.row < Int(dataSource.numberOfItems() - 1) {
            collectionView.endEditing(true)
        }

        return true
    }

    @objc private func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {

        if indexPath.row == Int(dataSource.numberOfItems() - 1) {
            changeBlock?(self.lastCustomMethod ?? "GET")
        } else {
            let method = dataSource.itemAtIndexPath(indexPath) as! String
            changeBlock?(method)
        }
    }

    // MARK: UITextFieldDelegate

    @objc private func textFieldDidBeginEditing(textField: UITextField) {
        let indexPath = NSIndexPath(forItem: Int(dataSource.numberOfItems() - 1), inSection: 0)
        collectionView.selectItemAtIndexPath(indexPath, animated: true, scrollPosition: .CenteredHorizontally)
    }

    @objc private func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    @objc private func textFieldDidEndEditing(textField: UITextField) {
        changeBlock?(textField.text.uppercaseString)
    }

    @objc private func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        self.lastCustomMethod = (textField.text as NSString).stringByReplacingCharactersInRange(range, withString: string)
        return true
    }
}

class BQSTHTTPMethodCell: BQSTBlockyCollectionCell {

    var changeBlock: BQSTHTTPMethodChangeBlock? {
        willSet {
            methodView.changeBlock = newValue
        }
    }

    var method: String {
        get {
            return methodView.method
        }
        set {
            methodView.method = newValue
        }
    }

    private lazy var methodView: BQSTHTTPMethodView = {
        let view = BQSTHTTPMethodView(frame: CGRectZero)
        view.backgroundColor = .clearColor()
        return view
    }()

    override func configureCell() {
        super.configureCell()

        self.addSubview(methodView)
        methodView.snp_makeConstraints { make in
            make.edges.equalTo(self.contentView).insets(kBQSTBoxInsets)
        }
    }

}