//
//  ChatViewController.m
//  RoommatesApp
//
//  Created by Derick Olson on 4/25/15.
//  Copyright (c) 2015 DerickSam. All rights reserved.
//

#import "ChatViewController.h"
#import <Socket_IO_Client_Swift/Socket_IO_Client_Swift-Swift.h>
#import "NetworkConstants.h"

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
    
    UITapGestureRecognizer* tapBackground = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [tapBackground setNumberOfTapsRequired:1];
    [self.view addGestureRecognizer:tapBackground];
    [self.chatView addGestureRecognizer:tapBackground];
}


- (void)setupSocket {
    _socket = [[SocketIOClient alloc] initWithSocketURL:kBASE_URL options:nil];
    
    // Socket connected
    [_socket on:@"connect" callback: ^(NSArray* data, void (^ack)(NSArray*)) {
        NSLog(@"socket connected");
        
        
        // Listen to socket
        [_socket on:@"send-message" callback:^(NSArray *data, void (^ack)(NSArray*)){
            NSLog(@"GOT SOCKET RESPONSE");
            [self didRecieveData:data];
        }];
    }];
    
    
    [_socket connect];
    
}

#pragma mark - UITextField Delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self sendMessage];
    return YES;
}

- (void)dismissKeyboard {
    [_textField resignFirstResponder];
}

#pragma mark - IBAction method implementation


- (IBAction)sendPressed:(id)sender {
    
    [self sendMessage];
    
}

- (void)sendMessage {
    
    // Display to self
    NSLog(@"SEND MESSAGE CALLED");
    NSString *message = _textField.text;
    [_chatView setText:[_chatView.text stringByAppendingString:[NSString stringWithFormat:@"I wrote: %@\n", message]]];
    
    // Send to server
    
    
    // Send to socket
    [_socket emitObjc:@"send-message" withItems:@[message]];
    
    [_textField setText:@""];
//    [_textField resignFirstResponder];
    
    
}

- (void)didRecieveData:(NSArray *)data {
    NSString *message = [NSString stringWithFormat:@"%@", [[data firstObject] firstObject]];
    
    NSLog(@"Message: %@", message);
    
    [_chatView setText:[_chatView.text stringByAppendingString:[NSString stringWithFormat:@"received: %@\n", message]]];
}


@end
