//
//  SessionManager.m
//  RoommatesApp
//
//  Created by Derick Olson on 4/25/15.
//  Copyright (c) 2015 DerickSam. All rights reserved.
//

#import "SessionManager.h"
#import "NetworkConstants.h"

@implementation SessionManager

+ (instancetype)sharedManager {
    static SessionManager *_sharedManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // Make shared instance
        _sharedManager = [[SessionManager alloc] initWithBaseURL:[NSURL URLWithString:kBASE_URL]];
        
        // Requests and responses in JSON
        [_sharedManager setRequestSerializer:[AFJSONRequestSerializer serializer]];
        [_sharedManager setResponseSerializer:[AFJSONResponseSerializer serializer]];
        
        // Add security stuff here
    });
    
    return _sharedManager;
}



@end
