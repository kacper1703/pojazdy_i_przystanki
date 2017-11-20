//
//  Bundle+LoadFromNib.swift
//  Pojazdy_i_Przystanki
//
//  Created by Kacper Czapp on 13/06/2017.
//  Copyright © 2017 Kacper Czapp. All rights reserved.
//

import Foundation

extension Bundle {
    static func loadViewFromNib<T>(withType type: T.Type) -> T {
        if let view = Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)?.first as? T {
            return view
        }

        fatalError("Could not load view with type " + String(describing: type))
    }
}

extension UIView {
    @discardableResult
    func loadFromNib<T : UIView>() -> T? {
        guard let contentView = Bundle.main.loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?.first as? T else { return nil }
        self.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: self.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
            ])
        return contentView
    }
}
