import SwiftUI

struct LocationsView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @EnvironmentObject var model:AppViewModel
    @EnvironmentObject var locationViewModel:LocationViewModel
    //@StateObject var locationViewModel = LocationViewModel()
    
    var body: some View {
        
        NavigationView {
            VStack {
                
                LittleLemonLogoView()
                LittleLemonTitleView(title: "Locations")
                
                /*Text (model.displayingReservationForm ? "Reservation Details" :
                 "Select a location")
                 .padding([.leading, .trailing], 40)
                 .padding([.top, .bottom], 8)
                 .background(Color.gray.opacity(0.2))
                 .cornerRadius(20)*/
                
                //decoupled coredata and view...
                
                /*FetchedObjects(
                 sortDescriptors: buildSortDescriptors()) {
                 (restaurants: [Location]) in
                 List {
                 ForEach(restaurants, id:\.self) { restaurant in
                 NavigationLink(destination: ReservationFormView(Location.mapToRestaurantLocationObject(location: restaurant))) {
                 LocationView(Location.mapToRestaurantLocationObject(location: restaurant))
                 }
                 }
                 }
                 .navigationBarTitle("")
                 .navigationBarHidden(true)
                 /*.searchable(text: $searchText,
                  prompt: "search...")*/
                 }*/
                
                List(locationViewModel.filteredRestaurants, id: \.self) { restaurant in
                    NavigationLink(destination: ReservationFormView(restaurant)) {
                        LocationView(restaurant)
                    }
                }
                .scrollPosition(id: $locationViewModel.scrollPosition)
                .searchable(text: $locationViewModel.searchText, prompt: "search...")
                .refreshable {
                    await locationViewModel.getRestaurants(viewContext)
                }
                //.navigationBarTitle("")
                //.navigationBarHidden(true)
                .background(NavigationBarNoCollapse())
                
            }
            
        }
        .navigationBarTitleDisplayMode(.inline)
        .onDisappear{
            if model.tabBarChanged { return }
            
            // this changes the phrase from "Select a location"
            // to "RESERVATION"
            model.displayingReservationForm = true
        }
        .task {
            await locationViewModel.fetchRestaurants(viewContext)
        }
        
        .frame(maxHeight: .infinity)
        
        // SwiftUI has this space between the title and the list
        // that is amost impossible to remove without incurring
        // into complex steps that run out of the scope of this
        // course, so, this is a hack, to bring the list up
        // try to comment this line and see what happens.
        //.padding(.top, -10)
        
        // makes the list background invisible, default is gray
        .scrollContentBackground(.hidden)
        
    }
    
    /*private func buildPredicate() -> NSPredicate {
     return searchText == "" ?
     NSPredicate(value: true) :
     NSPredicate(format: "phoneNumber CONTAINS[cd] %@", searchText)
     }
     
     private func buildSortDescriptors() -> [NSSortDescriptor] {
     [NSSortDescriptor(key: "city",
     ascending: true,
     selector:
     #selector(NSString.localizedStandardCompare))]
     }*/
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LocationsView().environmentObject(AppViewModel())
    }
}
