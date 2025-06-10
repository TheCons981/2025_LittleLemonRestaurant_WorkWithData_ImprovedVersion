import SwiftUI

struct ReservationView: View {
    @EnvironmentObject var model:AppViewModel
    
    var body: some View {
        // you can create variables inside body
        // to help you reduce code repetition
        let restaurant = model.reservation.restaurant
        
        ScrollView {
            VStack {
                LittleLemonLogoView()
                    .padding(.bottom, 20)
                
                if restaurant.city.isEmpty {
                    
                    VStack {
                        // if city is empty no reservation has been
                        // selected yet, so, show the following message
                        Text("No reservation yet")
                            .foregroundColor(.gray)
                    }
                    .frame(maxHeight:.infinity)
                    
                    
                } else {
                    
                    LittleLemonTitleView(title: "Reservation")
                    
                    
                    HStack {
                        VStack (alignment: .leading) {
                            Text("Restaurant")
                                .font(.subheadline)
                                .padding(.bottom, 5)
                            LocationView(restaurant)
                        }
                        Spacer()
                    }
                    .frame(maxWidth:.infinity)
                    .padding(.bottom, 20)
                    
                    Divider()
                        .padding(.bottom, 20)
                    
                    
                    VStack {
                        HStack {
                            Text("Name: ")
                                .foregroundColor(.gray)
                                .font(.subheadline)
                            
                            Text(model.reservation.customerName)
                            Spacer()
                        }
                        
                        HStack {
                            Text("E-mail: ")
                                .foregroundColor(.gray)
                                .font(.subheadline)
                            
                            Text(model.reservation.customerEmail)
                            Spacer()
                        }
                        
                        HStack {
                            Text("Phone: ")
                                .foregroundColor(.gray)
                                .font(.subheadline)
                            
                            Text(model.reservation.customerPhoneNumber)
                            Spacer()
                        }
                        
                    }
                    .padding(.bottom, 20)
                    
                    
                    HStack {
                        Text("Party: ")
                            .foregroundColor(.gray)
                        
                            .font(.subheadline)
                        
                        Text("\(model.reservation.party)")
                        Spacer()
                    }
                    .padding(.bottom, 20)
                    
                    VStack {
                        HStack {
                            Text("Date: ")
                                .foregroundColor(.gray)
                                .font(.subheadline)
                            
                            Text(model.reservation.reservationDate, style: .date)
                            Spacer()
                        }
                        
                        HStack {
                            Text("Time: ")
                                .foregroundColor(.gray)
                                .font(.subheadline)
                            
                            Text(model.reservation.reservationDate, style: .time)
                            Spacer()
                        }
                    }
                    .padding(.bottom, 20)
                    
                    HStack {
                        VStack (alignment: .leading) {
                            Text("Special Requests:")
                                .foregroundColor(.gray)
                                .font(.subheadline)
                            Text(model.reservation.specialRequests)
                        }
                        Spacer()
                    }
                    .frame(maxWidth:.infinity)
                    
                }
            }
        }
        .padding()
    }
}

struct ReservationView_Previews: PreviewProvider {
    static var previews: some View {
        ReservationView().environmentObject(AppViewModel())
    }
}






