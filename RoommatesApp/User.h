//
//  User.h
//  RoommatesApp
//
//  Created by Derick Olson on 4/25/15.
//  Copyright (c) 2015 DerickSam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *userId;

+ (User *)currentUser;
- (User *)loginForUser:(NSDictionary *)userObject;
- (NSString *)username;
- (NSString *)userId;

- (BOOL)isLoggedIn;
- (void)logout;

@end
