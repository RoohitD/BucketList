//
//  EditView.swift
//  BucketList
//
//  Created by Rohit Deshmukh on 22/08/23.
//

import SwiftUI

struct EditView: View {
    
    var location: Location
    
    @StateObject private var editViewModel: ViewModel
    
    var onSave: (Location) -> Void
    
    @Environment(\.dismiss) var dismiss

    init(location: Location, onSave: @escaping (Location) -> Void) {
        self.location = location
        self.onSave = onSave
        _editViewModel = StateObject(wrappedValue: ViewModel(location: location, onSave: onSave))
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Place Name", text: $editViewModel.name)
                    TextField("Description", text: $editViewModel.description)
                }
                
                Section ("Nearby..") {
                    switch editViewModel.loadingState {
                    case .loading:
                        Text("Loading")
                    case .loaded:
                        ForEach(editViewModel.pages, id: \.pageid) { page in
                            /*@START_MENU_TOKEN@*/Text(page.title)/*@END_MENU_TOKEN@*/
                                .font(.headline)
                            + Text(": ")
                            + Text(page.description)
                                .italic()
                        }
                    case .failed:
                        Text("Please try again later.")
                    }
                }
            }
            .navigationTitle("Place Details")
            .toolbar {
                Button("Save") {
                    var newLocation = editViewModel.location
                    newLocation.id = UUID()
                    newLocation.name = editViewModel.name
                    newLocation.description = editViewModel.description
                    
                    editViewModel.onSave(newLocation)
                    
                    dismiss()
                }
            }
            .task {
                await editViewModel.fetchNearbyPlaces()
            }
        }
    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView(location: Location.example) { _ in }
    }
}
