//
//  IAPModule.swift
//  IAPSampleProduct
//
//  Created by Satou Koutarou on 2017/06/15.
//  Copyright © 2017年 Satou Koutarou. All rights reserved.
//

import Foundation
import StoreKit

class IAPModuleSample: NSObject {
    static let sharedInstance = IAPModuleSample()
    
    var request: SKProductsRequest!
    dynamic var products: [SKProduct]!
    
    // 課金商品の一覧をサーバから取得
    func fetchProducts() {
        
    }
    
    // Product情報をApp Storeから取得
    func validateProductIdentifiers(productIdentifiers:[String]) {
        self.request = SKProductsRequest(productIdentifiers: Set<String>(productIdentifiers))
        request.delegate = self
        request.start()
    }
    
    // 支払い要求をApp Storeに送信
    func buyProduct(product: SKProduct) {
        let payment = SKMutablePayment(product: product)
//        payment.applicationUsername = UserManager.sharedInstance.currentUser.token.sha256String()
        SKPaymentQueue.default().add(payment)
    }

}

extension IAPModuleSample: SKProductsRequestDelegate {
    // Productリスト取得
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        self.products = response.products
        for id in response.invalidProductIdentifiers {
            // Handle any invalid product identifiers.
            print(id)
        }
    }
}

class IAPHelper: NSObject {
    // ユーザーが課金可能かどうか
    class func canMakePayments() -> Bool {
        return SKPaymentQueue.canMakePayments()
    }
    
    // 適切にフォーマットされた価格の返却
    class func formattedPrice(product: SKProduct) -> String? {
        let formatter = NumberFormatter()
        formatter.formatterBehavior = .behavior10_4
        formatter.numberStyle = .currency
        formatter.locale = product.priceLocale
        return formatter.string(from: product.price)
    }
}
