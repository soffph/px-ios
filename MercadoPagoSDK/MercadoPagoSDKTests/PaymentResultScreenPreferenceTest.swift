//
//  PaymentResultScreenPreferenceTest.swift
//  MercadoPagoSDK
//
//  Created by Eden Torres on 2/23/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import XCTest

class PaymentResultScreenPreferenceTest: BaseTest {

    let paymentResultScreenPreference = PaymentResultScreenPreference()
    var mpCheckout: MercadoPagoCheckout! = nil

    override func setUp() {
        super.setUp()
        self.createCheckout()
    }

    func createCheckout() {
        let checkoutPreference = MockBuilder.buildCheckoutPreference()
        let navControllerInstance = UINavigationController()
        self.mpCheckout = MercadoPagoCheckout(publicKey: "PK_MLA", accessToken: "", checkoutPreference: checkoutPreference, navigationController: navControllerInstance)
    }

    func testSetTitle() {
        XCTAssertEqual(self.mpCheckout.viewModel.paymentResultScreenPreference.getApprovedTitle(), PXStrings.success_payment_title.PXLocalized)
        XCTAssertEqual(self.mpCheckout.viewModel.paymentResultScreenPreference.getPendingTitle(), "Estamos procesando el pago".localized)
        XCTAssertEqual(self.mpCheckout.viewModel.paymentResultScreenPreference.getRejectedTitle(), "Uy, no pudimos procesar el pago".localized)

        paymentResultScreenPreference.setApproved(title: "1")
        paymentResultScreenPreference.setPending(title: "2")
        paymentResultScreenPreference.setRejected(title: "3")

        self.mpCheckout.setPaymentResultScreenPreference(paymentResultScreenPreference)

        XCTAssertEqual(self.mpCheckout.viewModel.paymentResultScreenPreference.getApprovedTitle(), "1")
        XCTAssertEqual(self.mpCheckout.viewModel.paymentResultScreenPreference.getPendingTitle(), "2")
        XCTAssertEqual(self.mpCheckout.viewModel.paymentResultScreenPreference.getRejectedTitle(), "3")
    }

    func testSetSubtitle() {
        XCTAssertEqual(self.mpCheckout.viewModel.paymentResultScreenPreference.getApprovedSubtitle(), "")
        XCTAssertEqual(self.mpCheckout.viewModel.paymentResultScreenPreference.getPendingSubtitle(), "")
        XCTAssertEqual(self.mpCheckout.viewModel.paymentResultScreenPreference.getRejectedSubtitle(), "")

        paymentResultScreenPreference.setApprovedSubtitle(subtitle: "1")
        paymentResultScreenPreference.setPendingSubtitle(subtitle: "2")
        paymentResultScreenPreference.setRejectedSubtitle(subtitle: "3")

        self.mpCheckout.setPaymentResultScreenPreference(paymentResultScreenPreference)

        XCTAssertEqual(self.mpCheckout.viewModel.paymentResultScreenPreference.getApprovedSubtitle(), "1")
        XCTAssertEqual(self.mpCheckout.viewModel.paymentResultScreenPreference.getPendingSubtitle(), "2")
        XCTAssertEqual(self.mpCheckout.viewModel.paymentResultScreenPreference.getRejectedSubtitle(), "3")
    }

    func testSetContentTitle() {
        XCTAssertEqual(self.mpCheckout.viewModel.paymentResultScreenPreference.getPendingContetTitle(), PXStrings.error_body_title_.PXLocalized)
        XCTAssertEqual(self.mpCheckout.viewModel.paymentResultScreenPreference.getRejectedContetTitle(), PXStrings.error_body_title_.PXLocalized)

        paymentResultScreenPreference.setPendingContentTitle(title: "1")
        paymentResultScreenPreference.setRejectedContentTitle(title: "2")

        self.mpCheckout.setPaymentResultScreenPreference(paymentResultScreenPreference)

        XCTAssertEqual(self.mpCheckout.viewModel.paymentResultScreenPreference.getPendingContetTitle(), "1")
        XCTAssertEqual(self.mpCheckout.viewModel.paymentResultScreenPreference.getRejectedContetTitle(), "2")
    }

    func testSetContentText() {
        XCTAssertEqual(self.mpCheckout.viewModel.paymentResultScreenPreference.getPendingContentText(), "")
        XCTAssertEqual(self.mpCheckout.viewModel.paymentResultScreenPreference.getRejectedContentText(), "")

        paymentResultScreenPreference.setPendingContentText(text: "1")
        paymentResultScreenPreference.setRejectedContentText(text: "2")

        self.mpCheckout.setPaymentResultScreenPreference(paymentResultScreenPreference)

        XCTAssertEqual(self.mpCheckout.viewModel.paymentResultScreenPreference.getPendingContentText(), "1")
        XCTAssertEqual(self.mpCheckout.viewModel.paymentResultScreenPreference.getRejectedContentText(), "2")
    }

