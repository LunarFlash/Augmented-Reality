

import UIKit

import MapKit
import CoreLocation

class ViewController: UIViewController {
  
  fileprivate let locationManager = CLLocationManager()
  fileprivate var startedLoadingPOIs = false
  fileprivate var places = [Place]()
  
  @IBOutlet weak var mapView: MKMapView!
  override func viewDidLoad() {
    super.viewDidLoad()
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
    locationManager.startUpdatingLocation()
    locationManager.requestWhenInUseAuthorization()
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func showARController(_ sender: Any) {
  }
  
}

extension ViewController: CLLocationManagerDelegate {
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    if locations.count > 0 {
      let location = locations.last!
      print("Accuracy: \(location.horizontalAccuracy)")  // radius around the current location. If you have a value of 50, it means that the real location can be in a circle with a radius of 50 meters around the position stored in location.
      if location.horizontalAccuracy < 100 {
        manager.stopUpdatingLocation()  // save battery, we don't need more than 1 location value with accuracy of 100 meters
        let span = MKCoordinateSpan(latitudeDelta: 0.014, longitudeDelta: 0.014)
        let region = MKCoordinateRegion(center: location.coordinate, span: span)
        mapView.region = region
        
        // --
        if !startedLoadingPOIs {
          startedLoadingPOIs = true
          
          let loader = PlacesLoader()
          loader.loadPOIS(location: location, radius: 1000, handler: { (placesDict, error) in
            
            if let dict = placesDict {
              print(dict)
              
            }
            
          })
        }
        
        
      }
    }
  }
  
}
