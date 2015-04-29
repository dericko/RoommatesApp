//
//  SocketManager.m
//  RoommatesApp
//
//  Created by Sam Lobel on 4/29/15.
//  Copyright (c) 2015 DerickSam. All rights reserved.
//

#import "SocketManager.h"
#import "NetworkConstants.h"

@implementation SocketManager

+ (instancetype)sharedManager {
    static SocketManager *_sharedManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // Make shared instance
        _sharedManager = [[SocketManager alloc] init];
        
        // Requests and responses in JSON
        _sharedManager.io = [[SocketIOClient alloc] initWithSocketURL:kBASE_URL options:nil];
        
        // Socket connected
        [_sharedManager.io on:@"connect" callback: ^(NSArray* data, void (^ack)(NSArray*)) {
            NSLog(@"socket connected");
                        
            // Add global handlers
            
        }];
        
});
    
    return _sharedManager;
}

@end
