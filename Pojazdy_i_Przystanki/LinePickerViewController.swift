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

class LinePickerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    weak var delegate: LinePickerDelegate?

    var lines: [String] = [] {
        didSet {
            linesDataSource = lines.map({ (line) -> (Bool, String) in
                return (false, line)
            })
            tableView?.reloadData()
        }
    }
    var linesDataSource: [(selected: Bool, line: String)] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lines.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "lineCell", for: indexPath)
        cell.textLabel?.text = linesDataSource[indexPath.item].line
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            linesDataSource[indexPath.item].selected = true
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
        }
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            linesDataSource[indexPath.item].selected = false
            cell.accessoryType = UITableViewCellAccessoryType.none
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
