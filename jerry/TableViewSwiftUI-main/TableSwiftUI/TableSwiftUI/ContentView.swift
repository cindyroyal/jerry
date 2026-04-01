//
//  ContentView.swift
//  TableSwiftUI
//
//  Created by Gonzalez, Jerardo on 3/25/26.
//

import SwiftUI
import MapKit

let data = [
    Item(name: "Adidas", neighborhood: "Mall", desc: "Diffent shoes stores and sport gear that like to play sport.", fundescription: "This store it sell Adidas shoes and diffent sport gear.", address:"3939 S I-35 South Frontage Rd Suite 770" , lat: 30.273320, long: -97.753550, imageName: "rest1"),
    Item(name: "Puma", neighborhood: "Mall", desc: "deffent types of style it most for people from latin area.", fundescription: "This shoes it become pupoler with mostly hispany people that like this type of shoes.", address:"3939 I-35 Suite 798.",lat: 30.313960, long: -97.719760, imageName: "rest2"),
    Item(name: "Nike", neighborhood: "Mall", desc: "This is most famous among the younger audience, the style of these shoes.", fundescription:"The store they sell Nike,jorden with brand clothes that have the same simbol with the shoes.", address:"1905 Aldrich St.", lat: 30.2962244, long: -97.7079799, imageName: "rest3"),
    Item(name: "JD", neighborhood: "Mall", desc: " This shoe become famost when jordan was one of the gretaest baseball player in all time.",fundescription:"The shoes it become famous with the baseketball player that play in the 80s that won 6 rings.",address:"104 E. 31st St.", lat: 30.295190, long: -97.736540, imageName: "rest4"),
    Item(name: "Convert", neighborhood: "Mall", desc: "this shoes are mostly for scaters.",fundescription:"This store is for more people lake to skateball on the park and ride bikes outisde for a better grip on the board.",address:"4222 Duval St", lat: 30.304890, long: -97.726220, imageName: "rest5")
]


    struct Item: Identifiable {
        let id = UUID()
        let name: String
        let neighborhood: String
        let desc: String
        let fundescription: String
        let address: String
        let lat: Double
        let long: Double
        let imageName: String
    }



struct ContentView: View {
    
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 30.295190, longitude: -97.726220), span: MKCoordinateSpan(latitudeDelta: 0.07, longitudeDelta: 0.07))

    let neighborhoods = ["All"] + Array(Set(data.map { $0.neighborhood })).sorted()
    @State private var selectedCategory = "All"

    var filteredData: [Item] {
        if selectedCategory == "All" {
            return data
        } else {
        return data.filter { $0.neighborhood == selectedCategory }
        }
    }
    
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("Category", selection: $selectedCategory) {
                    ForEach(neighborhoods, id: \.self) { neighborhood in
                    Text(neighborhood).tag(neighborhood)
                }
                }
                .pickerStyle(.menu)
                List(data, id: \.name) { item in
                    NavigationLink(destination: DetailView(item: item)) {
                    HStack {
                        Image(item.imageName)
                            .resizable()
                            .frame(width: 50, height: 50)
                            .cornerRadius(10)
                    VStack(alignment: .leading) {
                            Text(item.name)
                                .font(.headline)
                            Text(item.neighborhood)
                                .font(.subheadline)
                        } // end internal VStack
                    } // end HStack
                    } //end NavigationList
                } // end List
                Map(coordinateRegion: $region, annotationItems: data) { item in
                               MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: item.lat, longitude: item.long)) {
                                   Image(systemName: "mappin.circle.fill")
                                       .foregroundColor(.red)
                                       .font(.title)
                                       .overlay(
                                           Text(item.name)
                                               .font(.subheadline)
                                               .foregroundColor(.black)
                                               .fixedSize(horizontal: true, vertical: false)
                                               .offset(y: 25)
                                       )
                               }
                           } // end map
                           .frame(height: 300)
                           .padding(.bottom, -30)
                
                
                
            } // end VStack
            .listStyle(PlainListStyle())
            .navigationTitle("Austin Restaurants")
                
   
        } // end NavigationView
    } // end body
}


struct DetailView: View {
// initialize variables for Map in Detail View abd set zoom and centering on specific item
@State private var region: MKCoordinateRegion
         
init(item: Item) {
self.item = item
_region = State(initialValue: MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: item.lat, longitude: item.long), span: MKCoordinateSpan(latitudeDelta: 0.20, longitudeDelta: 0.20)))
}
        
let item: Item
               
var body: some View {
VStack {
   Image(item.imageName)
       .resizable()
       .aspectRatio(contentMode: .fit)
       .frame(maxWidth: 200)
   Text("Neighborhood: \(item.neighborhood)")
       .font(.subheadline)

       
   Text((item.address))
       .font(.subheadline)
       .frame(maxWidth: .infinity, alignment: .leading)
       .padding()
   Text("Description: \(item.desc)")
       .font(.subheadline)
       .padding(10)
               
//Map code in Detail View
Map(coordinateRegion: $region, annotationItems: [item]) { item in
    MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: item.lat, longitude: item.long)) {
    Image(systemName: "mappin.circle.fill")
      .foregroundColor(.red)
      .font(.title)
      .overlay(
    Text(item.name)
      .font(.subheadline)
      .foregroundColor(.black)
      .fixedSize(horizontal: true, vertical: false)
      .offset(y: 25)
    )
    }
} // end Map
    .frame(height: 300)
    .padding(.bottom, -60)
    Spacer()
           
    } // end VStack
    .navigationTitle(item.name)
   
        } // end body
     } // end DetailView
   

#Preview {
    ContentView()
}
           
                    
    
