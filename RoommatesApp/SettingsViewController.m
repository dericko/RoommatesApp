//
//  SettingsViewController.m
//  RoommatesApp
//
//  Created by Sam Lobel on 4/29/15.
//  Copyright (c) 2015 DerickSam. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()
@property (weak, nonatomic) IBOutlet UITableView *groupMemberTableView;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (IBAction)signoutPressed:(id)sender {
}

# pragma mark - Table View Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;  //EITHER WAY
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView isEqual:_addedMembersTable]){
        return [_addedMembersArray count];
    } else{
        return [_prefixResults count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    NSDictionary *selectedMember = nil;
    if ([tableView isEqual:_addMembersTable]){
        //        NSDictionary *selectedMember = [_prefixResults ob]
        selectedMember = [_prefixResults objectAtIndex:indexPath.row];
        if ([self insideAddedMembersArrayAlready:selectedMember]){
            cell = [tableView dequeueReusableCellWithIdentifier:@"AlreadyAddedMemberCell"];
        }
        else{
            cell = [tableView dequeueReusableCellWithIdentifier:@"ProspectiveMemberCell"];
        }
        
    } else if([tableView isEqual:_addedMembersTable]){
        selectedMember = [_addedMembersArray objectAtIndex:indexPath.row];
        cell = [tableView dequeueReusableCellWithIdentifier:@"AddedMemberCell"];
    }
    cell.textLabel.text = [selectedMember valueForKey:@"username"];
    return cell;
}

//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    if([tableView isEqual:_addMembersTable]){
//        NSDictionary *memberSelected = [_prefixResults objectAtIndex:indexPath.row];
//        [_addedMembersArray insertObject:memberSelected atIndex:0];
//    }
//    [_addMembersTable reloadData];
//    [_addedMembersTable reloadData];
//} WAS REPEAT METHOD



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([tableView isEqual:_addMembersTable]){
        NSDictionary *selectedMember = (NSDictionary *) [_prefixResults objectAtIndex:indexPath.row];
        if([self insideAddedMembersArrayAlready:selectedMember]){
            NSLog(@"Already selected, ya drangus!");
            return;
        }
        [_addedMembersArray insertObject:selectedMember atIndex:0];
        [_addedMembersTable reloadData];
        [_addMembersTable reloadData];
        //I really should have two types of cells, one for selected already, and one for not. And if it's been selected
        //already, you shouldn't be able to click it, and it should look a little different.
        return;
    }
    
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