    func testSetIconSubtext() {
        XCTAssertEqual(self.mpCheckout.viewModel.paymentResultScreenPreference.getRejectedIconSubtext(), "Algo salió mal...".localized)

        paymentResultScreenPreference.setRejectedIconSubtext(text: "lala")

        self.mpCheckout.setPaymentResultScreenPreference(paymentResultScreenPreference)

        XCTAssertEqual(self.mpCheckout.viewModel.paymentResultScreenPreference.getRejectedIconSubtext(), "lala")
    }

    func testSetSecondaryExitButton() {
        XCTAssertEqual(self.mpCheckout.viewModel.paymentResultScreenPreference.getApprovedSecondaryButtonText(), "")
        XCTAssert(self.mpCheckout.viewModel.paymentResultScreenPreference.getApprovedSecondaryButtonCallback() == nil)

        XCTAssertNil(self.mpCheckout.viewModel.paymentResultScreenPreference.getPendingSecondaryButtonText())

        XCTAssert(self.mpCheckout.viewModel.paymentResultScreenPreference.getPendingSecondaryButtonCallback() == nil)
        XCTAssertNil(self.mpCheckout.viewModel.paymentResultScreenPreference.getRejectedSecondaryButtonText())

        XCTAssert(self.mpCheckout.viewModel.paymentResultScreenPreference.getRejectedSecondaryButtonCallback() == nil)

        paymentResultScreenPreference.setApprovedSecondaryExitButton(callback: { (_) in

        }, text: "1")

        paymentResultScreenPreference.setPendingSecondaryExitButton(callback: { (_) in

        }, text: "2")

        paymentResultScreenPreference.setRejectedSecondaryExitButton(callback: { (_) in

        }, text: "3")

        self.mpCheckout.setPaymentResultScreenPreference(paymentResultScreenPreference)

        XCTAssertEqual(self.mpCheckout.viewModel.paymentResultScreenPreference.getApprovedSecondaryButtonText(), "1")
        XCTAssert(self.mpCheckout.viewModel.paymentResultScreenPreference.getApprovedSecondaryButtonCallback() != nil)

        XCTAssertEqual(self.mpCheckout.viewModel.paymentResultScreenPreference.getPendingSecondaryButtonText(), "2")
        XCTAssert(self.mpCheckout.viewModel.paymentResultScreenPreference.getPendingSecondaryButtonCallback() != nil)

        XCTAssertEqual(self.mpCheckout.viewModel.paymentResultScreenPreference.getRejectedSecondaryButtonText(), "3")
        XCTAssert(self.mpCheckout.viewModel.paymentResultScreenPreference.getRejectedSecondaryButtonCallback() != nil)
    }

    func testSetHeaderIcon() {
        XCTAssertEqual(self.mpCheckout.viewModel.paymentResultScreenPreference.pendingIconName, "default_item_icon")
        XCTAssertEqual(self.mpCheckout.viewModel.paymentResultScreenPreference.pendingIconBundle, MercadoPago.getBundle())

        XCTAssertEqual(self.mpCheckout.viewModel.paymentResultScreenPreference.rejectedIconName, nil)
        XCTAssertEqual(self.mpCheckout.viewModel.paymentResultScreenPreference.rejectedIconBundle, MercadoPago.getBundle())

        paymentResultScreenPreference.setPendingHeaderIcon(name: "lala", bundle: Bundle.main)
        paymentResultScreenPreference.setRejectedHeaderIcon(name: "lalala", bundle: Bundle.main)

        self.mpCheckout.setPaymentResultScreenPreference(paymentResultScreenPreference)

        XCTAssertEqual(self.mpCheckout.viewModel.paymentResultScreenPreference.pendingIconName, "lala")
        XCTAssertEqual(self.mpCheckout.viewModel.paymentResultScreenPreference.pendingIconBundle, Bundle.main)

        XCTAssertEqual(self.mpCheckout.viewModel.paymentResultScreenPreference.rejectedIconName, "lalala")
        XCTAssertEqual(self.mpCheckout.viewModel.paymentResultScreenPreference.rejectedIconBundle, Bundle.main)

    }

