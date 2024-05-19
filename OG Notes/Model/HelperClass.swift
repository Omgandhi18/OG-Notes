//
//  HelperClass.swift
//  OG Notes
//
//  Created by Om Gandhi on 19/05/24.
//

import Foundation
import LocalAuthentication
extension LAContext {
    enum BiometricType: String {
        case none
        case touchID
        case faceID
        case opticID // Added a case for potential future biometric methods
    }

    // Returns the detected biometric type based on the capabilities of the device
    var biometricType: BiometricType {
        var error: NSError?

        // Check if the device supports biometric authentication
        guard self.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            return .none
        }

        if #available(iOS 11.0, *) {
            // Determine the specific biometric type supported on iOS 11.0 and later
            switch self.biometryType {
            case .none:
                return .none
            case .touchID:
                return .touchID
            case .faceID:
                return .faceID
            default:
                if #available(iOS 17.0, *) {
                    // Support for potential future biometric methods
                    if self.biometryType == .opticID {
                        return .opticID
                    } else {
                        return .none
                    }
                }
            }
        }

        // Fallback to checking for Touch ID support on iOS versions older than 11.0
        return self.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) ? .touchID : .none
    }
}
