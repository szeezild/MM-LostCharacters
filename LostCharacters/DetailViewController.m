//
//  DetailViewController.m
//  LostCharacters
//
//  Created by Dan Szeezil on 4/2/14.
//  Copyright (c) 2014 Dan Szeezil. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *actorDetailTextField;
@property (weak, nonatomic) IBOutlet UILabel *charDetailTextField;
@property (weak, nonatomic) IBOutlet UILabel *sexDetailTextField;


@end

@implementation DetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.actorDetailTextField.text = self.actorName;
    self.charDetailTextField.text = self.characterName;
    self.sexDetailTextField.text = self.sex;
    
}


@end











