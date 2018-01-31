//
//  SmallVehicleAnnotationView.swift
//  Pojazdy_i_Przystanki
//
//  Created by Kacper Czapp on 16/06/2017.
//  Copyright © 2017 Kacper Czapp. All rights reserved.
//

import UIKit

class SmallVehicleAnnotationManager {
    private var cache: [Vehicle : UIImage?] = [:]

    func annotationImage(with vehicle: Vehicle) -> UIImage? {
        if let existingImage = cache[vehicle] {
            return existingImage
        }
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 50, height: 26), false, 0)

        draw(with: vehicle)
        let imageOfPunctualityView = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()
        self.cache[vehicle] = imageOfPunctualityView

        return imageOfPunctualityView
    }

    private func draw(with vehicle: Vehicle) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()!

        //// Color Declarations
        let lateColor = UIColor(red: 0.922, green: 0.196, blue: 0.137, alpha: 1.000)
        let normalColor = UIColor(red: 0.278, green: 0.620, blue: 0.325, alpha: 1.000)
        let earlyColor = UIColor(red: 0.255, green: 0.608, blue: 0.843, alpha: 1.000)
        let textColor = UIColor(red: 0.000, green: 0.000, blue: 0.000, alpha: 1.000)

        //// Variable Declarations
        let timeColor: UIColor = {
            switch vehicle.punctuality.amount {
            case 0:
                return normalColor
            case let a where a > 0:
                return earlyColor
            case let a where a < 0:
                return lateColor
            default:
                return .clear
            }
        }()

        //// BackgroundRectangle Drawing
        let backgroundRectanglePath = UIBezierPath(roundedRect: CGRect(x: 1.5, y: 1.5,
                                                                       width: 47.5, height: 23),
                                                   byRoundingCorners: [.topLeft, .topRight, .bottomRight],
                                                   cornerRadii: CGSize(width: 5,
                                                                       height: 5))
        backgroundRectanglePath.close()
        vehicle.annotationColors.backgroundColor.setFill()
        backgroundRectanglePath.fill()
        vehicle.lineColor.setStroke()
        backgroundRectanglePath.lineWidth = 2
        backgroundRectanglePath.stroke()

        //// Line label Drawing
        let lineLabelRect = CGRect(x: 3, y: 3, width: 23, height: 20)
        let lineLabelStyle = NSMutableParagraphStyle()
        lineLabelStyle.alignment = .center
        let lineLabelFontAttributes = [
            .font: UIFont(name: "Menlo-Bold", size: 10)!,
            .foregroundColor: textColor,
            .paragraphStyle: lineLabelStyle
            ] as [NSAttributedStringKey: Any]

        let lineLabelTextHeight: CGFloat = vehicle.line.boundingRect(with: CGSize(width: lineLabelRect.width,
                                                                                  height: CGFloat.infinity),
                                                                     options: .usesLineFragmentOrigin,
                                                                     attributes: lineLabelFontAttributes,
                                                                     context: nil).height
        context.saveGState()
        context.clip(to: lineLabelRect)
        vehicle.line.draw(in: CGRect(x: lineLabelRect.minX,
                                     y: lineLabelRect.minY + (lineLabelRect.height - lineLabelTextHeight) / 2,
                                     width: lineLabelRect.width,
                                     height: lineLabelTextHeight),
                          withAttributes: lineLabelFontAttributes)
        context.restoreGState()

        //// Punctuality label Drawing
        let punctualityLabelRect = CGRect(x: 26, y: 3, width: 21, height: 20)
        let punctualityLabelStyle = NSMutableParagraphStyle()
        punctualityLabelStyle.alignment = .center
        let punctualityLabelFontAttributes = [
            .font: UIFont(name: "Menlo-Regular", size: 10)!,
            .foregroundColor: timeColor,
            .paragraphStyle: punctualityLabelStyle
            ] as [NSAttributedStringKey: Any]
        let punctualityText = vehicle.shortDescription

        let punctualityLabelTextHeight: CGFloat = punctualityText.boundingRect(with: CGSize(width: punctualityLabelRect.width,
                                                                                 height: CGFloat.infinity),
                                                                    options: .usesLineFragmentOrigin,
                                                                    attributes: punctualityLabelFontAttributes,
                                                                    context: nil).height
        context.saveGState()
        context.clip(to: punctualityLabelRect)
        punctualityText.draw(in: CGRect(x: punctualityLabelRect.minX,
                             y: punctualityLabelRect.minY + (punctualityLabelRect.height - punctualityLabelTextHeight) / 2,
                             width: punctualityLabelRect.width,
                             height: punctualityLabelTextHeight),
                  withAttributes: punctualityLabelFontAttributes)
        context.restoreGState()
    }
}
