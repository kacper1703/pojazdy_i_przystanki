//
//  StopAnnotation.swift
//  Pojazdy_i_Przystanki
//
//  Created by Kacper Czapp on 13/06/2017.
//  Copyright © 2017 Kacper Czapp. All rights reserved.
//

import Foundation
import HDAugmentedReality

class StopAnnotation: ARAnnotationView {
    var titleLabel: UILabel?
    var distanceLabel: UILabel?
    var stop: Stop?

    init(with stop: Stop) {
        self.stop = stop
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func didMoveToSuperview() {
        commonInit()
    }

    func commonInit() {
        titleLabel?.removeFromSuperview()
        distanceLabel?.removeFromSuperview()

        let label = UILabel(frame: CGRect(x: 10,
                                          y: 0,
                                          width: self.frame.size.width,
                                          height: 30))
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 1
        label.textColor = UIColor.white
        self.addSubview(label)

        self.titleLabel = label

        let newDistanceLabel = UILabel(frame: CGRect(x: 10,
                                                     y: label.frame.maxY + 2,
                                                     width: self.frame.size.width,
                                                     height: 20))
        newDistanceLabel.textColor = UIColor.green
        newDistanceLabel.font = UIFont.systemFont(ofSize: 12)

        self.addSubview(newDistanceLabel)
        self.distanceLabel = newDistanceLabel

        if let stop = stop, let annotation = annotation {
            titleLabel?.text = "\(stop.name ?? "") \(stop.poleNumber)"
            newDistanceLabel.text = String(format: "%.0f m", annotation.distanceFromUser)
            titleLabel?.sizeToFit()
            let selfSizedFrame = CGRect(origin: self.frame.origin.offset(by: -10, dy: 0),
                                        size: CGSize(width: label.frame.width + 20,
                                                     height: self.frame.height))
            self.frame = selfSizedFrame
            self.backgroundColor = UIColor(white: 0.3, alpha: 0.7)
        }
    }
}

extension CGPoint {
    func offset(by dx: CGFloat, dy: CGFloat) -> CGPoint {
        return CGPoint(x: self.x + dx, y: self.y + dy)
    }
}
