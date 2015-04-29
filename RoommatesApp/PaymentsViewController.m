//
//  PaymentsViewController.m
//  RoommatesApp
//
//  Created by Derick Olson on 4/25/15.
//  Copyright (c) 2015 DerickSam. All rights reserved.
//

#import "PaymentsViewController.h"
#import "User.h"
#import "NetworkConstants.h"

@interface PaymentsViewController ()

@end

@implementation PaymentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
// TODO Add method: venmoLoggedIn to user
    BOOL loggedIn = [[User currentUser] isLoggedIn];
    
    if (loggedIn) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kVENMO_AUTH_URL]];
    }
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
