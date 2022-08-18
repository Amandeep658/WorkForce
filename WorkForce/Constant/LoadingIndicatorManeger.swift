//
//  LoadingIndicatorManeger.swift
//  Radar
//
//  Created by apple on 23/07/21.
//

import UIKit

class LoadingButton: UIButton {

var activityIndicator: UIActivityIndicatorView!

    let activityIndicatorColor: UIColor = colorsApp.appColor.bordercolor

func loadIndicator(_ shouldShow: Bool) {
    if shouldShow {
        if (activityIndicator == nil) {
            activityIndicator = createActivityIndicator()
        }
        self.isEnabled = false
        self.alpha = 1.0
        showSpinning()
    } else {
        activityIndicator.stopAnimating()
        self.isEnabled = true
        self.alpha = 1.0
    }
}

private func createActivityIndicator() -> UIActivityIndicatorView {
    let activityIndicator = UIActivityIndicatorView()
    activityIndicator.hidesWhenStopped = true
    activityIndicator.color = activityIndicatorColor
    return activityIndicator
}

private func showSpinning() {
    activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    self.addSubview(activityIndicator)
    positionActivityIndicatorInButton()
    activityIndicator.startAnimating()
}

private func positionActivityIndicatorInButton() {
    let trailingConstraint = NSLayoutConstraint(item: self,
                                               attribute: .centerX,
                                               relatedBy: .equal,
                                               toItem: activityIndicator,
                                               attribute: .centerX,
                                               multiplier: 1, constant: 0)
    self.addConstraint(trailingConstraint)

    let yCenterConstraint = NSLayoutConstraint(item: self,
                                               attribute: .centerY,
                                               relatedBy: .equal,
                                               toItem: activityIndicator,
                                               attribute: .centerY,
                                               multiplier: 1, constant: 0)
    self.addConstraint(yCenterConstraint)
  }
}
