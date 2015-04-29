//
//  RegisterViewController.m
//  RoommatesApp
//
//  Created by Derick Olson on 4/25/15.
//  Copyright (c) 2015 DerickSam. All rights reserved.
//

#import "RegisterViewController.h"
#import "SessionManager.h"
#import "User.h"

#define safeSet(d,k,v) if (v) d[k] = v;



@interface RegisterViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;


@end

@implementation RegisterViewController

- (void)autoload {
    NSArray *users = @[@"Bonnie", @"Clyde", @"Fillmore", @"Johnson", @"Lester", @"Sallie", @"Anisha", @"Yassein", @"Aaron", @"Danny", @"Dylan", @"Darlene", @"Kelly", @"Santosh", @"Stewie", @"Markos", @"Stucky", @"Charlotte", @"Charlie", @"Chuck", @"Brianne", @"Lynkstra", @"Tobias", @"Maurice", @"Starlet", @"Scarlett", @"Aenaes", @"Phillip", @"Seymour", @"Stan", @"Tori", @"Victor", @"Carl", @"Dilbert", @"Edward", @"Franklin", @"Grant", @"Gerald", @"Hank", @"Izzy", @"Ishmael", @"Jacob", @"Jackie", @"Jordan", @"Josiah", @"Klyde", @"Kent", @"Leonard", @"Norbet", @"Orien", @"Oberon", @"Paulina", @"Patty", @"Susan", @"Tyrone", @"Xena", @"Yuri", @"Zed"];
    for (NSString* user in users) {
        _usernameField.text = user;
        _passwordField.text = @"password";
        [self registerPressed:NULL];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(NSMutableDictionary *)registerDictionary{
    NSMutableDictionary *toSerialize = [NSMutableDictionary dictionary];
    safeSet(toSerialize, @"username", _usernameField.text);
    safeSet(toSerialize, @"password", _passwordField.text);
    return toSerialize;
}

-(IBAction)registerPressed:(id)sender{
    NSLog(@"Pressed");
    
    SessionManager *sharedManager = [SessionManager sharedManager];
    
    [sharedManager POST:@"register"
             parameters:[self registerDictionary]
                success:^(NSURLSessionDataTask *task, id responseObject) {
                    // Success
                    NSDictionary *responseDict = (NSDictionary *)responseObject;
                    NSLog(@"RES AS DICT\n%@", [responseDict description]);
                    User *user = [User currentUser];
                    [user loginForUser:responseDict];
                    _errorLabel.text = @"SUCCESS!";
                    [self performSegueWithIdentifier:@"LoadHomepage" sender:self];
                }
                failure:^(NSURLSessionDataTask *task, NSError *error) {
                    // Failure
                    NSLog(@"FAILURE : %@", error);
                    _errorLabel.text = @"ERROR";

                }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
