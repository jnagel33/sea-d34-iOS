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
      if granted && error == nil {
        if let accounts = accountStore.accountsWithAccountType(accountType) as? [ACAccount] {
          let twitterAccount = accounts.first
          completionHandler(twitterAccount, nil)
        }
      } else {
        completionHandler(nil, "Could not access your Twitter Account")
      }
    }
  }
}
