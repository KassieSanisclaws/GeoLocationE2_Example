//
//  ContentView.swift
//  GeoLocationE2
//
//  Created by Kadeem Cherman on 2024-06-19.
//

import SwiftUI
import MapKit

//UserAnnotation() This request the users location soon as the app is openened and is the new way of swift 17.

struct ContentView: View {
    //Locationmanager:
    @ObservedObject var locationManager = LocationManager.shared
    //Search Bar Location:
    @State private var searchText = ""
    //Create a state proper that is a new feature that swift inrtroduced i the map api called camera position.
    @State private var cameraPosition: MapCameraPosition = .region(.userRegion)
    //Storing the results of the search querry:
    @State private var results = [MKMapItem]()
    @State private var mapSelection: MKMapItem?
    @State private var showDetails = false
    @State private var getDirections = false
    //Below is for routing naviating view if the polylne is on the map:
    @State private var routeDisplaying = false
    @State private var route: MKRoute?
    @State private var routeDestination: MKMapItem?
    
    var body: some View {
        Group {
            if locationManager.userLocation == nil {
                LocationRequestView()
            } else {
                Map(position: $cameraPosition, selection: $mapSelection) {
                    //  Marker("My Location", systemImage: "paperplane", coordinate: .userLocation)
                    // .tint(.green)
                    Annotation("My Location", coordinate: .userLocation){
                        ZStack {
                            Circle()
                                .frame(width: 170, height: 170)
                                .foregroundStyle(.green.opacity(0.23))
                            Circle()
                                .frame(width: 20, height: 20)
                                .foregroundColor(.white)
                            Circle()
                                .frame(width: 12, height: 12)
                                .foregroundColor(.red)
                        }
                    } 
                    //Render all the map searches from search from the resuts array.
                    ForEach(results, id: \.self) { item in
                        if routeDisplaying {
                            if item == routeDestination {
                                let placemark = item.placemark
                                Marker(placemark.name ?? "", coordinate: placemark.coordinate)
                            }
                        } else {
                            let placemark = item.placemark
                            Marker(placemark.name ?? "", coordinate: placemark.coordinate)
                        }
                    }
                    if let route {
                        //New feature we get from the updated MapKit UI:
                        MapPolyline(route.polyline)
                            .stroke(.red, lineWidth: 6)
                    }
                    
                }
            }
        }
        
    }
}


//Content view of the search:
extension ContentView{
    func searchPlaces() async {
        let requests = MKLocalSearch.Request()
        requests.naturalLanguageQuery = searchText
        //This specifies the region you re doing the search request on.
        requests.region = .userRegion
        //Stores the result in the below property.
        let results = try? await MKLocalSearch(request: requests).start()
        self.results = results?.mapItems ?? []
        
    }
  //Function gets the route & displays on screen:
    func fetchRoute() {
        if let mapSelection {
            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: .init(coordinate: .userLocation))
            request.destination = mapSelection
            
            Task {
                let result = try? await MKDirections(request: request).calculate()
                route = result?.routes.first
                routeDestination = mapSelection
                
                withAnimation(.snappy){
                    routeDisplaying = true
                    showDetails = false
                    
                    if let rect = route?.polyline.boundingMapRect, routeDisplaying {
                        cameraPosition = .rect(rect)
                    }
                }
            }
        }
    }
    
}

struct MapUserLocationButton: View {
    @ObservedObject var locationManager: LocationManager
    
    var body: some View {
        Button(action: {
            DispatchQueue.main.async {
                locationManager.requestLocation()
            }
        }) {
            Image(systemName: "location.circle.fill")
                .resizable()
                .frame(width: 32, height: 32)
                .foregroundColor(.green)
        }
        .padding()
    }
}

//Setting user location in the map region.
extension CLLocationCoordinate2D {
    static let userLocation = CLLocationCoordinate2D(latitude: 43.651070, longitude: -79.347015)
}

//Creating a map view region that uses the user location
extension MKCoordinateRegion {
    static var userRegion: MKCoordinateRegion{
        return .init(center: .userLocation,
                     latitudinalMeters: 10000,
                     longitudinalMeters: 10000)
    }
}


struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
     
