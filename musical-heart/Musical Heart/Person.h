//
//  Person.h
//  Musical Heart
//
//  Created by Ebbie Swart on 2014/10/21.
//  Copyright (c) 2014 Gerub. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Tracks;

@interface Person : NSManagedObject

@property (nonatomic, retain) NSString * personContact;
@property (nonatomic, retain) NSString * personEmail;
@property (nonatomic, retain) NSString * personName;
@property (nonatomic, retain) NSSet *personTracks;
@end

@interface Person (CoreDataGeneratedAccessors)

- (void)addPersonTracksObject:(Tracks *)value;
- (void)removePersonTracksObject:(Tracks *)value;
- (void)addPersonTracks:(NSSet *)values;
- (void)removePersonTracks:(NSSet *)values;

@end
