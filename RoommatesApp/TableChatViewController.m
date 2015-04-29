//
//  TableChatViewController.m
//  RoommatesApp
//
//  Created by Derick Olson on 4/29/15.
//  Copyright (c) 2015 DerickSam. All rights reserved.
//

#import "TableChatViewController.h"
#import "User.h"
#import "SessionManager.h"



@interface TableChatViewController ()

@property(strong,nonatomic)NSMutableArray *chatMessageArray;
@property(strong,nonatomic) User *user;
@property(strong,nonatomic) SessionManager *sharedManager;

@end

@implementation TableChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _chatMessageArray = [NSMutableArray arrayWithArray: @[]];
    _user = [User currentUser];
    _sharedManager = [SessionManager sharedManager];
    
    // Do any additional setup after loading the view.
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
    cell.textLabel.text = [message valueForKey:@"body"];
    
    return nil;
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
