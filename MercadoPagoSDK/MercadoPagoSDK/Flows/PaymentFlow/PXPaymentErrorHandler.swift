//
//  PXPaymentErrorHandler.swift
//  MercadoPagoSDK
//
//  Created by Eden Torres on 26/06/2018.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import Foundation
protocol PXPaymentErrorHandler: NSObjectProtocol {
    func escError()
    func identificationError()
    func exitCheckout()
}
