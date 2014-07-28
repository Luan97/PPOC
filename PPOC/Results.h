//
//  Results.h
//  PPOC
//
//  Created by Luan-Ling Chiang on 7/20/14.
//  Copyright (c) 2014 gdeformer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Results : NSManagedObject

@property (nonatomic, retain) id collection;
@property (nonatomic, retain) NSString * creator;
@property (nonatomic, retain) NSNumber * index;
@property (nonatomic, retain) NSString * medium;
@property (nonatomic, retain) NSString * source_created;
@property (nonatomic, retain) id subjects;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * created;
@property (nonatomic, retain) id image;
@property (nonatomic, retain) NSString * call_number;
@property (nonatomic, retain) NSString * medium_brief;
@property (nonatomic, retain) id links;
@property (nonatomic, retain) NSString * source_modified;
@property (nonatomic, retain) NSString * reproduction_number;
@property (nonatomic, retain) NSString * modified;
@property (nonatomic, retain) NSString * pk;
@property (nonatomic, retain) NSString * created_published_date;

@end
