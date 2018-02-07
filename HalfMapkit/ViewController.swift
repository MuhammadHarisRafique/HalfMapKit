//
//  ViewController.swift
//  HalfMapkit
//
//  Created by Higher Visibility on 07/02/2018.
//  Copyright © 2018 Higher Visibility. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController,MKMapViewDelegate {

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
    
        self.calculateDistance(fromLat: 51.379173, fromLong: -0.339520, toLat: 51.380539, toLong: -0.338748) { (d, t, s) in
            
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
                    let padding = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
                    self.mapview.setVisibleMapRect(polyline.boundingMapRect, edgePadding: padding, animated: true)
                    distance = d
                    caltime = time
                    
                    completion(distance,caltime,"")
                    
                }else{
                    
                    completion(distance,caltime,"route not found")
                }
                
            }
        }
        
    }
  

}

