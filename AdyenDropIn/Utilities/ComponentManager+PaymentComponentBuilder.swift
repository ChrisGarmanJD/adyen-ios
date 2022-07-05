//
// Copyright (c) 2022 Adyen N.V.
//
// This file is open source and available under the MIT license. See the LICENSE file for more info.
//

@_spi(AdyenInternal) import Adyen
#if canImport(AdyenCard)
    @_spi(AdyenInternal) import AdyenCard
#endif
#if canImport(AdyenComponents)
    @_spi(AdyenInternal) import AdyenComponents
#endif
#if canImport(AdyenActions)
    @_spi(AdyenInternal) import AdyenActions
#endif
import Foundation

extension ComponentManager: PaymentComponentBuilder {

    private var paymen: Payment? {
        if let payment = configuration.payment, let remainingAmount = order?.remainingAmount {
            return Payment(amount: remainingAmount, countryCode: payment.countryCode)
        } else {
            return configuration.payment
        }
    }

    internal func build(paymentMethod: StoredCardPaymentMethod) -> PaymentComponent? {
        createCardComponent(with: paymentMethod)
    }

    internal func build(paymentMethod: StoredPaymentMethod) -> PaymentComponent? {
        StoredPaymentMethodComponent(paymentMethod: paymentMethod,
                                     context: context,
                                     configuration: .init(payment: paymen,
                                                          localizationParameters: configuration.localizationParameters))
    }

    internal func build(paymentMethod: StoredBCMCPaymentMethod) -> PaymentComponent? {
        StoredPaymentMethodComponent(paymentMethod: paymentMethod,
                                     context: context,
                                     configuration: .init(payment: paymen,
                                                          localizationParameters: configuration.localizationParameters))
    }

    internal func build(paymentMethod: CardPaymentMethod) -> PaymentComponent? {
        createCardComponent(with: paymentMethod)
    }

    internal func build(paymentMethod: BCMCPaymentMethod) -> PaymentComponent? {
        createBancontactComponent(with: paymentMethod)
    }

    internal func build(paymentMethod: IssuerListPaymentMethod) -> PaymentComponent? {
        IssuerListComponent(paymentMethod: paymentMethod,
                            context: context,
                            configuration: .init(style: configuration.style.listComponent,
                                                 payment: nil,
                                                 localizationParameters: configuration.localizationParameters))
    }

    internal func build(paymentMethod: SEPADirectDebitPaymentMethod) -> PaymentComponent? {
        createSEPAComponent(paymentMethod)
    }

    internal func build(paymentMethod: BACSDirectDebitPaymentMethod) -> PaymentComponent? {
        createBACSDirectDebit(paymentMethod)
    }

    internal func build(paymentMethod: ACHDirectDebitPaymentMethod) -> PaymentComponent? {
        createACHDirectDebitComponent(paymentMethod)
    }

    internal func build(paymentMethod: ApplePayPaymentMethod) -> PaymentComponent? {
        createPreApplePayComponent(with: paymentMethod)
    }

    internal func build(paymentMethod: WeChatPayPaymentMethod) -> PaymentComponent? {
        guard let classObject = loadTheConcreteWeChatPaySDKActionComponentClass() else { return nil }
        guard classObject.isDeviceSupported() else { return nil }
        return InstantPaymentComponent(paymentMethod: paymentMethod,
                                       context: context,
                                       amount: paymen?.amount,
                                       order: order)
    }

    internal func build(paymentMethod: QiwiWalletPaymentMethod) -> PaymentComponent? {
        createQiwiWalletComponent(paymentMethod)
    }

    internal func build(paymentMethod: MBWayPaymentMethod) -> PaymentComponent? {
        createMBWayComponent(paymentMethod)
    }

    internal func build(paymentMethod: BLIKPaymentMethod) -> PaymentComponent? {
        createBLIKComponent(paymentMethod)
    }

    internal func build(paymentMethod: EContextPaymentMethod) -> PaymentComponent? {
        let config = BasicPersonalInfoFormComponent.Configuration(style: configuration.style.formComponent,
                                                                  payment: paymen,
                                                                  shopperInformation: configuration.shopperInformation,
                                                                  localizationParameters: configuration.localizationParameters)
        return BasicPersonalInfoFormComponent(paymentMethod: paymentMethod,
                                              context: context,
                                              configuration: config)
    }

