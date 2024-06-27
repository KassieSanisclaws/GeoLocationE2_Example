//
//  LocationDetailsView.swift
//  GeoLocationE2
//
//  Created by Kadeem Cherman on 2024-06-20.
//

import SwiftUI
import MapKit

struct LocationDetailsView: View {
    //Below is the binding of the detail views in the location decription view on a selected location:
    @Binding var mapSelection: MKMapItem?
    @Binding var show: Bool
    @State private var canvasScene: MKLookAroundScene?
    @Binding var getDirections: Bool
    
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text(mapSelection?.placemark.name ?? "")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text(mapSelection?.placemark.title ?? "")
                        .font(.footnote)
                        .foregroundStyle(.gray)
                        .lineLimit(/*@START_MENU_TOKEN@*/2/*@END_MENU_TOKEN@*/)
                        .padding(.trailing)
                }
                Spacer()
                
                Button {
                    show.toggle()
                    mapSelection = nil
                } label : {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(.gray, Color(.systemGray6))
                }
            }
            if let scene = canvasScene {
                LookAroundPreview(initialScene: scene)
                    .frame(height: 200)
                    .cornerRadius(12)
                    .padding()
            } else {
                ContentUnavailableView("No Available Preview", systemImage: "eye.slash")
            }
            HStack(spacing: 24){
                Button {
                    if let mapSelection {
                        mapSelection.openInMaps()
                    }
                }
                label: {
                  Text("Open In Maps")
                      .font(.headline)
                      .foregroundColor(.white)
                      .frame(width: 170, height: 48)
                      .background(.green)
                      .cornerRadius(12)
              }
                Button {
                  getDirections = true
                  show = false
                } label: {
                    Text("Get Directions")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 170, height: 48)
                        .background(.green)
                        .cornerRadius(12)
                }
            }
            .padding(.horizontal)
        }
        .onAppear {
            //The below concept is really important:
             print("DEBUGGING DID CALL ONAPPEAR")
            fetchCanvasScenePreview()
        }
        .onChange(of: mapSelection) { oldValue, newValue in
            print("DEBUGGING DID CALL ONAPPEAR")
            fetchCanvasScenePreview()
        }
        .padding()
    }
}

extension LocationDetailsView{
    func fetchCanvasScenePreview() {
        if let mapSelection {
            canvasScene = nil
            Task {
                let request = MKLookAroundSceneRequest(mapItem: mapSelection)
                canvasScene = try? await request.scene
            }
        }
    }
}

#Preview {
    LocationDetailsView(mapSelection: .constant(nil), show: .constant(false), getDirections: .constant(false))
}
