

import UIKit

import MapKit
import CoreLocation

class ViewController: UIViewController {
  
  fileprivate let locationManager = CLLocationManager()
  fileprivate var startedLoadingPOIs = false
  fileprivate var places = [Place]()
  fileprivate var arViewController: ARViewController!
  
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
    arViewController = ARViewController()
    arViewController.dataSource = self
    arViewController.maxVisibleAnnotations = 30
    arViewController.headingSmoothingFactor = 0.05 // used to move views for the POIs about the screen. A value of 1 means there is no smoothing and if you turn your phone around views may jump from 1 position to another. Lower value means moving is animated, but views may be a bit behind the "moving" 
    arViewController.setAnnotations(places)
    self.present(arViewController, animated: true, completion: nil)
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
              // google places api returned a bunch of places
              guard let placesArray = dict.object(forKey: "results") as? [NSDictionary] else { return }
              for placeDict in placesArray {
                let latitude = placeDict.value(forKeyPath: "geometry.location.lat") as! CLLocationDegrees
                let longitude = placeDict.value(forKeyPath: "geometry.location.lng") as! CLLocationDegrees
                let reference = placeDict.object(forKey: "reference") as! String
                let name = placeDict.object(forKey: "name") as! String
                let address = placeDict.object(forKey: "vicinity") as! String
                
                let location = CLLocation(latitude: latitude, longitude: longitude)
                let place = Place(location: location, reference: reference, name: name, address: address)
                self.places.append(place)
                let annotation = PlaceAnnotation(location: place.location!.coordinate, title: place.placeName)
                DispatchQueue.main.async {  // - get main thread and add annotion to mapView
                  self.mapView.addAnnotation(annotation)
                }
              }
            } // got data
            
          })
        }
      }
    }
  }
  
}

extension ViewController: ARDataSource {
  func ar(_ arViewController: ARViewController, viewForAnnotation: ARAnnotation) -> ARAnnotationView {
    let annotationView = AnnotationView()
    annotationView.annotation = viewForAnnotation
    annotationView.delegate = self
    annotationView.frame = CGRect(x: 0, y: 0, width: 150, height: 50)
    return annotationView
  }
}

extension ViewController: AnnotationViewDelegate {
  func didTouch(annotationView: AnnotationView) {
    print("Tapped view for POI: \(annotationView.titleLabel?.text)")
  }
}
