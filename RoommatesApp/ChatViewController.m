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
    
    // Get shared instance
    _socket = [SocketManager sharedManager].io;
    
    // Add handlers
    [_socket on:@"connect" callback: ^(NSArray* data, void (^ack)(NSArray*)) {
        [_socket on:@"send-message" callback:^(NSArray *data, void (^ack)(NSArray*)){
            NSLog(@"GOT MSG RESPONSE");
            [self didRecieveData:data];
        }];
    }];
    
    UITapGestureRecognizer* tapBackground = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [tapBackground setNumberOfTapsRequired:1];
    [self.view addGestureRecognizer:tapBackground];
    [self.chatView addGestureRecognizer:tapBackground];
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
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    [data setValue:[[User currentUser] userId] forKey:@"_id"];
    [data setValue:[[User currentUser] username] forKey:@"username"];
    [data setValue:_textField.text forKey:@"message"];
    [_chatView setText:[_chatView.text stringByAppendingString:[NSString stringWithFormat:@"I wrote: %@\n", message]]];
        
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
