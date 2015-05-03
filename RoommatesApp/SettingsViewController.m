//
//  SettingsViewController.m
//  RoommatesApp
//
//  Created by Sam Lobel on 4/29/15.
//  Copyright (c) 2015 DerickSam. All rights reserved.
//

#import "SettingsViewController.h"
#import "NetworkConstants.h"
#import "User.h"

#define safeSet(d,k,v) if (v) d[k] = v;

@interface SettingsViewController ()
@property (weak, nonatomic) IBOutlet UITableView *groupMemberTableView;
@property(strong,nonatomic) NSMutableArray *groupMembers;


@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Assign delegates and datasource
    self.groupMemberTableView.dataSource = self;
    self.groupMemberTableView.delegate = self;
    
    [self getGroupMembers];
}

-(NSMutableDictionary *)registerDictionary {
    User *currentUser = [User currentUser];
    NSMutableDictionary *toSerialize = [NSMutableDictionary dictionary];
    safeSet(toSerialize, @"_id", currentUser.userId);
    return toSerialize;
}

- (void)getGroupMembers {
    
    
    [[SessionManager sharedManager]
     GET:@"getGroupMembers"
     parameters:[self registerDictionary]
     success:^(NSURLSessionDataTask *task, id responseObject) {
         NSDictionary *responseDict = (NSDictionary *) responseObject;
         BOOL foundGroup = [responseDict objectForKey:@"isGroup"];
         if (!foundGroup) {
             [self performSegueWithIdentifier:@"LoadHomepage" sender:self];
         }
         NSArray *existingGroupMembers = [responseDict objectForKey:@"groupUsers"];
         NSLog(@"group members: %@", responseObject);
         _groupMembers = [NSMutableArray arrayWithArray:existingGroupMembers];
         [self.groupMemberTableView reloadData];
     }
     failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"FAILURE: %@", error);
    }];
}


- (IBAction)signoutPressed:(id)sender {
}

# pragma mark - Table View Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;  //EITHER WAY
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_groupMembers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
//    if ([tableView isEqual:_addMembersTable]){
//        //        NSDictionary *selectedMember = [_prefixResults ob]
//        selectedMember = [_prefixResults objectAtIndex:indexPath.row];
//        if ([self insideAddedMembersArrayAlready:selectedMember]){
//            cell = [tableView dequeueReusableCellWithIdentifier:@"AlreadyAddedMemberCell"];
//        }
//        else{
//            cell = [tableView dequeueReusableCellWithIdentifier:@"ProspectiveMemberCell"];
//        }
//        
//    } else if([tableView isEqual:_addedMembersTable]){
//        selectedMember = [_addedMembersArray objectAtIndex:indexPath.row];
//        cell = [tableView dequeueReusableCellWithIdentifier:@"AddedMemberCell"];
//    }
//    cell.textLabel.text = [selectedMember valueForKey:@"username"];
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"groupMemberCell"];
    cell.textLabel.text = [[_groupMembers objectAtIndex:indexPath.row] valueForKey:@"username"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    // TODO: go to group member's profile page
    
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
