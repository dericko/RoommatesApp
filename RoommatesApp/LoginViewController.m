//
//  LoginViewController.m
//  RoommatesApp
//
//  Created by Derick Olson on 4/25/15.
//  Copyright (c) 2015 DerickSam. All rights reserved.
//

#import "LoginViewController.h"
#import "SessionManager.h"
#import "User.h"
#define safeSet(d,k,v) if (v) d[k] = v;

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    SessionManager *sharedManager = [SessionManager sharedManager];
    [sharedManager GET:@"isUserPartOfGroup"
            parameters: nil
                success:^(NSURLSessionDataTask *task, id responseObject) {
                    // Success
                    NSLog(@"ABLE TO GET");
                }
                failure:^(NSURLSessionDataTask *task, NSError *error) {
                    // Failure
                    NSLog(@"UNABLE TO GET");
                }];
}

-(NSMutableDictionary *)loginDictionary{
    NSMutableDictionary *toSerialize = [NSMutableDictionary dictionary];
    safeSet(toSerialize, @"username", _usernameField.text);
    safeSet(toSerialize, @"password", _passwordField.text);
    return toSerialize;
}

- (IBAction)loginPressed:(id)sender {

    NSLog(@"Pressed");
    
    SessionManager *sharedManager = [SessionManager sharedManager];
    
    [sharedManager POST:@"login"
             parameters:[self loginDictionary]
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
