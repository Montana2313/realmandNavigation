//
//  ViewController.swift
//  MapsFirstTime
//
//  Created by Özgür  Elmaslı on 8.03.2019.
//  Copyright © 2019 Özgür  Elmaslı. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import RealmSwift

class ViewController: UIViewController , MKMapViewDelegate , CLLocationManagerDelegate {

    @IBOutlet weak var comment: UITextField!
    @IBOutlet weak var Place_name: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    var locationmenager = CLLocationManager()
    var requestCLLocation = CLLocation()
    var choosenlatitude = Double()
    var choosenlongtiude = Double()
    var locationSaver = LocationSaver()
    var _place_name = ""
    var _subtitle_name = ""
    var _latitude : Double = 0
    var _longtitude : Double = 0
    
    let realm = try! Realm()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(Realm.Configuration.defaultConfiguration.fileURL)
        mapView.delegate = self
        locationmenager.delegate = self
        locationmenager.desiredAccuracy = kCLLocationAccuracyBest // set of best accuracy
      //   locationmenager.requestAlwaysAuthorization() if write this , app will call location all the time
        locationmenager.requestWhenInUseAuthorization() // if write this , app will call location when app open
        locationmenager.startUpdatingLocation()
        let gesturerecoformapView = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.annotationMapView(gesturereco:)))
        mapView.addGestureRecognizer(gesturerecoformapView)
        chechit()
    }
    func chechit()
    {
        if _place_name != "" && _subtitle_name != "" && _latitude != 0 && _longtitude != 0
        {
            Place_name.text = _place_name
            comment.text = _subtitle_name
            let annotataion = MKPointAnnotation()
            annotataion.coordinate.latitude = _latitude
            annotataion.coordinate.longitude = _longtitude
            annotataion.title = _place_name
            annotataion.subtitle = _subtitle_name
            self.mapView.addAnnotation(annotataion)
            
        }
    }
    // calloutAccControlTapped is just for navigation
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if _latitude != 0 {
            if _longtitude != 0{
                self.requestCLLocation = CLLocation(latitude: _latitude, longitude: _longtitude)
            }
        }
        CLGeocoder().reverseGeocodeLocation(requestCLLocation) { (placemarks,error) in
            if let placemark  = placemarks{
                if placemark.count > 0
                {
                    let new_placemark = MKPlacemark(placemark: placemark[0])
                    let item = MKMapItem(placemark: new_placemark)
                    item.name = self._place_name
                    
                    let lauchoptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
                    
                    item.openInMaps(launchOptions: lauchoptions)
                }
            }
        }
    }
    // customize annotation
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // create specific annotation
        if annotation is MKUserLocation
        {
            return nil // this location is user location ?
        }
        let reuseID = "myannotaion"
        var pinview = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID) as? MKPinAnnotationView
        
        if pinview == nil {
            pinview = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            pinview?.canShowCallout = true
            pinview?.pinTintColor = UIColor.blue
            
            let button = UIButton(type: UIButton.ButtonType.infoDark)
            pinview?.rightCalloutAccessoryView = button
        }
        else
        {
            pinview?.annotation = annotation
        }
        return pinview
    }
    @objc func annotationMapView(gesturereco : UILongPressGestureRecognizer)
    {
        if gesturereco.state == UIGestureRecognizer.State.began
        {
            // if user touching somewhere
            let touchedpoint = gesturereco.location(in: self.mapView)
            let chosencoordinates = self.mapView.convert(touchedpoint, toCoordinateFrom: self.mapView)
            let annotataion = MKPointAnnotation()
            annotataion.coordinate = chosencoordinates
            annotataion.title = Place_name.text
            annotataion.subtitle = comment.text
            choosenlatitude = chosencoordinates.latitude
            choosenlongtiude = chosencoordinates.longitude
            self.mapView.addAnnotation(annotataion)
        }
        
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // just need to update location
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        // this is our location
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05) // just set focus event up
        let region = MKCoordinateRegion(center: location, span: span) // region side with our location and span
        
        mapView.setRegion(region, animated: true)
    }
    @IBAction func SaveButton(_ sender: Any) {
        if choosenlatitude != 0.0 && choosenlongtiude != 0.0
        {
            locationSaver.latitude = choosenlatitude
            locationSaver.longtitude = choosenlongtiude
            locationSaver.title = Place_name.text!
            locationSaver.subtitle = comment.text!
            
            try! realm.write {
                realm.add(locationSaver)
            }
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newPlace"),object : nil)
            
            self.navigationController?.popViewController(animated: true)
        }
        else
        {
            let alert = UIAlertController(title: "Error", message: "You need to choose location for saving", preferredStyle: UIAlertController.Style.alert)
            let okbutton = UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil)
            alert.addAction(okbutton)
            self.present(alert,animated: true , completion: nil)
        }
        
    }
    

}

