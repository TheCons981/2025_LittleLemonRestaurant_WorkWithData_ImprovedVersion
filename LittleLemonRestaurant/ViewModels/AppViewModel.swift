import Foundation
import CoreData

@MainActor
class AppViewModel:ObservableObject {
    @Published var tabBarChanged = false
    @Published var tabViewSelectedIndex = Int.max {
        didSet {
            tabBarChanged = true
        }
    }
}
