import UIKit

protocol Parkable {
    var plate: String { get }
    var type: VehicleType { get }
    var checkInTime: Date { get set }
    var discountCard: String? { get set}
    var parkedTime: Int { get }

}

struct Parking {
    private var vehicles: Set<Vehicle> = []
    let maxSpace = 20
    
    // Minutes that have a fixed cost
    private let baseTime = 120
    
    // Range of minutes to collect money after base time
    private let afterMinutes = 15
    private let afterMinutesTariff = 5
    
    private let cardDiscount = 0.15
    
    //  TODO: better name this var
    var tuple: (removedVehicles:Int, earnings: Int) = (0, 0)
    
    
    
    mutating func checkInVehicle(_ vehicle: Vehicle, onFinish:(Bool) -> Void) {
        // Check if there's space
        guard vehicles.count < maxSpace else {
            onFinish(false)
            return
        }
        
        // Check that vehicle is not already in the Set
        guard !vehicles.contains(vehicle) else {
            onFinish(false)
            return
        }
        
        
        // Everything is okay to insert new vehicule
        vehicles.insert(vehicle)
        onFinish(true)
    }
    
    
    mutating func checkOutVehicle(plate: String, onSuccess: (Int) -> Void, onError: () -> Void) {
        // Check if given plate is already in the Set
        if let index = vehicles.firstIndex(where: { $0.plate == plate}) {
            let removedVehicle = vehicles.remove(at: index)
            let hasDiscountCard = removedVehicle.discountCard != nil
            
            let fee = calculateFee(type: removedVehicle.type, parkedTime: removedVehicle.parkedTime, hasDiscountCard: hasDiscountCard)
            
            // Update tuple
            tuple.removedVehicles += 1
            tuple.earnings += fee
            
            onSuccess(fee)
        
        // Vehicle with given plate is no in the Set
        } else {
            onError()
        }
    }

    func calculateFee(type: VehicleType, parkedTime: Int, hasDiscountCard: Bool) -> Int {
        var fee = 0
        let basePrice = type.tariff
        
        if parkedTime <= baseTime {
            // Vehicle pays only base price
            fee = basePrice
            
        } else {
            // Vehicle pays base price plus extra minutes
           
            let extraMinutes = parkedTime - baseTime
            
            // Calculate extra minutes blocks of time, rounding up
            let extraMinutesBlocks = ceil(Double(extraMinutes) / Double(afterMinutes))
            let extraMinutesPrice = Int(extraMinutesBlocks) * afterMinutesTariff
            
            fee = basePrice + extraMinutesPrice
        }
        
        
        // Apply discount if there is one
        if hasDiscountCard {
            let discount = Double(fee) * cardDiscount
            fee -= Int(discount)
        }
        return fee
    }
    
    func showInfo() {
        print("\(tuple.removedVehicles) vehicles have checked out and have earnings of $\(tuple.earnings)")
    }
   
    func listVehicles() {
        for vehicle in vehicles {
            print(vehicle.plate)
        }
    }
}


struct Vehicle: Parkable, Hashable {
 
    let plate: String
    let type: VehicleType
    var checkInTime: Date
    var discountCard: String?
    
    var parkedTime: Int {
        let minutes = Calendar.current.dateComponents([.minute], from: checkInTime, to: Date()).minute ?? 0
        return minutes
    }

    
    func hash(into hasher: inout Hasher) {
        hasher.combine(plate)
    }
    
    static func ==(lhs: Vehicle, rhs: Vehicle) -> Bool {
        return lhs.plate == rhs.plate
    }
}



enum VehicleType {
    case car, moto, miniBus, bus
    
    var tariff: Int {
        switch self {
        case .car:
            return 20
        case .moto:
            return 15
        case .miniBus:
            return 25
        case .bus:
            return 30
        }
    }
}

// Test 1
//var alkeParking = Parking()
//let car = Vehicle(plate: "AA111AA", type: .car, checkInTime: Date(), discountCard: "DISCOUNT_CARD_001")
//let moto = Vehicle(plate: "B222BBB", type: .moto, checkInTime: Date(), discountCard: nil)
//let miniBus = Vehicle(plate: "CC333CC", type: .miniBus, checkInTime: Date(), discountCard: nil)
//let bus = Vehicle(plate: "DD444DD", type: .bus, checkInTime: Date(), discountCard: "DISCOUNT_CARD_002")
//
//alkeParking.vehicles.insert(car)
//alkeParking.vehicles.insert(moto)
//alkeParking.vehicles.insert(miniBus)
//alkeParking.vehicles.insert(bus)
//
//
//let car0 = Vehicle(plate: "AA111AA", type: .car, checkInTime: Date(), discountCard: "DISCOUNT_CARD_001")
//let car2 = Vehicle(plate: "AA111AA", type: .car, checkInTime: Date(), discountCard: "DISCOUNT_CARD_003")
//print(alkeParking.vehicles.insert(car0).inserted)
//print(alkeParking.vehicles.insert(car2).inserted)
//
//alkeParking.vehicles.remove(moto)


