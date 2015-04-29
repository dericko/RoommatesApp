//
//  AddMembersViewController.m
//  RoommatesApp
//
//  Created by Sam Lobel on 4/28/15.
//  Copyright (c) 2015 DerickSam. All rights reserved.
//

#import "AddMembersViewController.h"
#import "SessionManager.h"


//DERICK, YOU'VE CONVINCED ME, THIS IS A WHOLE BIG CAN OF WORMS I DON'T WANT TO DO.

@interface AddMembersViewController ()
@property(strong,nonatomic) IBOutlet UITableView *addMembersTable;
@property(strong,nonatomic) IBOutlet UITableView *addedMembersTable;
@property(strong,nonatomic) NSMutableArray *prefixResults;
@property(strong, nonatomic) NSMutableArray *addedMembersArray;
@property IBOutlet UITextField *searchBar;
@property (weak, nonatomic) IBOutlet UIButton *createGroupButton;
@property (strong,nonatomic) SessionManager *sharedManager;

@property(strong,nonatomic) NSNumber *groupExistsBool;
@property (weak, nonatomic) IBOutlet UITextField *groupNameField;

@end

@implementation AddMembersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.sharedManager = [SessionManager sharedManager];

    
    _addedMembersArray = [NSMutableArray arrayWithArray: @[]];
    _prefixResults = [NSMutableArray arrayWithArray: @[]];
    
    self.addMembersTable.dataSource = self;
    self.addedMembersTable.dataSource = self;
    
    self.addMembersTable.delegate = self;
    self.addedMembersTable.delegate = self;
    
    [self setUserArrayOnTyping:nil];
    
    [_sharedManager GET:@"getGroupMembers" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *responseDict = (NSDictionary *) responseObject;
        _groupExistsBool = [responseDict objectForKey:@"isGroup"];
        NSLog(@"Group exists: %@", _groupExistsBool);
        if ([_groupExistsBool isEqualToNumber:@0]){
            _createGroupButton.tag = 0;//group doesn't exist
            _createGroupButton.titleLabel.text = @"Create Group";
        } else{
            _createGroupButton.tag = 1;//group exists
            NSArray *existingGroupMembers = [responseDict objectForKey:@"groupUsers"];
            _addedMembersArray = [NSMutableArray arrayWithArray:existingGroupMembers];
            _createGroupButton.titleLabel.text = @"Add Members";
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"FAILURE: %@", error);
    }];

    
    
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(BOOL)insideAddedMembersArrayAlready:(NSDictionary *)member{
    for(NSDictionary *object in _addedMembersArray){
        if ([member isEqualToDictionary:object]){
            return YES;
        }
    }
    return NO;
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

-(IBAction)setUserArrayOnTyping:(id)sender{


    NSString *prefixText = _searchBar.text;
    NSMutableDictionary *toSerialize = [[NSMutableDictionary alloc] init];
    [toSerialize setValue:prefixText forKey:@"prefix"];
    [_sharedManager GET:@"getUsersWithPrefix" parameters:toSerialize success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *responseArray = (NSArray *)responseObject;
        _prefixResults = [NSMutableArray arrayWithArray:responseArray];
        [_addMembersTable reloadData];
        [_addedMembersTable reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"FAILURE: %@", error);
    }];
    
}

-(NSDictionary *)serializeGroup{
    NSMutableDictionary *serialized = [[NSMutableDictionary alloc] init];
    [serialized setObject:[_addedMembersArray copy] forKey:@"groupMembers"];
    [serialized setObject:_groupNameField.text forKey:@"groupName"];
    NSDictionary *toReturn = [serialized copy];
    return toReturn;
}

-(IBAction)buttonClicked:(id)sender{
    if([_groupNameField.text length] != 0){
        NSLog(@"Group is being created");
        NSDictionary *serialized = [self serializeGroup];
        [_sharedManager POST:@"createNewGroup" parameters:serialized success:^(NSURLSessionDataTask *task, id responseObject) {
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Group Created" message:@"Group successfully created." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {}];
            
            [alert addAction:defaultAction];

            [self presentViewController:alert animated:YES completion:nil];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
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
