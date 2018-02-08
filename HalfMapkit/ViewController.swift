//
//  ViewController.swift
//  HalfMapkit
//
//  Created by Higher Visibility on 07/02/2018.
//  Copyright © 2018 Higher Visibility. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController,MKMapViewDelegate,UITextFieldDelegate {

    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var mapview: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapview.delegate = self
        self.mapview.isZoomEnabled = false
        self.mapview.isScrollEnabled = false
        self.mapview.isRotateEnabled = false
        self.mapview.showsCompass = false
        
    }
    override func viewDidAppear(_ animated: Bool) {
   
        self.calculateDistance(fromLat: 51.379173, fromLong: -0.339520, toLat: 51.380306, toLong: -0.338690) { (d, t, s) in
            
        }
    }
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
      
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = UIColor.black
        renderer.lineWidth = 2.0
        return renderer
        
    }
    func calculateDistance(fromLat:Double, fromLong:Double, toLat:Double, toLong:Double, completion:@escaping (_ distance:Double,_ time:TimeInterval,_ error:String) -> ()) {
        
        var distance = 0.0
        var caltime:TimeInterval = 0.0
        
        let sourceCoord = CLLocationCoordinate2D(latitude: fromLat, longitude: fromLong)
        let destinationCoord = CLLocationCoordinate2D(latitude: toLat, longitude: toLong)
        
        let annotationOnOrigin = MKPointAnnotation()
        annotationOnOrigin.coordinate = sourceCoord
        annotationOnOrigin.title = "asdasd"
        annotationOnOrigin.subtitle = "xcvvv"
        
        let annotationOndestination = MKPointAnnotation()
        annotationOndestination.coordinate = destinationCoord
        annotationOndestination.title = "qwerfdsazxcvb"
        annotationOndestination.subtitle = "xcvwewrevv"
    
        let mkPlacemarkOrigen = MKPlacemark(coordinate: sourceCoord, addressDictionary: nil)
        let mkPlacemarkDestination = MKPlacemark(coordinate: destinationCoord, addressDictionary: nil)
        
        let source:MKMapItem = MKMapItem(placemark: mkPlacemarkOrigen)
        let destination:MKMapItem = MKMapItem(placemark: mkPlacemarkDestination)
        
        let directionRequest = MKDirectionsRequest()
        directionRequest.destination = destination
        directionRequest.source = source
        directionRequest.requestsAlternateRoutes = true
        directionRequest.transportType = MKDirectionsTransportType.automobile
        
        let directions = MKDirections(request: directionRequest)
        
        directions.calculate {
            (response, error) -> Void in
            
            if error != nil {
                
                let err = "\(error!.localizedDescription)"
                completion(distance,caltime,err)
            }
                
            else {
                
                let sortedRoutesByDistance: [MKRoute] = response!.routes.sorted(by: {$0.distance < $1.distance})
                
                if sortedRoutesByDistance.count > 0{
                    
                    let distanceRoute = sortedRoutesByDistance[0]
                    let d = distanceRoute.distance * 0.000621371
                    let time = distanceRoute.expectedTravelTime
                    let polyline = distanceRoute.polyline
                    self.mapview.add(polyline)
                    let padding = UIEdgeInsets(top: 30, left: 10, bottom: 20, right: 10)
                    self.mapview.setVisibleMapRect(polyline.boundingMapRect, edgePadding: padding, animated: true)
                    distance = d
                    caltime = time
                    self.mapview.addAnnotations([annotationOndestination,annotationOnOrigin])
                    completion(distance,caltime,"")
                    
                }else{
                    
                    completion(distance,caltime,"route not found")
                }
                
            }
        }
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let _ =  touches.first{
            self.view.endEditing(true);
        }
        super.touchesBegan(touches, with: event)
        
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        self.setScreenView()
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        self.resetScreenView()
        
    }
    private func setScreenView(){
        
        UIView.animate(withDuration: 0.5) {
            
            self.view.frame.origin.y -= 180
        }
        
    }
    private func resetScreenView(){
        
        UIView.animate(withDuration: 0.5) {
            
            self.view.frame.origin.y += 180
            
        }
        
        
    }
}

