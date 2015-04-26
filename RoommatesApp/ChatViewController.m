//
//  ChatViewController.m
//  RoommatesApp
//
//  Created by Derick Olson on 4/25/15.
//  Copyright (c) 2015 DerickSam. All rights reserved.
//

#import "ChatViewController.h"
#import <Socket_IO_Client_Swift/Socket_IO_Client_Swift-Swift.h>

@interface ChatViewController ()

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITextView *chatView;

@property (strong, nonatomic) SocketIOClient*socket;
@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _textField.delegate = self;
    
    [self setupSocket];
}


- (void)setupSocket {
    _socket = [[SocketIOClient alloc] initWithSocketURL:@"localhost:8080" options:nil];
    
    // Socket connected
    [_socket on: @"connect" callback: ^(NSArray* data, void (^ack)(NSArray*)) {
        NSLog(@"socket connected");
        
        
        // Listen to server
        [_socket on:@"send-message" callback:^(NSArray *data, void (^ack)(NSArray*)){
            NSLog(@"got message");
        }];
    }];
    
    
    [_socket connect];
    
    [_socket onAny:^{
        NSLog(@"Got event from socket");
    }];
    // Do any additional setup after loading the view.
}

#pragma mark - UITextField Delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self sendMessage];
    return YES;
}


#pragma mark - IBAction method implementation


- (IBAction)sendPressed:(id)sender {
    
    
    [self sendMessage];
    
}

- (void)sendMessage {
    NSLog(@"Send message");
    // Send to server
    [_socket emitObjc:@"send-message" withItems:@[@"message test"]];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
