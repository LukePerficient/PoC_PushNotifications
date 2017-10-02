//
//  ViewController.m
//  PoC_PushNotifications
//
//  Created by DDC.Mac2 on 10/2/17.
//  Copyright © 2017 DDC.Mac2. All rights reserved.
//

#import "ViewController.h"
#import <UserNotifications/UserNotifications.h>

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UITextField *timeIntervalTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *repeatNotificationsSC;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

// Mark: Actions
- (IBAction)enablePushNotifications:(UIButton *)sender {
    self.messageLabel.text=@"Notifications Started";
    
    UNMutableNotificationContent* content = [self setupNotificationContent];
    
    UNTimeIntervalNotificationTrigger* trigger = [self setupNotificationTrigger];
    
    UNNotificationRequest* request = [self createNotificationRequest:content WithTrigger:trigger];
    
    [self executeNotificationRequest:request];
}

- (IBAction)disablePushNotifications:(UIButton *)sender {
    self.messageLabel.text=@"Notifications Stopped";

    UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
    
    [center removeAllPendingNotificationRequests];
}

// Mark: Notification Handling
- (UNMutableNotificationContent *)setupNotificationContent
{
    UNMutableNotificationContent* content = [[UNMutableNotificationContent alloc] init];
    content.title = [NSString localizedUserNotificationStringForKey:@"Wake up!" arguments:nil];
    content.body = [NSString localizedUserNotificationStringForKey:@"Rise and shine! It's morning time!"
                                                         arguments:nil];
    
    return content;
}

- (UNTimeIntervalNotificationTrigger *)setupNotificationTrigger
{
    // Configure the trigger.
    NSTimeInterval userDefinedTimeInterval = [_timeIntervalTextField.text doubleValue];
    
    BOOL isIntervalAtLeast60Seconds = userDefinedTimeInterval >= 60;
    
    if (!isIntervalAtLeast60Seconds) {
        userDefinedTimeInterval = 60; // Minimum required interval for repeating notifications
    }
    
    BOOL userWantsRepeatOption = [_repeatNotificationsSC selectedSegmentIndex] == 0;
    BOOL willRepeat = NO;
    
    if (userWantsRepeatOption) {
        willRepeat = YES;
    } else {
        willRepeat = NO;
    }
    
    UNTimeIntervalNotificationTrigger* trigger = [UNTimeIntervalNotificationTrigger
                                                  triggerWithTimeInterval:userDefinedTimeInterval repeats: willRepeat];
    
    return trigger;
}

- (UNNotificationRequest *)createNotificationRequest:(UNMutableNotificationContent *)defaultContent WithTrigger:(UNTimeIntervalNotificationTrigger *)defaultTrigger
{
    // Create the request object.
    UNNotificationRequest* request = [UNNotificationRequest
                                      requestWithIdentifier:@"MorningAlarm" content:defaultContent trigger:defaultTrigger];
    
    return request;
}

- (void)executeNotificationRequest:(UNNotificationRequest *)defaultRequest
{
    UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
    [center addNotificationRequest:defaultRequest withCompletionHandler:^(NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

@end
