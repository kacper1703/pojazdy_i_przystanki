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
        guard let stop = stop, let annotation = annotation else { return }

        titleLabel?.removeFromSuperview()
        distanceLabel?.removeFromSuperview()

        let newTitleLabel = UILabel(frame: CGRect(x: 10,
                                          y: 0,
                                          width: self.frame.size.width,
                                          height: 30))
        newTitleLabel.font = UIFont.systemFont(ofSize: 16)
        newTitleLabel.numberOfLines = 1
        newTitleLabel.textColor = UIColor.white
        newTitleLabel.text = "\(stop.name ?? "") \(stop.poleNumber)"
        newTitleLabel.sizeToFit()
        self.addSubview(newTitleLabel)

        let newDistanceLabel = UILabel(frame: CGRect(x: 10,
                                                     y: newTitleLabel.frame.maxY + 2,
                                                     width: self.frame.size.width,
                                                     height: 20))
        newDistanceLabel.textColor = UIColor.green
        newDistanceLabel.font = UIFont.systemFont(ofSize: 12)
        newDistanceLabel.text = String(format: "%.0f m", annotation.distanceFromUser)
        newDistanceLabel.sizeToFit()
        self.addSubview(newDistanceLabel)

        let width = max(newTitleLabel.frame.width, newDistanceLabel.frame.width) + 20
        let height = newTitleLabel.frame.height + newDistanceLabel.frame.height + 2

        self.titleLabel = newTitleLabel
        self.distanceLabel = newDistanceLabel

        let selfSizedFrame = CGRect(origin: self.frame.origin.offset(by: -10, dy: 0),
                                    size: CGSize(width: width,
                                                 height: height))
        self.frame = selfSizedFrame
        self.backgroundColor = UIColor(white: 0.3, alpha: 0.7)

    }
}

extension CGPoint {
    func offset(by dx: CGFloat, dy: CGFloat) -> CGPoint {
        return CGPoint(x: self.x + dx, y: self.y + dy)
    }
}