    internal func build(paymentMethod: DokuPaymentMethod) -> PaymentComponent? {
        let config = DokuComponent.Configuration(style: configuration.style.formComponent,
                                                 payment: paymen,
                                                 shopperInformation: configuration.shopperInformation,
                                                 localizationParameters: configuration.localizationParameters)
        return DokuComponent(paymentMethod: paymentMethod,
                             context: context,
                             configuration: config)
    }

    internal func build(paymentMethod: GiftCardPaymentMethod) -> PaymentComponent? {
        guard let amount = configuration.payment?.amount, partialPaymentEnabled else { return nil }
        return GiftCardComponent(paymentMethod: paymentMethod,
                                 context: context,
                                 amount: amount,
                                 style: configuration.style.formComponent)
    }

    internal func build(paymentMethod: BoletoPaymentMethod) -> PaymentComponent? {
        createBoletoComponent(paymentMethod)
    }

    internal func build(paymentMethod: AffirmPaymentMethod) -> PaymentComponent? {
        let config = AffirmComponent.Configuration(style: configuration.style.formComponent,
                                                   payment: paymen,
                                                   shopperInformation: configuration.shopperInformation,
                                                   localizationParameters: configuration.localizationParameters)
        return AffirmComponent(paymentMethod: paymentMethod,
                               context: context,
                               configuration: config)
    }

    internal func build(paymentMethod: PaymentMethod) -> PaymentComponent? {
        InstantPaymentComponent(paymentMethod: paymentMethod,
                                context: context,
                                amount: paymen?.amount,
                                order: order)
    }

    internal func build(paymentMethod: AtomePaymentMethod) -> PaymentComponent? {
        let config = AtomeComponent.Configuration(style: configuration.style.formComponent,
                                                  payment: paymen,
                                                  shopperInformation: configuration.shopperInformation,
                                                  localizationParameters: configuration.localizationParameters)
        return AtomeComponent(paymentMethod: paymentMethod,
                              context: context,
                              configuration: config)
    }

    private func createCardComponent(with paymentMethod: AnyCardPaymentMethod) -> PaymentComponent? {
        var cardConfiguration = configuration.card.cardComponentConfiguration
        cardConfiguration.style = configuration.style.formComponent
        cardConfiguration.localizationParameters = configuration.localizationParameters
        cardConfiguration.shopperInformation = configuration.shopperInformation
        cardConfiguration.payment = paymen
        return CardComponent(paymentMethod: paymentMethod,
                             context: context,
                             configuration: cardConfiguration)
    }

    private func createBancontactComponent(with paymentMethod: BCMCPaymentMethod) -> PaymentComponent? {
        let cardConfiguration = configuration.card
        let configuration = CardComponent.Configuration(style: configuration.style.formComponent,
                                                        payment: paymen,
                                                        shopperInformation: configuration.shopperInformation,
                                                        localizationParameters: configuration.localizationParameters,
                                                        showsHolderNameField: cardConfiguration.showsHolderNameField,
                                                        showsStorePaymentMethodField: cardConfiguration.showsStorePaymentMethodField,
                                                        showsSecurityCodeField: cardConfiguration.showsSecurityCodeField,
                                                        storedCardConfiguration: cardConfiguration.stored)

        return BCMCComponent(paymentMethod: paymentMethod,
                             context: context,
                             configuration: configuration)
    }

