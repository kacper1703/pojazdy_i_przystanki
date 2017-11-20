//
//  VehicleAnnotationView.swift
//  Pojazdy_i_Przystanki
//
//  Created by Kacper Czapp on 13/06/2017.
//  Copyright © 2017 Kacper Czapp. All rights reserved.
//

import UIKit
class VehicleAnnotationView: UIView {
    @IBOutlet weak var lineLabel: UILabel!
    @IBOutlet weak var fromLabel: UILabel! {
        didSet {
            fromLabel.preferredMaxLayoutWidth = width
        }
    }
    @IBOutlet weak var toLabel: UILabel! {
        didSet {
            toLabel.preferredMaxLayoutWidth = width
        }
    }
    @IBOutlet weak var punctualityLabel: PunctualityLabel!

    let width: CGFloat = 150

    func configure(with vehicle: Vehicle?) {
        guard let vehicle = vehicle else {
            return
        }
        self.lineLabel.text = vehicle.line
        self.fromLabel.text = "Z: \(vehicle.previousStop)"
        self.toLabel.text = "Do: \(vehicle.nextStop)"
        self.punctualityLabel.punctuality = vehicle.punctuality.amount
//        layer.borderColor = vehicle.borderColor
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        layer.borderWidth = 2
        layer.cornerRadius = 10
        clipsToBounds = false
    }
}

class VehicleCalloutView: UIView {
//    var representedObject: MGLAnnotation
//
//    var leftAccessoryView = UIView() /* unused */
//    var rightAccessoryView = UIView() /* unused */
//
//    weak var delegate: MGLCalloutViewDelegate?
//
//    let tipHeight: CGFloat = 10.0
//    let tipWidth: CGFloat = 20.0
//
//    let mainBody: VehicleAnnotationView
//
//    required init(representedObject: MGLAnnotation) {
//        self.representedObject = representedObject
//        let annotation = Bundle.loadView(fromNib: "VehicleAnnotationView", withType: VehicleAnnotationView.self)
//        mainBody = annotation
//
//        super.init(frame: .zero)
//        backgroundColor = UIColor.clear
//        addSubview(mainBody)
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//       fatalError()
//    }
//
//    // MARK: - MGLCalloutView API
//    func presentCallout(from rect: CGRect, in view: UIView, constrainedTo constrainedView: UIView, animated: Bool) {
//        view.addSubview(self)
//        let width: CGFloat = 150
//        let fittingSize = mainBody.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
//
//        // Prepare our frame, adding extra space at the bottom for the tip
//        let frameHeight = fittingSize.height + tipHeight
//        let frameOriginX = rect.origin.x + (rect.size.width/2.0) - (width/2.0)
//        let frameOriginY = rect.origin.y - frameHeight
//        frame = CGRect(x: frameOriginX, y: frameOriginY, width: width, height: frameHeight)
//        mainBody.frame = CGRect(x: 0, y: 0, width: width, height: frameHeight)
//
//        if animated {
//            alpha = 0
//            UIView.animate(withDuration: 0.2) { [weak self] in
//                self?.alpha = 1
//            }
//        }
//    }
//
//    func dismissCallout(animated: Bool) {
//        if superview != nil {
//            if animated {
//                UIView.animate(withDuration: 0.2, animations: { [weak self] in
//                    self?.alpha = 0
//                    }, completion: { [weak self] _ in
//                        self?.removeFromSuperview()
//                })
//            } else {
//                removeFromSuperview()
//            }
//        }
//    }
//
//    // MARK: - Callout interaction handlers
//
//    func isCalloutTappable() -> Bool {
//        if let delegate = delegate {
//            if delegate.responds(to: #selector(MGLCalloutViewDelegate.calloutViewShouldHighlight)) {
//                return delegate.calloutViewShouldHighlight?(self) ?? false
//            }
//        }
//        return false
//    }
//
//    func calloutTapped() {
//        if isCalloutTappable() && delegate?.responds(to: #selector(MGLCalloutViewDelegate.calloutViewTapped)) ?? false {
//            delegate?.calloutViewTapped?(self)
//        }
//    }
//
//    // MARK: - Custom view styling
//
//    override func draw(_ rect: CGRect) {
////        // Draw the pointed tip at the bottom
////        let fillColor : UIColor = .white
////
////        let tipLeft = rect.origin.x + (rect.size.width / 2.0) - (tipWidth / 2.0)
////        let tipBottom = CGPoint(x: rect.origin.x + (rect.size.width / 2.0), y: rect.origin.y + rect.size.height)
////        let heightWithoutTip = rect.size.height - tipHeight
////
////        let currentContext = UIGraphicsGetCurrentContext()!
////
////        let tipPath = CGMutablePath()
////        tipPath.move(to: CGPoint(x: tipLeft, y: heightWithoutTip))
////        tipPath.addLine(to: CGPoint(x: tipBottom.x, y: tipBottom.y))
////        tipPath.addLine(to: CGPoint(x: tipLeft + tipWidth, y: heightWithoutTip))
////        tipPath.closeSubpath()
////
////        fillColor.setFill()
////        currentContext.addPath(tipPath)
////        currentContext.fillPath()
//    }
}
