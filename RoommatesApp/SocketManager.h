//
//  SocketManager.h
//  RoommatesApp
//
//  Created by Sam Lobel on 4/29/15.
//  Copyright (c) 2015 DerickSam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Socket_IO_Client_Swift/Socket_IO_Client_Swift-Swift.h>

@interface SocketManager : NSObject

@property SocketIOClient* io;

+ (instancetype)sharedManager;

@end
