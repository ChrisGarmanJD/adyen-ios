//
// Copyright (c) 2022 Adyen N.V.
//
// This file is open source and available under the MIT license. See the LICENSE file for more info.
//

import Foundation
import UIKit

@_spi(AdyenInternal)
public enum AddressField: String, CaseIterable {
    case street
    case houseNumberOrName
    case apartment
    case postalCode
    case city
    case stateOrProvince
    case country
}

@_spi(AdyenInternal)
public enum AddressFormScheme {
    public var  children: [AddressField] {
        switch self {
        case .item(let item): return [item]
        case .split(let item1, let item2): return [item1, item2]
        }
    }
    case item(AddressField)
    case split(AddressField, AddressField)
}

@_spi(AdyenInternal)
public struct AddressViewModel {

    internal var labels: [AddressField: LocalizationKey]
    internal var placeholder: [AddressField: LocalizationKey]

    @_spi(AdyenInternal)
    public var optionalFields: [AddressField]

    @_spi(AdyenInternal)
    public var scheme: [AddressFormScheme]

    public init(labels: [AddressField: LocalizationKey],
                placeholder: [AddressField: LocalizationKey],
                optionalFields: [AddressField],
                scheme: [AddressFormScheme]) {
        self.labels = labels
        self.placeholder = placeholder
        self.optionalFields = optionalFields
        self.scheme = scheme
    }

}

extension AddressField {

    internal var contentType: UITextContentType? {
        switch self {
        case .street:
            return .streetAddressLine1
        case .houseNumberOrName:
            return .streetAddressLine2
        case .apartment:
            return nil
        case .postalCode:
            return .postalCode
        case .city:
            return .addressCity
        case .stateOrProvince:
            return .addressState
        case .country:
            return .countryName
        }
    }

}
