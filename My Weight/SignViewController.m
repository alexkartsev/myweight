//
//  SignViewController.m
//  My Weight
//
//  Created by Александр Карцев on 9/20/15.
//  Copyright (c) 2015 Alex Kartsev. All rights reserved.
//

#import "SignViewController.h"
@interface SignViewController() <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *loginTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end


@implementation SignViewController

-(void)viewDidLoad
{
    [self.loginTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [self.passwordTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [self.passwordTextField setSecureTextEntry:YES];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    UITapGestureRecognizer *touch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchEndEditing)];
    [self.view addGestureRecognizer:touch];
}

- (void) showAlertViewWithMessage:(NSString *) message
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Attention!" message: message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

- (void) touchEndEditing{
        [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}


- (IBAction)logInButton:(id)sender {
    
    //log in
    if (self.loginTextField.text.length==0 || self.passwordTextField.text.length==0)
    {
        [self showAlertViewWithMessage:@"Please, enter Login and Password"];
    }
    else
    {
        [PFUser logInWithUsernameInBackground:self.loginTextField.text password:self.passwordTextField.text
                                        block:^(PFUser *user, NSError *error) {
                                            if (user) {
                                                if (!error) {
                                                    [self performSegueWithIdentifier:@"mainView" sender:self];
                                                }
                                            }
                                            else {
                                                // The login failed. Check error to see why.
                                                [self showAlertViewWithMessage:@"Please, check your Login and Password"];
                                            }
                                        }];
    }
}
- (IBAction)signUpButton:(id)sender {
    
    //sign up
    if (self.loginTextField.text.length==0 || self.passwordTextField.text.length==0) {
        [self showAlertViewWithMessage:@"Please, enter Login and Password"];
    }
    else
    {
        PFUser *user = [PFUser user];
        user.username = self.loginTextField.text;
        user.password = self.passwordTextField.text;
        
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                [self performSegueWithIdentifier:@"mainView" sender:self];
            } else {
                [self showAlertViewWithMessage:@"Sorry, you can't use this Login"];
            }
        }];
    }
}

- (IBAction)unwindToViewControllerSign:(UIStoryboardSegue *)segue {
    [[DataManager sharedManager] deleteAllObjects];
    [PFUser logOut];
}


@end
