//
//  PlaceAnnotation.swift
//  Places
//
//  Created by Yi Wang on 1/24/17.
//  Copyright © 2017 Vento. All rights reserved.
//

import Foundation
import MapKit

class PlaceAnnotation: NSObject, MKAnnotation {
  let coordinate: CLLocationCoordinate2D
  let title: String?
  
  init(location: CLLocationCoordinate2D, title: String) {
    self.coordinate = location
    self.title = title
    super.init()
  }
  
  
  
}
