//
//  LinePickerViewController.swift
//  Pojazdy_i_Przystanki
//
//  Created by Kacper Czapp on 16/06/2017.
//  Copyright © 2017 Kacper Czapp. All rights reserved.
//

import UIKit

protocol LinePickerDelegate: class {
    func pickerDidSelect(lines: [String])
}

class LinePickerViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    weak var delegate: LinePickerDelegate?

    let columnsCount: CGFloat = 5.0
    let spacing: CGFloat = 5.0

    var lines: [String] = [] {
        didSet {
            linesDataSource = lines.map({ (line) -> (Bool, String) in
                return (false, line)
            })
            collectionView?.reloadData()
        }
    }
    fileprivate var linesDataSource: [(isSelected: Bool, line: String)] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.allowsMultipleSelection = true
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return linesDataSource.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "lineCell", for: indexPath) as? LineCell else { return UICollectionViewCell() }
        let item = linesDataSource[indexPath.item]
        cell.configure(text: item.line)
        cell.isSelected = item.isSelected

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            linesDataSource[indexPath.item].isSelected = true
            cell.isSelected = true
        }
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            linesDataSource[indexPath.item].isSelected = false
            cell.isSelected = false
        }
    }

    @IBAction func dismissButtonTapped() {
        let selectedLines = linesDataSource.flatMap { (selected: Bool, line: String) -> String? in
            return selected ? line : nil
        }
        delegate?.pickerDidSelect(lines: selectedLines)
        self.dismiss(animated: true, completion: nil)
    }
}

extension LinePickerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = (collectionView.frame.width - (spacing * columnsCount - 1)) / columnsCount
        return CGSize(width: itemWidth, height: itemWidth)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }
}

class LineCell: UICollectionViewCell {
    @IBOutlet var label: UILabel!

    func configure(text: String) {
        self.label.text = text
    }

    override var isSelected: Bool {
        didSet {
            self.backgroundColor = isSelected ? UIColor.lightGray : UIColor.clear
        }
    }
}
