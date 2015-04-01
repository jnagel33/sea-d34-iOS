//
//  AccountService.swift
//  TweetFellows
//
//  Created by Josh Nagel on 3/31/15.
//  Copyright (c) 2015 jnagel. All rights reserved.
//

import Foundation
import Accounts

class LoginService {
  
  class func requestTwitterAccount(completionHandler: (ACAccount?, String?) -> Void) {
    let accountStore = ACAccountStore()
    let accountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
    accountStore.requestAccessToAccountsWithType(accountType, options: nil) { (granted, error) -> Void in
      var twitterAccount: ACAccount? = nil
      var errorDescription: String? = nil
      if granted && error == nil {
        if let accounts = accountStore.accountsWithAccountType(accountType) as? [ACAccount] {
          twitterAccount = accounts.first
        }
      } else {
        if error != nil {
          errorDescription = "An error occured when retrieving your Twitter Account"
        } else {
          errorDescription = "Access to your account could not be granted"
        }
      }
      completionHandler(twitterAccount, errorDescription)
    }
  }
  
}