// Test 2
//var alkeParking = Parking()
//let vehicle1 = Vehicle(plate: "AA111AA", type: .car, checkInTime: Date(), discountCard:"DISCOUNT_CARD_001")
//let vehicle2 = Vehicle(plate: "B222BBB", type: .moto, checkInTime: Date(), discountCard: nil)
//let vehicle3 = Vehicle(plate: "CC333CC", type: .miniBus, checkInTime: Date(), discountCard: nil)
//let vehicle4 = Vehicle(plate: "DD444DD", type: .bus, checkInTime: Date(), discountCard: "DISCOUNT_CARD_002")
//let vehicle5 = Vehicle(plate: "AA111BB", type: .car, checkInTime: Date(), discountCard: "DISCOUNT_CARD_003")
//let vehicle6 = Vehicle(plate: "B222CCC", type: .moto, checkInTime: Date(), discountCard:  "DISCOUNT_CARD_004")
//let vehicle7 = Vehicle(plate: "CC333DD", type: .miniBus, checkInTime: Date(), discountCard: nil)
//let vehicle8 = Vehicle(plate: "DD444EE", type: .bus, checkInTime: Date(), discountCard: "DISCOUNT_CARD_005")
//let vehicle9 = Vehicle(plate: "AA111CC", type: .car, checkInTime: Date(), discountCard: nil)
//let vehicle10 = Vehicle(plate: "B222DDD", type: .moto, checkInTime: Date(), discountCard: nil)
//let vehicle11 = Vehicle(plate: "CC333EE", type: .miniBus, checkInTime: Date(), discountCard: nil)
//let vehicle12 = Vehicle(plate: "DD444GG", type: .bus, checkInTime: Date(), discountCard: "DISCOUNT_CARD_006")
//let vehicle13 = Vehicle(plate: "AA111DD", type: .car, checkInTime: Date(), discountCard: "DISCOUNT_CARD_007")
//let vehicle14 = Vehicle(plate: "B222EEE", type: .moto, checkInTime: Date(), discountCard: nil)
//let vehicle15 = Vehicle(plate: "CC333FF", type: .miniBus, checkInTime: Date(), discountCard: nil)
//let vehicle16 = Vehicle(plate: "B222DDxxx", type: .moto, checkInTime: Date(), discountCard: nil)
//let vehicle17 = Vehicle(plate: "CC333Exx", type: .miniBus, checkInTime: Date(), discountCard: nil)
//let vehicle18 = Vehicle(plate: "DD444Gx", type: .bus, checkInTime: Date(), discountCard: "DISCOUNT_CARD_006")
//let vehicle19 = Vehicle(plate: "AA111Dx", type: .car, checkInTime: Date(), discountCard: "DISCOUNT_CARD_007")
//let vehicle20 = Vehicle(plate: "B222EExx", type: .moto, checkInTime: Date(), discountCard: nil)
//let vehicle21 = Vehicle(plate: "B222EExxx", type: .moto, checkInTime: Date(), discountCard: nil)
//
//
//var testVehicles = [vehicle1, vehicle2, vehicle3, vehicle4, vehicle5, vehicle6, vehicle7, vehicle8, vehicle9, vehicle10, vehicle11, vehicle12, vehicle13, vehicle14, vehicle15, vehicle16, vehicle17, vehicle18, vehicle19, vehicle20, vehicle21]
//
//
//for vehicle in testVehicles {
//    alkeParking.checkInVehicle(vehicle) { success in
//        if success {
//            print("Welcome to AlkeParking!")
//        } else {
//            print("Sorry, the check-in failed")
//        }
//    }
//}
//
//
//
//alkeParking.checkOutVehicle(plate: "AA111AA",
//        onSuccess: { fee in print("Your fee is \(fee). Come back soon.")},
//        onError: { print("Sorry, the check-out failed")})
