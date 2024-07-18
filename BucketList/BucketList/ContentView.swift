//
//  ContentView.swift
//  BucketList
//
//  Created by Rohit Deshmukh on 22/08/23.
//

import SwiftUI
import MapKit

struct ContentView: View {
@StateObject private var viewModel = ViewModel()
    
    var body: some View {
        if viewModel.isUnlocked {
            ZStack {
                Map(coordinateRegion: $viewModel.mapRegion, annotationItems: viewModel.locations) { location in
                    MapAnnotation(coordinate: location.coordinate) {
                        VStack {
                            Image(systemName: "star.circle")
                                .resizable()
                                .foregroundColor(.yellow)
                                .frame(width: 44, height: 44)
                                .background(.white)
                                .clipShape(Circle())
                            
                            Text(location.name)
                                .fixedSize()
                        }
                        .onTapGesture {
                            viewModel.selectedPlace = location
                        }
                    }
                }
                .ignoresSafeArea()
                
                Circle()
                    .fill(.blue)
                    .opacity(0.3)
                    .frame(width: 32, height: 32)
                
                VStack {
                    Spacer()
                    
                    Button {
                        viewModel.addLocation()
                    } label: {
                        Image(systemName: "plus")
                            .padding()
                            .background(.black.opacity(0.75))
                            .foregroundColor(.white)
                            .font(.title)
                            .clipShape(Circle())
                            .padding(.trailing)
                    }
                }
            }
            .sheet(item: $viewModel.selectedPlace) { place in
                EditView(location: place) { newLocation in
                    viewModel.update(location: newLocation)
                }
            }
        } else {
            Button("Unlock Places") {
                viewModel.authenticate()
            }
            .padding()
            .background(.blue)
            .foregroundColor(.white)
            .clipShape(Capsule())
            .alert("Authentication Error", isPresented: $viewModel.showingAlert) {
                Button("Continue") { }
            } message: {
                Text(viewModel.alertMessage)
            }
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

/*
 X-------------------------------------------------------------------------X
 
 import SwiftUI

 struct User: Identifiable, Comparable {
     static func < (lhs: User, rhs: User) -> Bool {
         return lhs.lastName < rhs.lastName
     }
     
     let id = UUID()
     let firstName: String
     let lastName: String
 }


 struct ContentView: View {
     
     let users = [
         User(firstName: "Arnold", lastName: "Rimmer"),
         User(firstName: "Kristine", lastName: "Kochanski"),
         User(firstName: "David", lastName: "Lister")
     ].sorted()
     
     var body: some View {
         List(users) { user in
             Text("\(user.firstName) \(user.lastName)")
         }
     }
 }

 struct ContentView_Previews: PreviewProvider {
     static var previews: some View {
         ContentView()
     }
 }
 
 X-------------------------------------------------------------------------X
 
 import SwiftUI

 struct ContentView: View {
     var body: some View {
         Text("Hello world")
             .onTapGesture {
                 let str = "Test Message"
                 let url = getDocumentsDirectory().appendingPathComponent("message.txt")
                 
                 do {
                     try str.write(to: url, atomically: true, encoding: .utf8)
                     
                     let input = try String(contentsOf: url)
                     print(input)
                 } catch {
                     print(error.localizedDescription)
                 }
             }
     }
     
     func getDocumentsDirectory() -> URL {
         let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
         return paths[0]
     }
 }

 struct ContentView_Previews: PreviewProvider {
     static var previews: some View {
         ContentView()
     }
 }
 
 X-------------------------------------------------------------------------X
 
 import SwiftUI

 enum LoadingState {
     case loading, success, failed
 }

 struct LoadingView: View {
     var body: some View {
         Text("Loading...")
     }
 }

 struct SuccessView: View {
     var body: some View {
         Text("Success!!!")
     }
 }

 struct FailedView: View {
     var body: some View {
         Text("Failed!!!")
     }
 }

 struct ContentView: View {
     var loadingState = LoadingState.loading
     var body: some View {
         switch loadingState {
         case .loading:
             LoadingView()
         case .success:
             SuccessView()
         case .failed:
             FailedView()
         }
     }
 }

 struct ContentView_Previews: PreviewProvider {
     static var previews: some View {
         ContentView()
     }
 }
 
 X-------------------------------------------------------------------------X
 
 import SwiftUI
 import MapKit

 struct Location: Identifiable {
     let id = UUID()
     let name: String
     let coordinate: CLLocationCoordinate2D
 }

 struct ContentView: View {
     @State private var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.5, longitude: -0.12), span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
     
     let locations = [
         Location(name: "Buckingham Palace", coordinate: CLLocationCoordinate2D(latitude: 51.501, longitude: -0.141)),
         Location(name: "Buckingham Palace", coordinate: CLLocationCoordinate2D(latitude: 51.508, longitude: -0.076))]
     
     var body: some View {
         Map(coordinateRegion: $mapRegion, annotationItems: locations) { location in
             MapAnnotation(coordinate: location.coordinate) {
                 VStack {
                     Circle()
                         .stroke(.red, lineWidth: 3)
                         .frame(width: 44, height: 44)
                         .onTapGesture {
                             print("Tapped on \(location.name)")
                         }
                 }
             }
         }
     }
 }

 struct ContentView_Previews: PreviewProvider {
     static var previews: some View {
         ContentView()
     }
 }
 
 X-------------------------------------------------------------------------X
 
 import SwiftUI
 import LocalAuthentication

 struct ContentView: View {
     
     @State private var isUnlocked = false
     
     var body: some View {
         VStack {
             if isUnlocked {
                 Text("Unlocked")
             } else {
                 Text("Locked")
             }
         }
         .onAppear(perform: authenticate)
     }
     
     func authenticate() {
         let context = LAContext()
         var error: NSError?
         
         if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
             let reason = "We need to unlock your data"
             
             context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenicationError in
                 if success {
                     isUnlocked = true
                 } else {
                     
                 }
             }
         } else {
             
         }
         
     }
 }

 struct ContentView_Previews: PreviewProvider {
     static var previews: some View {
         ContentView()
     }
 }
 
 X-------------------------------------------------------------------------X

 */
