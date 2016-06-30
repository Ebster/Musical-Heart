//
//  Tracks.h
//  Musical Heart
//
//  Created by Ebbie Swart on 2014/10/21.
//  Copyright (c) 2014 Gerub. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Person;

@interface Tracks : NSManagedObject

@property (nonatomic, retain) NSString * trackName;
@property (nonatomic, retain) NSNumber * trackHeartrate;
@property (nonatomic, retain) NSNumber * trackRecorded;
@property (nonatomic, retain) Person *trackPeople;

@end
