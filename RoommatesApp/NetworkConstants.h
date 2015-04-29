//
//  NetworkConstants.h
//  RoommatesApp
//
//  Created by Derick Olson on 4/26/15.
//  Copyright (c) 2015 DerickSam. All rights reserved.
//

#import "SessionManager.h"
#import "SocketManager.h"

#ifndef RoommatesApp_NetworkConstants_h
#define RoommatesApp_NetworkConstants_h

// For Local Testing switch base urls
//#define kBASE_URL @"http://localhost:8080"
#define kBASE_URL @"http://ec2-54-69-179-20.us-west-2.compute.amazonaws.com"

// Auth Request: add statements to end
#define kVENMO_AUTH_URL @"https://api.venmo.com/v1/oauth/authorize?client_id=2583&scope=make_payments%20access_profile%20access_balance&response_type=code&state="


#endif
