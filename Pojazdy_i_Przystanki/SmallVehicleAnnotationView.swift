//
//  SmallVehicleAnnotationView.swift
//  Pojazdy_i_Przystanki
//
//  Created by Kacper Czapp on 16/06/2017.
//  Copyright © 2017 Kacper Czapp. All rights reserved.
//

import UIKit

class SmallVehicleAnnotationView: UIView {

    @IBOutlet weak var lineLabel: UILabel!
    @IBOutlet weak var punctualityLabel: PunctualityLabel!
    @IBOutlet weak var backgroundView: UIView! {
        didSet {
            self.layer.cornerRadius = 4
            self.layer.borderWidth = 2
        }
    }

    var vehicle: Vehicle? {
        didSet {
            self.punctualityLabel.punctuality = vehicle?.punctuality.amount
            self.lineType = vehicle?.lineType
            self.line = vehicle?.line
        }
    }

    var lineType: LineType? {
        didSet {
//            self.layer.borderColor = self.vehicle?.borderColor
        }
    }
    var line: String? {
        didSet {
            lineLabel.text = line
        }
    }

    func configure(with vehicle: Vehicle) {
        self.vehicle = vehicle
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.clipsToBounds = false
        self.backgroundColor = .clear
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    var imageOfView: UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.isOpaque, 0.0)
        if let context = UIGraphicsGetCurrentContext() {
            self.layer.render(in: context)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return image
        }
        return nil
    }

}
