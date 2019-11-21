//
//  RideRequestHandler.swift
//  RideRequestExtension
//
//  Created by Das on 11/21/19.
//  Copyright © 2019 ArunabhDas. All rights reserved.
//

import Foundation
import Intents

class RideRequestHandler: NSObject, INRequestRideIntentHandling {
    
    func handle(intent: INRequestRideIntent, completion: @escaping (INRequestRideIntentResponse) -> Void) {
        let response = INRequestRideIntentResponse(code: .failureRequiringAppLaunchNoServiceInArea, userActivity: .none)
        completion(response)
    }
    
    func resolvePickupLocation(for intent: INRequestRideIntent, with completion: @escaping (INPlacemarkResolutionResult) -> Void) {
        if let pickup = intent.pickupLocation {
            completion(.success(with: pickup))
        } else {
            completion(.needsValue())
        }
    }
}
