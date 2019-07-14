//
//  ViewControllerIAPExtension.swift
//  WeirdFace
//
//  Created by Patrick Doyle on 7/14/19.
//  Copyright © 2019 Patrick Doyle. All rights reserved.
//

import Foundation
import StoreKit

extension ViewController: SKProductsRequestDelegate, SKPaymentTransactionObserver{
    
    func buyProduct(product: SKProduct) {
        print("Sending the Payment Request to Apple");
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment);
    }
    
    func buyInAppPurchases(){
        
        if (SKPaymentQueue.canMakePayments()) {
            let productID:NSSet = NSSet(array: [mainUIViewModel?.model.inAppPurchasePremiumAccountID as! NSString]);
            let productsRequest:SKProductsRequest = SKProductsRequest(productIdentifiers: productID as! Set<String>);
            productsRequest.delegate = self;
            productsRequest.start();
            print("Fetching Products");
        } else {
            print("can't make purchases");
            showAlertWith(title: "Error", message: "We're Sorry.  We were unable to process your request.  Please ensure you have internet access and are signed in to your account.")
            removeWatermarkButton.isEnabled = true
            drawnImageViewFullScreenButton.isEnabled = true
            colorPickerButton.isEnabled = true
            purchasePremiumButton.isEnabled = true
            restorePremiumButton.isEnabled = true
        }
        
    }
    
    func restoreInAppPurchases(){
        
        
        if (SKPaymentQueue.canMakePayments()) {
            SKPaymentQueue.default().add(self)
            SKPaymentQueue.default().restoreCompletedTransactions()
        } else {
            restorePremiumButton.isEnabled = true
            showAlertWith(title: "Error", message: "We're Sorry.  We were unable to process your request.  Please ensure you have internet access and are signed in to your account.")
        }
        
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print(response.products)
        let count : Int = response.products.count
        if (count>0) {
            
            let validProduct: SKProduct = response.products[0] as SKProduct
            if (validProduct.productIdentifier == mainUIViewModel?.model.inAppPurchasePremiumAccountID as? String) {
                print(validProduct.localizedTitle)
                print(validProduct.localizedDescription)
                print(validProduct.price)
                //Display price and details to user and verify if they want to complete the purchase, if so, buy the product
                //Restore buttons so they can be re-clicked
                removeWatermarkButton.isEnabled = true
                drawnImageViewFullScreenButton.isEnabled = true
                colorPickerButton.isEnabled = true
                purchasePremiumButton.isEnabled = true
                restorePremiumButton.isEnabled = true
                verifyIfUserWantsToCompletePurchase(title: "Premium Account Required", message: "Purchase Premium Account to Get Access to Extra Features (Enhanced Drawing Tools and No Watermarks) for " + validProduct.localizedPrice + "?", callback: {
                    purchaseConfirmed in
                    if purchaseConfirmed{
                        self.buyProduct(product: validProduct)
                    }
                })
            } else {
                print(validProduct.productIdentifier)
            }
        } else {
            print("nothing")
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction:AnyObject in transactions {
            if let trans:SKPaymentTransaction = transaction as? SKPaymentTransaction{
                
                switch trans.transactionState {
                case .purchased:
                    print("Product Purchased")
                    mainUIViewModel?.activatePremiumAccess()
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    break;
                case .failed:
                    print("Purchased Failed");
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    break;
                case .restored:
                    print("Already Purchased")
                    showAlertWith(title: "Already Purchased", message: "Premium Mode Activated")
                    mainUIViewModel?.activatePremiumAccess()
                    restorePremiumButton.isEnabled = true
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                default:
                    break;
                }
            }
        }
    }
    
    //If an error occurs, the code will go to this function
    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        showAlertWith(title: "Error", message: "We're Sorry.  We were unable to process your request.  Please ensure you have internet access and are signed in to your account.")
        restorePremiumButton.isEnabled = true
    }
    
    
    
    
}
