//
//  OneTapFlow+Services.swift
//  MercadoPagoSDK
//
//  Created by Eden Torres on 09/05/2018.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import Foundation
extension OneTapFlow {
    func createCardToken(cardInformation: CardInformation? = nil, securityCode: String? = nil) {
        guard let cardInfo = model.paymentOptionSelected as? CardInformation else {
            return
        }
        if self.model.mpESCManager.hasESCEnable() {
            var savedESCCardToken: SavedESCCardToken

            let esc = self.model.mpESCManager.getESC(cardId: cardInfo.getCardId())

            if !String.isNullOrEmpty(esc) {
                savedESCCardToken = SavedESCCardToken(cardId: cardInfo.getCardId(), esc: esc)
            } else {
                savedESCCardToken = SavedESCCardToken(cardId: cardInfo.getCardId(), securityCode: securityCode)
            }
            createSavedESCCardToken(savedESCCardToken: savedESCCardToken)

        } else {
            //TODO: REMOVE MOCK
            createSavedCardToken(cardInformation: cardInfo, securityCode: "123")
        }
    }

    func createSavedCardToken(cardInformation: CardInformation, securityCode: String) {
        if model.needToShowLoading() {
            self.pxNavigationHandler.presentLoading()
        }

        let cardInformation = model.paymentOptionSelected as! CardInformation
        let saveCardToken = SavedCardToken(card: cardInformation, securityCode: securityCode, securityCodeRequired: true)

        self.model.mercadoPagoServicesAdapter.createToken(savedCardToken: saveCardToken, callback: { [weak self] (token) in

            if token.lastFourDigits.isEmpty {
                token.lastFourDigits = cardInformation.getCardLastForDigits()
            }
            self?.model.updateCheckoutModel(token: token)
            self?.executeNextStep()

            }, failure: { [weak self] (error) in
                let error = MPSDKError.convertFrom(error, requestOrigin: ApiUtil.RequestOrigin.CREATE_TOKEN.rawValue)
                self?.pxNavigationHandler.showErrorScreen(error: error, callbackCancel: self?.resultHandler?.exitCheckout, errorCallback: { [weak self] () in
                    self?.createSavedCardToken(cardInformation: cardInformation, securityCode: securityCode)
                })
        })
    }

    func createSavedESCCardToken(savedESCCardToken: SavedESCCardToken) {
        if model.needToShowLoading() {
            self.pxNavigationHandler.presentLoading()
        }

        self.model.mercadoPagoServicesAdapter.createToken(savedESCCardToken: savedESCCardToken, callback: { [weak self] (token) in

            if token.lastFourDigits.isEmpty {
                let cardInformation = self?.model.paymentOptionSelected as? CardInformation
                token.lastFourDigits = cardInformation?.getCardLastForDigits() ?? ""
            }
            self?.model.updateCheckoutModel(token: token)
            self?.executeNextStep()

            }, failure: { [weak self] (error) in

                let error = MPSDKError.convertFrom(error, requestOrigin: ApiUtil.RequestOrigin.CREATE_TOKEN.rawValue)

                if let apiException = error.apiException, apiException.containsCause(code: ApiUtil.ErrorCauseCodes.INVALID_ESC.rawValue) ||  apiException.containsCause(code: ApiUtil.ErrorCauseCodes.INVALID_FINGERPRINT.rawValue) {

                    self?.model.mpESCManager.deleteESC(cardId: savedESCCardToken.cardId)
                    self?.executeNextStep()
                } else {
                    self?.pxNavigationHandler.showErrorScreen(error: error, callbackCancel: self?.resultHandler?.exitCheckout, errorCallback: { [weak self] () in
                        self?.createSavedESCCardToken(savedESCCardToken: savedESCCardToken)
                    })

                }
        })
    }
}