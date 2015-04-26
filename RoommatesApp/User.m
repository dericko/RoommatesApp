//
//  User.m
//  RoommatesApp
//
//  Created by Derick Olson on 4/25/15.
//  Copyright (c) 2015 DerickSam. All rights reserved.
//

#import "User.h"

@interface User()

@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *salt;
@property (strong, nonatomic) NSString *hashCode;
@property (strong, nonatomic) NSArray *groups;

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
    self.salt = [userObject valueForKey:@"salt"];
    self.hashCode = [userObject valueForKey:@"hash"];
    self.groups = [userObject valueForKey:@"groups"];
    return self;
}

- (NSString *)getUsername {
    return self.username;
}

- (NSString *)getHash {
    return self.hashCode;
}

- (NSString *)getSalt {
    return self.salt;
}

- (NSArray *)getGroups {
    return self.groups;
}

- (void)logout {
    self.username = nil;
    self.salt = nil;
    self.hashCode = nil;
    self.groups = nil;
}

- (BOOL)isLoggedIn {
    return !(self.username == nil);
}

@end


