//
//  ReusableXibView.swift
//  WeatherImageOverlay
//
//  Created by Nikolay Dimitrov on 7.12.23.
//

import UIKit

/**
 Used to generalize loading of the xib file

 `contentView` should be connected with the main view in the xib that will be loaded
 */

class ReusableXibView: UIView {

    @IBOutlet var contentView: UIView!

    override init(frame: CGRect) {
        super.init(frame: frame)

        loadXib()
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        loadXib()
        setup()
    }

    private func loadXib() {
        Bundle.main.loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)

        addSubview(contentView)
        contentView.frame = bounds
    }

    /**
     Override to setup the view (colors,text,fonts)
     Calling `super` is unnecessary
     */
    func setup() {
    }
}
