//
//  AnnotationView.swift
//  Places
//
//  Created by Yi Wang on 1/24/17.
//  Copyright © 2017 Vento. All rights reserved.
//

import UIKit

protocol AnnotationViewDelegate {
  func didTouch(annotationView: AnnotationView)
}

class AnnotationView: ARAnnotationView {
  
  var titleLabel: UILabel?
  var distanceLabel: UILabel?
  var delegate: AnnotationViewDelegate?
  
  override func didMoveToSuperview() {
    super.didMoveToSuperview()
    loadUI()
  }
  
  /// Adds and configures labels
  func loadUI() {
    titleLabel?.removeFromSuperview()
    distanceLabel?.removeFromSuperview()
    
    // set up title label
    let label = UILabel(frame: CGRect(x: 10, y: 0, width: self.frame.size.width, height: 30))
    label.font = UIFont.systemFont(ofSize: 16)
    label.numberOfLines = 0
    label.backgroundColor = UIColor(white: 0.3, alpha: 0.7)
    label.textColor = UIColor.white
    self.addSubview(label)
    self.titleLabel = label
    
    // setup distance label
    distanceLabel = UILabel(frame: CGRect(x: 10, y: 30, width: self.frame.size.width, height: 20))
    distanceLabel?.backgroundColor = UIColor(white: 0.3, alpha: 0.7)
    distanceLabel?.textColor = UIColor.green
    distanceLabel?.font = UIFont.systemFont(ofSize: 12)
    self.addSubview(distanceLabel!)
    
    if let annotation = annotation as? Place {
      titleLabel?.text = annotation.placeName
      distanceLabel?.text = String(format: "%0.2f km", annotation.distanceFromUser / 1000)
    }
  }
  
  /// called every time the view needs to be redrawn - we simply make sure that the frames of the label hve the correct values by resetting them
  override func layoutSubviews() {
    super.layoutSubviews()
    titleLabel?.frame = CGRect(x: 10, y: 0, width: self.frame.size.width, height: 30)
    distanceLabel?.frame = CGRect(x: 10, y: 30, width: self.frame.size.width, height: 20)
  }
  
  /// tell delegate the view has been touched
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    delegate?.didTouch(annotationView: self)
  }
  
}

