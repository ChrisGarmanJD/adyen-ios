//
// Copyright (c) 2020 Adyen N.V.
//
// This file is open source and available under the MIT license. See the LICENSE file for more info.
//

import Foundation

/// Validates a phone number.
/// :nodoc:
internal final class PhoneNumberValidator: RegularExpressionValidator {
    
    internal init() {
        let regex = #"^[+]*[0-9]{1,4}[\s0-9]*$"#
        super.init(regularExpression: regex, minimumLength: 2, maximumLength: 20)
    }
    
}