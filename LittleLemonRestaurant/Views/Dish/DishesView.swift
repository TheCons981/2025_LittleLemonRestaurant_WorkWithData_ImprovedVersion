import SwiftUI
import CoreData

struct DishesView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @EnvironmentObject var dishViewModel: DishViewModel
    @State private var showAlert = false
    //@State var searchText = ""
    
    var body: some View {
        VStack {
            LittleLemonLogoView()
                .padding(.bottom, 10)
                .padding(.top, 50)
            
            Text ("Tap to order")
                .foregroundColor(.black)
                .padding([.leading, .trailing], 40)
                .padding([.top, .bottom], 8)
                .background(Color("approvedYellow"))
                .cornerRadius(20)
            
            
            NavigationView {
                List {
                    ForEach(dishViewModel.filteredMenuItems, id:\.id) { dish in
                        DishDetailView(dish)
                            .onTapGesture {
                                showAlert.toggle()
                            }
                            .id(dish.id)
                    }
                }
                .scrollPosition(id: $dishViewModel.scrollPosition)
                .searchable(text: $dishViewModel.searchText,prompt: "search...")
                .refreshable {
                    await dishViewModel.getDishes(viewContext)
                }
                .background(NavigationBarNoCollapse())
                /*FetchedObjects(
                 predicate:buildPredicate(),
                 sortDescriptors: buildSortDescriptors()) {
                 (dishes: [Dish]) in
                 List {
                 ForEach(dishes, id:\.self) { dish in
                 DishDetailView(dish)
                 .onTapGesture {
                 showAlert.toggle()
                 }
                 }
                 }
                 .searchable(text: $searchText,
                 prompt: "search...")
                 }*/
            }
            
            // SwiftUI has this space between the title and the list
            // that is amost impossible to remove without incurring
            // into complex steps that run out of the scope of this
            // course, so, this is a hack, to bring the list up
            // try to comment this line and see what happens.
            //.padding(.top, -10)//
            
            .alert("Order placed, thanks!",
                   isPresented: $showAlert) {
                Button("OK", role: .cancel) { }
            }
            
            // makes the list background invisible, default is gray
                   .scrollContentBackground(.hidden)
            
            // runs when the view appears
                   .task {
                       await dishViewModel.fetchMenuItems(viewContext)
                   }
            
            
        }
    }
    
    /*private func buildPredicate() -> NSPredicate {
     return searchText == "" ?
     NSPredicate(value: true) :
     NSPredicate(format: "name CONTAINS[cd] %@", searchText)
     }
     
     private func buildSortDescriptors() -> [NSSortDescriptor] {
     [NSSortDescriptor(key: "name",
     ascending: true,
     selector:
     #selector(NSString.localizedStandardCompare))]
     }*/
}

struct DishesView_Previews: PreviewProvider {
    static var previews: some View {
        DishesView()
    }
}






