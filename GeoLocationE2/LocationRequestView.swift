//
//  LocationRequestView.swift
//  GeoLocationE2
//
//  Created by Kadeem Cherman on 2024-06-26.
//

import SwiftUI

struct LocationRequestView: View {
    var body: some View {
        ZStack {
            Color(.systemGreen).ignoresSafeArea()
            
            VStack{
                Image(systemName: "paperplane.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                
                Text("Would You Allow This Application to Get Your Location?")
                    .multilineTextAlignment(.center)
                    .frame(width: 300)
                    .padding()
                    .font(.system(size: 21, weight: .semibold))
                
                
                VStack {
                    Button {
                        LocationManager.shared.requestLocation()
                    } label: {
                        Text("Allow Access")
                            .padding()
                            .font(.headline)
                            .foregroundColor(.indigo)
                    }
                    .frame(width: UIScreen.main.bounds.width)
                    .padding(.horizontal, -32)
                    .background(Color.white)
                    .clipShape(Capsule())
                    .padding()
                }
            }
        }
    }
}

#Preview {
    LocationRequestView()
}
