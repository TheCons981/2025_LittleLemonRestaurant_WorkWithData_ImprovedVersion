import SwiftUI
import CoreData

struct MainView: View {
    //@Environment(\.managedObjectContext) private var viewContext
    
    @StateObject var model = Model()
    @StateObject var locationViewModel = LocationViewModel()
    @StateObject var dishViewModel = DishViewModel()
    
    @State var tabSelection = 0
    @State var previousTabSelection = -1 // any invalid value
    
    var body: some View {
        TabView (selection: $model.tabViewSelectedIndex){
            LocationsView()
                .tag(0)
                .tabItem {
                    if !model.displayingReservationForm {
                        Label("Locations", systemImage: "fork.knife")
                    }
                }
                .onAppear() {
                    tabSelection = 0
                }
                .environmentObject(locationViewModel)
            
            DishesView()
                .tag(1)
                .tabItem {
                    if !model.displayingReservationForm {
                        Label("Our Dishes", systemImage: "fork.knife.circle")
                    }
                }
                .onAppear() {
                    tabSelection = 1
                }
                .environmentObject(dishViewModel)
//                .environmentObject(viewContext)

            
            ReservationView()
                .tag(2)
                .tabItem {
                    if !model.displayingReservationForm {
                        Label("Reservation", systemImage: "square.and.pencil")
                    }
                }
                .onAppear() {
                    tabSelection = 2
                }
        }
        //.id(tabSelection)
        .environmentObject(model)
        
        
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView().environmentObject(Model())
    }
}




