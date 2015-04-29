//
//  TableChatViewController.m
//  RoommatesApp
//
//  Created by Derick Olson on 4/29/15.
//  Copyright (c) 2015 DerickSam. All rights reserved.
//

#import "TableChatViewController.h"
#import "User.h"
//#import "SessionManager.h"
//#import <Socket_IO_Client_Swift/Socket_IO_Client_Swift-Swift.h>
#import "NetworkConstants.h"




@interface TableChatViewController ()

@property(strong,nonatomic)NSMutableArray *chatMessageArray;
@property(strong,nonatomic) User *user;
@property(strong,nonatomic) SessionManager *sharedManager;
@property(strong,nonatomic) IBOutlet UITableView *messageTable;

@property (strong, nonatomic) SocketIOClient*socket;

@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (weak, nonatomic) IBOutlet UIButton *sendButton;


@end

@implementation TableChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"chat view did load");
    _chatMessageArray = [NSMutableArray arrayWithArray: @[]];
    _messageTable.delegate = self;
    _messageTable.dataSource = self;
    _user = [User currentUser];
    _sharedManager = [SessionManager sharedManager];
    
    _socket = [SocketManager sharedManager].io;
    
    [_socket on:@"connect" callback: ^(NSArray* data, void (^ack)(NSArray*)) {
        [_socket on:@"send-message" callback:^(NSArray *data, void (^ack)(NSArray*)){
            NSLog(@"GOT MSG RESPONSE");
            [self didRecieveData:data];
        }];
    }];


    
    
    [_sharedManager GET:@"getMessages" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"Successful fetch of messages");
        NSArray *responseArray = (NSArray *) responseObject;
        _chatMessageArray = [NSMutableArray arrayWithArray:responseArray];
        NSLog(@"%lu", (unsigned long)[_chatMessageArray count]);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error: %@",error);
    }];
    
    // Do any additional setup after loading the view.
}

-(IBAction)sendMessage:(id)sender{
    if ([_textField.text isEqualToString:@""]) {
        return;
    }
    
    // Display to self
    NSLog(@"SEND MESSAGE CALLED");
    NSString *message = _textField.text;
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    [data setValue:[_user userId] forKey:@"_id"];
    [data setValue:[_user username] forKey:@"username"];
    [data setValue:_textField.text forKey:@"message"];
    [_chatMessageArray addObject:data];
    [_messageTable reloadData];
//    [_chatView setText:[_chatView.text stringByAppendingString:[NSString stringWithFormat:@"I wrote: %@\n", message]]];
    
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
//    NSString *username = [NSString stringWithFormat:@"%@", [dataDict objectForKey:@"username"]];
    NSString *message = [NSString stringWithFormat:@"%@", [dataDict objectForKey:@"message"]];
    
    NSLog(@"Message: %@", message);
    
    if (![userId isEqualToString:[_user userId]]) {
//        [_chatView setText:[_chatView.text stringByAppendingString:[NSString stringWithFormat:@"%@: %@\n", username, message]]];
        [_chatMessageArray addObject:dataDict];
        [_messageTable reloadData];
    }
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;  //EITHER WAY
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_chatMessageArray count];
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *message = [_chatMessageArray objectAtIndex:indexPath.row];
    UITableViewCell *cell = nil;
    if([_user.userId isEqualToString:[message valueForKey:@"_id"]]){
        cell = [tableView dequeueReusableCellWithIdentifier:@"MesssageFromYouCell"];
    }
    else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"MessageFromOtherCell"];
    }
    cell.textLabel.text = [message valueForKey:@"message"];
    
    return cell;
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