    func testDisableSecondaryButton() {
        XCTAssertFalse(self.mpCheckout.viewModel.paymentResultScreenPreference.isPendingSecondaryExitButtonDisable())
        XCTAssertFalse(self.mpCheckout.viewModel.paymentResultScreenPreference.isRejectedSecondaryExitButtonDisable())

        paymentResultScreenPreference.disablePendingSecondaryExitButton()
        self.mpCheckout.setPaymentResultScreenPreference(paymentResultScreenPreference)

        XCTAssert(self.mpCheckout.viewModel.paymentResultScreenPreference.isPendingSecondaryExitButtonDisable())

        paymentResultScreenPreference.disableRejectdSecondaryExitButton()
        self.mpCheckout.setPaymentResultScreenPreference(paymentResultScreenPreference)

        XCTAssert(self.mpCheckout.viewModel.paymentResultScreenPreference.isRejectedSecondaryExitButtonDisable())
    }

    func testDisableContentText() {
        XCTAssertFalse(self.mpCheckout.viewModel.paymentResultScreenPreference.isPendingContentTextDisable())
        XCTAssertFalse(self.mpCheckout.viewModel.paymentResultScreenPreference.isRejectedContentTextDisable())

        paymentResultScreenPreference.disablePendingContentText()
        self.mpCheckout.setPaymentResultScreenPreference(paymentResultScreenPreference)

        XCTAssert(self.mpCheckout.viewModel.paymentResultScreenPreference.isPendingContentTextDisable())

        paymentResultScreenPreference.disableRejectedContentText()
        self.mpCheckout.setPaymentResultScreenPreference(paymentResultScreenPreference)

        XCTAssert(self.mpCheckout.viewModel.paymentResultScreenPreference.isRejectedContentTextDisable())
    }

    func testDisableContentTitle() {
        XCTAssertFalse(self.mpCheckout.viewModel.paymentResultScreenPreference.isRejectedContentTitleDisable())
        XCTAssertFalse(self.mpCheckout.viewModel.paymentResultScreenPreference.isPendingContentTitleDisable())

        paymentResultScreenPreference.disableRejectedContentTitle()
        self.mpCheckout.setPaymentResultScreenPreference(paymentResultScreenPreference)

        XCTAssert(self.mpCheckout.viewModel.paymentResultScreenPreference.isRejectedContentTitleDisable())

        paymentResultScreenPreference.disablePendingContentTitle()
        self.mpCheckout.setPaymentResultScreenPreference(paymentResultScreenPreference)

        XCTAssert(self.mpCheckout.viewModel.paymentResultScreenPreference.isPendingContentTitleDisable())
    }

    func testSetExitTitle() {
        XCTAssertNil(self.mpCheckout.viewModel.paymentResultScreenPreference.getExitButtonTitle())

        paymentResultScreenPreference.setExitButtonTitle(title: "lala")
        self.mpCheckout.setPaymentResultScreenPreference(paymentResultScreenPreference)

        XCTAssertEqual(self.mpCheckout.viewModel.paymentResultScreenPreference.getExitButtonTitle(), "lala")

    }

    func testApprovedBodyDisables() {
        XCTAssertFalse(self.mpCheckout.viewModel.paymentResultScreenPreference.isAmountDisable())
        XCTAssertFalse(self.mpCheckout.viewModel.paymentResultScreenPreference.isPaymentMethodDisable())
        XCTAssertFalse(self.mpCheckout.viewModel.paymentResultScreenPreference.isPaymentIdDisable())

        paymentResultScreenPreference.disableApprovedAmount()
        self.mpCheckout.setPaymentResultScreenPreference(paymentResultScreenPreference)

        XCTAssert(self.mpCheckout.viewModel.paymentResultScreenPreference.isAmountDisable())

        paymentResultScreenPreference.disableApprovedPaymentMethodInfo()
        self.mpCheckout.setPaymentResultScreenPreference(paymentResultScreenPreference)

        XCTAssert(self.mpCheckout.viewModel.paymentResultScreenPreference.isPaymentMethodDisable())

        paymentResultScreenPreference.disableApprovedReceipt()
        self.mpCheckout.setPaymentResultScreenPreference(paymentResultScreenPreference)

        XCTAssert(self.mpCheckout.viewModel.paymentResultScreenPreference.isPaymentIdDisable())
    }

    func testDisableChangePaymentMethodCell() {
        XCTAssertFalse(self.mpCheckout.viewModel.paymentResultScreenPreference.isContentCellDisable())

        paymentResultScreenPreference.disableContentCell()
        self.mpCheckout.setPaymentResultScreenPreference(paymentResultScreenPreference)

        XCTAssert(self.mpCheckout.viewModel.paymentResultScreenPreference.isContentCellDisable())
    }
}
