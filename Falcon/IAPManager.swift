//
//  IAPManager.swift
//  Falcon
//
//  Created by Tayson on 2015-11-09.
//  Copyright © 2015 Tayson Nguyen. All rights reserved.
//

import Foundation
import StoreKit

public class IAPManager: NSObject {
    
    public typealias RestorePurchasesCompletionBlock = (Error?) -> ()
    public typealias BuyProductCompletionBlock = (Error?) -> ()
    public typealias RequestProductsCompletionBlock = ([SKProduct]?, Error?) -> ()
    
    fileprivate var restorePurchasesCompletionBlock: RestorePurchasesCompletionBlock?
    fileprivate var buyProductCompletionBlock: BuyProductCompletionBlock?
    fileprivate var requestProductsCompletionBlock: RequestProductsCompletionBlock?
    
    fileprivate var loadedProducts = [SKProduct]()
    
    public static let sharedManager = IAPManager()
    
    override init() {
        super.init()
        SKPaymentQueue.default().add(self)
    }
    
    deinit {
        SKPaymentQueue.default().remove(self)
    }

    public func isProductPurchased(_ productID: String) -> Bool {
        return UserDefaults.standard.bool(forKey: productID)
    }
    
    public func restorePurchases(_ completion: @escaping RestorePurchasesCompletionBlock) {
        restorePurchasesCompletionBlock = completion
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    public func requestProducts(_ productIDs: [String], completion: @escaping RequestProductsCompletionBlock) {
        requestProductsCompletionBlock = completion
        let request = SKProductsRequest(productIdentifiers: Set(productIDs))
        request.delegate = self
        request.start()
    }
    
    public func buyProduct(_ productID: String, completion: @escaping BuyProductCompletionBlock) {
        guard SKPaymentQueue.canMakePayments() else {
            let error = NSError(domain: "IAPManager", code: 0, userInfo: [NSLocalizedDescriptionKey: "In-app purchases are disabled"])
            completion(error)
            return
        }
        
        guard let product = productWithProductID(productID) else {
            requestProducts([productID]) { [unowned self] (products, error) -> () in
                guard let products = products else {
                    completion(error)
                    return
                }
        
                self.loadedProducts = products
                self.buyProduct(productID, completion: completion)
            }
            
            return
        }
        
        buyProductCompletionBlock = completion
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    fileprivate func productWithProductID(_ productID: String) -> SKProduct? {
        return loadedProducts.filter { $0.productIdentifier == productID }.first
    }
}

extension IAPManager: SKProductsRequestDelegate {
    public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        loadedProducts = response.products
        
        if let completion = requestProductsCompletionBlock {
            completion(loadedProducts, nil)
        }
    }
    
    public func request(_ request: SKRequest, didFailWithError error: Error) {
        if let completion = requestProductsCompletionBlock {
            completion(nil, error)
        }
    }
}

extension IAPManager: SKPaymentTransactionObserver {
    public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                provideContentForProductIdentifier(transaction.payment.productIdentifier)
                
            case .restored:
                provideContentForProductIdentifier(transaction.original!.payment.productIdentifier)
                
            case .failed:
                //transaction.error?.code == SKErrorPaymentCancelled
                if let completion = buyProductCompletionBlock {
                    completion(transaction.error)
                }

            default:
                break
            }
            
            if transaction.transactionState != .purchasing {
                SKPaymentQueue.default().finishTransaction(transaction)
            }
        }
    }
    
    fileprivate func provideContentForProductIdentifier(_ identifier: String) {
        UserDefaults.standard.set(true, forKey: identifier)
        UserDefaults.standard.synchronize()
        
        if let completion = buyProductCompletionBlock {
            completion(nil)
        }
    }

    public func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        if let completion = restorePurchasesCompletionBlock {
            completion(nil)
        }
    }
    
    public func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        if let completion = restorePurchasesCompletionBlock {
            completion(error)
        }
    }
}
