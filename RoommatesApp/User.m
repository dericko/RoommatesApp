//
//  User.m
//  RoommatesApp
//
//  Created by Derick Olson on 4/25/15.
//  Copyright (c) 2015 DerickSam. All rights reserved.
//

#import "User.h"

@interface User()

@property (strong, nonatomic) NSString *hashedPassword;

@end

@implementation User

+(User *)currentUser {
    static User *currentUser;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        currentUser = [[User alloc] init];
    });
    
    return currentUser;
}

- (User *)loginForUser:(NSDictionary *)userObject {
    self.username = [userObject valueForKey:@"username"];
    self.userId = [userObject valueForKey:@"_id"];
    self.hashedPassword = [userObject valueForKey:@"password"];
    return self;
}

- (void)logout {
    self.username = nil;
    self.userId = nil;
    self.hashedPassword = nil;
}

- (BOOL)isLoggedIn {
    return !(self.username == nil);
}

@end