    private func createPreApplePayComponent(with paymentMethod: ApplePayPaymentMethod) -> PaymentComponent? {
        guard let applePay = configuration.applePay else {
            adyenPrint("Failed to instantiate ApplePayComponent because ApplePayConfiguration is missing")
            return nil
        }

        let preApplePayConfig = PreApplePayComponent.Configuration(style: configuration.style.applePay,
                                                                   localizationParameters: configuration.localizationParameters)

        if let amount = order?.remainingAmount {
            let localIdentifier = amount.localeIdentifier ?? configuration.localizationParameters?.locale
            let configuration = applePay.updating(amount: amount, localeIdentifier: localIdentifier)
            if let component = try? PreApplePayComponent(paymentMethod: paymentMethod,
                                                         context: context,
                                                         configuration: preApplePayConfig,
                                                         applePayConfiguration: configuration) {
                return component
            }
        }

        do {
            return try PreApplePayComponent(paymentMethod: paymentMethod,
                                            context: context,
                                            configuration: preApplePayConfig,
                                            applePayConfiguration: applePay)
        } catch {
            adyenPrint("Failed to instantiate ApplePayComponent because of error: \(error.localizedDescription)")
            return nil
        }
    }

    private func createSEPAComponent(_ paymentMethod: SEPADirectDebitPaymentMethod) -> SEPADirectDebitComponent {
        let config = SEPADirectDebitComponent.Configuration(style: configuration.style.formComponent,
                                                            payment: paymen,
                                                            localizationParameters: configuration.localizationParameters)
        return SEPADirectDebitComponent(paymentMethod: paymentMethod,
                                        context: context,
                                        configuration: config)
    }

    private func createBACSDirectDebit(_ paymentMethod: BACSDirectDebitPaymentMethod) -> BACSDirectDebitComponent {
        let bacsConfiguration = BACSDirectDebitComponent.Configuration(style: configuration.style.formComponent,
                                                                       payment: paymen,
                                                                       localizationParameters: configuration.localizationParameters)
        let bacsDirectDebitComponent = BACSDirectDebitComponent(paymentMethod: paymentMethod,
                                                                context: context,
                                                                configuration: bacsConfiguration)
        bacsDirectDebitComponent.presentationDelegate = presentationDelegate
        return bacsDirectDebitComponent
    }

    private func createACHDirectDebitComponent(_ paymentMethod: ACHDirectDebitPaymentMethod) -> ACHDirectDebitComponent {
        let config = ACHDirectDebitComponent.Configuration(style: configuration.style.formComponent,
                                                           payment: paymen,
                                                           shopperInformation: configuration.shopperInformation,
                                                           localizationParameters: configuration.localizationParameters)
        return ACHDirectDebitComponent(paymentMethod: paymentMethod,
                                       context: context,
                                       configuration: config)
    }

    private func createQiwiWalletComponent(_ paymentMethod: QiwiWalletPaymentMethod) -> QiwiWalletComponent {
        let config = QiwiWalletComponent.Configuration(style: configuration.style.formComponent,
                                                       payment: paymen,
                                                       shopperInformation: configuration.shopperInformation,
                                                       localizationParameters: configuration.localizationParameters)
        return QiwiWalletComponent(paymentMethod: paymentMethod,
                                   context: context,
                                   configuration: config)
    }

    private func createMBWayComponent(_ paymentMethod: MBWayPaymentMethod) -> MBWayComponent? {
        let config = MBWayComponent.Configuration(style: configuration.style.formComponent,
                                                  payment: paymen,
                                                  shopperInformation: configuration.shopperInformation,
                                                  localizationParameters: configuration.localizationParameters)
        return MBWayComponent(paymentMethod: paymentMethod,
                              context: context,
                              configuration: config)
    }

    private func createBLIKComponent(_ paymentMethod: BLIKPaymentMethod) -> BLIKComponent? {
        let config = BLIKComponent.Configuration(style: configuration.style.formComponent,
                                                 payment: paymen,
                                                 localizationParameters: configuration.localizationParameters)
        return BLIKComponent(paymentMethod: paymentMethod,
                             context: context,
                             configuration: config)
    }

    private func createBoletoComponent(_ paymentMethod: BoletoPaymentMethod) -> BoletoComponent {
        let config = BoletoComponent.Configuration(style: configuration.style.formComponent,
                                                   payment: paymen,
                                                   localizationParameters: configuration.localizationParameters,
                                                   shopperInformation: configuration.shopperInformation,
                                                   showEmailAddress: true)
        return BoletoComponent(paymentMethod: paymentMethod,
                               context: context,
                               configuration: config)
    }

}
