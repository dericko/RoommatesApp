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
#import "User.h"

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
    
    if ([_textField.text isEqualToString:@""]) {
        return;
    }
    
    // Display to self
    NSLog(@"SEND MESSAGE CALLED");
    NSString *message = _textField.text;
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    [data setValue:[[User currentUser] userId] forKey:@"_id"];
    [data setValue:[[User currentUser] username] forKey:@"username"];
    [data setValue:_textField.text forKey:@"message"];
    [_chatView setText:[_chatView.text stringByAppendingString:[NSString stringWithFormat:@"I wrote: %@\n", message]]];
    
    // Send to server
    NSLog(@"SEND TO SOCKET %@", @[[data copy]]);
    
    // Send to socket
    [_socket emitObjc:@"send-message" withItems:@[[data copy]]];
    
    [_textField setText:@""];
//    [_textField resignFirstResponder];
}

- (void)didRecieveData:(NSArray *)data {
    NSDictionary *dataDict = [[data firstObject] firstObject];
    NSLog(@"Returned: %@", dataDict);
    
    NSString *userId = [NSString stringWithFormat:@"%@", [dataDict objectForKey:@"_id"]];
    NSString *username = [NSString stringWithFormat:@"%@", [dataDict objectForKey:@"username"]];
    NSString *message = [NSString stringWithFormat:@"%@", [dataDict objectForKey:@"message"]];
    
    NSLog(@"Message: %@", message);
    
    if (![userId isEqualToString:[[User currentUser] userId]]) {
        [_chatView setText:[_chatView.text stringByAppendingString:[NSString stringWithFormat:@"%@: %@\n", username, message]]];
    }
}


@end
