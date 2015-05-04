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
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameTag;
@property (weak, nonatomic) IBOutlet UILabel *balanceTag;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (strong, nonatomic) NSDictionary *venmoInfo;

@end

@implementation PaymentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Hide everything initially...
    [self.notificationLabel setHidden:YES];
    [self.linkVenmoButton setHidden:YES];
    
    [self.imageView setHidden:YES];
    [self.usernameLabel setHidden:YES];
    [self.usernameTag setHidden:YES];
    [self.balanceLabel setHidden:YES];
    [self.balanceTag setHidden:YES];

    
    [self venmoHasBeenValidated];
    
    // Listen for entering foreground
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    
}

- (void)applicationWillEnterForeground:(NSNotification*)notification {
    [self venmoHasBeenValidated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self venmoHasBeenValidated];
}

- (void)venmoHasBeenValidated{
    self.notificationLabel.text = @"Getting venmo info...";
    [self.notificationLabel setHidden:NO];
    
    [[SessionManager sharedManager]
     GET:@"hasBeenVenmoValidated"
     parameters:nil
     success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *responseDict = (NSDictionary *) responseObject;
         NSLog(@"responseDict: %@", responseDict);

         // VALID
         if ([[responseDict objectForKey:@"answer"] isEqualToNumber:@1]) {
             
             _venmoInfo = [responseDict objectForKey:@"venmo"];
             NSLog(@"Venmo info: %@", _venmoInfo);
             [self displayVenmoInfo];
         
         // NOT VALID
         } else {
             [self askForSignup];
         }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"FAILURE: %@", error);
    }];
    
    
}

- (void) displayVenmoInfo {
    
    // Setup buttons
    [self.imageView setHidden:NO];
    [self.usernameLabel setHidden: NO];
    [self.usernameTag setHidden:NO];
    [self.balanceLabel setHidden:NO];
    [self.balanceTag setHidden:NO];
    
    [self.notificationLabel setHidden:YES];
    [self.linkVenmoButton setHidden:YES];
    
    
    // Assign fields
    self.balanceLabel.text = [NSString stringWithFormat:@"$%@", [_venmoInfo valueForKey:@"balance"]];
    self.usernameLabel.text = [_venmoInfo valueForKey:@"username"];

    // TODO: Set image async
//    NSString *ImageURL = [_venmoInfo valueForKey:@"profile_picture_url"];
//    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:ImageURL]];
//    _imageView.image = [UIImage imageWithData:imageData];
}

- (void) askForSignup {
    self.notificationLabel.text = @"Please sign in with venmo";
    [self.notificationLabel setHidden:NO];
    [self.linkVenmoButton setHidden:NO];
    
    [self.imageView setHidden:YES];
    [self.usernameLabel setHidden:YES];
    [self.usernameTag setHidden:YES];
    [self.balanceLabel setHidden:YES];
    [self.balanceTag setHidden:YES];
}

- (IBAction)linkVenmoPressed:(id)sender {
    NSString *url = [NSString stringWithFormat:@"%@%@", kVENMO_AUTH_URL, [[User currentUser] userId]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
//    self.tabBarController.selectedIndex = 1;
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
