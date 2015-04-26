//
//  User.h
//  RoommatesApp
//
//  Created by Derick Olson on 4/25/15.
//  Copyright (c) 2015 DerickSam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

+ (User *)currentUser;
- (User *)loginForUser:(NSDictionary *)userObject;
- (NSString *)getUsername;
- (NSString *)getHash;
- (NSString *)getSalt;
- (NSArray *)getGroups;

- (BOOL)isLoggedIn;
- (void)logout;

@end
