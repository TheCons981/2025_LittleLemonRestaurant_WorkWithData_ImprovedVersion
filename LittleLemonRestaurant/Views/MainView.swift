import SwiftUI
import CoreData

struct MainView: View {
    
    @EnvironmentObject var model: AppViewModel
    
    @StateObject var locationViewModel = LocationViewModel()
    @StateObject var dishViewModel = DishViewModel()
    @StateObject var reservationViewModel = ReservationViewModel()
    
    @State var tabSelection = 0
    @State var previousTabSelection = -1 // any invalid value
    
    var body: some View {
        TabView (selection: $model.tabViewSelectedIndex){
            LocationsView()
                .tag(0)
                .tabItem {
                    Label("Locations", systemImage: "fork.knife")
                }
                .onAppear() {
                    tabSelection = 0
                }
                .environmentObject(locationViewModel)
                .environmentObject(reservationViewModel)
            
            DishesView()
                .tag(1)
                .tabItem {
                    Label("Our Dishes", systemImage: "fork.knife.circle")
                }
                .onAppear() {
                    tabSelection = 1
                }
                .environmentObject(dishViewModel)

            
            ReservationView()
                .tag(2)
                .tabItem {
                    Label("Reservation", systemImage: "square.and.pencil")
                }
                .onAppear() {
                    tabSelection = 2
                }
                .environmentObject(reservationViewModel)
        }
        .environmentObject(model)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(locationViewModel: LocationViewModel(), dishViewModel: DishViewModel(), reservationViewModel: ReservationViewModel(), tabSelection: 0, previousTabSelection: -1)
            .environmentObject(AppViewModel())
            .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
           
    }
}




