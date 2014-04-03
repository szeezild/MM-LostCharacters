//
//  Character.h
//  LostCharacters
//
//  Created by Dan Szeezil on 4/2/14.
//  Copyright (c) 2014 Dan Szeezil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Character : NSManagedObject

@property (nonatomic, retain) NSString * actor;
@property (nonatomic, retain) NSString * characterName;
@property (nonatomic, retain) NSString * sex;

@end
