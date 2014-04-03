//
//  RootViewController.m
//  LostCharacters
//
//  Created by Dan Szeezil on 4/2/14.
//  Copyright (c) 2014 Dan Szeezil. All rights reserved.
//

#import "RootViewController.h"
#import "Character.h"
#import "DetailViewController.h"
#import <CoreData/CoreData.h>


@interface RootViewController () <UITableViewDelegate, UITableViewDataSource>

@property NSArray *characterArray;

@property (weak, nonatomic) IBOutlet UITextField *charNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *actorNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *sexTextField;

@property (weak, nonatomic) IBOutlet UITableView *charTableView;

@end


@implementation RootViewController


//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    self.characterArray = @[@"Dan", @"Pat", @"Len"];
    
    
    [self load];
    
//    [self.charTableView reloadData];
    
}

-(void)load
{
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Character"];
    
    NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"actor" ascending:YES];
    NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"characterName" ascending:YES];
    
    NSArray *sortDescriptArray = [NSArray arrayWithObjects:sortDescriptor1, sortDescriptor2, nil];
    request.sortDescriptors = sortDescriptArray;
    
    self.characterArray = [self.managedObjContext executeFetchRequest:request error:nil];

    
    //    START
    
    //BOOL isCoreDataEmpty = self.charactersArray.count == 0;
    BOOL isFirstRun= ![[NSUserDefaults standardUserDefaults] boolForKey:@"hasRunOnce"];
    
    if(isFirstRun)
    {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setBool:YES forKey:@"hasRunOnce"];
        [userDefaults synchronize];
        
    // get (from internet) array of dictionaries that represent lost characters
    NSURL *url = [NSURL URLWithString:@"http://s3.amazonaws.com/mobile-makers-assets/app/public/ckeditor_assets/attachments/2/lost.plist"];
    self.characterArray = [NSArray arrayWithContentsOfURL:url];
    
    // we will put the Character objects in here
    NSMutableArray *mutableArray = [NSMutableArray new];
    
    // crap! charactersArray is an array of dictionaries
    for (NSDictionary *characterDictionary in self.characterArray)
    {
        // Convert each NSDictionary into a Character object
        Character* character = [NSEntityDescription insertNewObjectForEntityForName:@"Character" inManagedObjectContext:self.managedObjContext];
        character.actor= characterDictionary[@"actor"];
        character.characterName = characterDictionary[@"passenger"];
        
        [mutableArray addObject:character];
        
    }
    
    self.characterArray = mutableArray;
}
    //    END

    
    [self.charTableView reloadData];
    
    self.charNameTextField.text = @"";
    self.actorNameTextField.text = @"";
    self.sexTextField.text = @"";
    
    
//    block to animate Add reload
    [UIView transitionWithView:self.charTableView
                      duration:1.0f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^(void) {
                        [self.charTableView reloadData];
                    } completion:NULL];
}


#pragma mark - Add Character

- (IBAction)addCharacter:(id)sender {
    
    Character *character = [NSEntityDescription insertNewObjectForEntityForName:@"Character" inManagedObjectContext:self.managedObjContext];
    
    character.characterName = self.charNameTextField.text;
    character.actor = self.actorNameTextField.text;
    character.sex = self.sexTextField.text;
    
    [self.managedObjContext save:nil];
    
    [self.charNameTextField endEditing:YES];
    [self.actorNameTextField endEditing:YES];
    [self.sexTextField endEditing:YES];

    [self load];
}

#pragma mark - TableView delegate methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.characterArray.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newCellID"];
    
    Character *character = self.characterArray[indexPath.row];
    
    cell.textLabel.text = character.actor;
    cell.detailTextLabel.text = character.characterName;
    
    return cell;
}


#pragma mark - Segues

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UITableViewCell *)sender {
    
    
    DetailViewController *vc = segue.destinationViewController;
    
    NSIndexPath *indexPath = [self.charTableView indexPathForCell:sender];
    
    Character *character = self.characterArray[indexPath.row];
    
    vc.actorName = character.actor;
    vc.characterName = character.characterName;
    vc.sex = character.sex;

}

#pragma mark - Delete methods

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
   
//    to delete from core data
    Character *character = [self.characterArray objectAtIndex:indexPath.row];
    [self.managedObjContext deleteObject:character];
    [self.managedObjContext save:nil];
    
    
//    to delete from tableview on screen
    NSMutableArray *tempArray = self.characterArray.mutableCopy;
    [tempArray removeObjectAtIndex:indexPath.row];
    self.characterArray = tempArray;
    
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}


//  to change text in Red Delete function
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"Contract Demands";
    
}









@end








