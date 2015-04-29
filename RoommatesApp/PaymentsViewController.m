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
@property (weak, nonatomic) IBOutlet UIButton *linkVenmoButton;
@property (weak, nonatomic) IBOutlet UILabel *notificationLabel;

@end

@implementation PaymentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    // TODO Add method: venmoLoggedIn to user
    BOOL loggedIn = [[User currentUser] isLoggedIn];
    
    if (loggedIn) {
        [self linkVenmoPressed:nil];
    } else {
        [self.notificationLabel setHidden:YES];
        [self.linkVenmoButton setHidden:YES];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    
    
}

- (IBAction)linkVenmoPressed:(id)sender {
    NSString *url = [NSString stringWithFormat:@"%@%@", kVENMO_AUTH_URL, [[User currentUser] userId]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
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
