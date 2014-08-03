//
//  PPOCAppModel.m
//  PPOC
//
//  Created by Luan-Ling Chiang on 7/19/14.
//  Copyright (c) 2014 gdeformer. All rights reserved.
//

#import "PPOCAppModel.h"
#import "UNIRest.h"
#import "DocumentManager.h"
#import "Results.h"

@interface PPOCAppModel()
{
    DocumentManager *dManager;
    NSManagedObjectContext *managedObjectContext;
    
}
@end

@implementation PPOCAppModel
@synthesize hitCount = _hitCount;
static PPOCAppModel *sharedInstance = nil;

+ (PPOCAppModel *)sharedInstance
{
    if (sharedInstance == nil) {
        sharedInstance = [[super allocWithZone:NULL] init];
    }
    
    return sharedInstance;
}

-(id)init{
    self = [super init];
    if (self){
        dManager = [DocumentManager sharedInstance];
        managedObjectContext = [dManager managedObjectContext];
    }
    return self;
}

/* -------------------------------------------------------
 * Fetch data from web service (using UNIRest library)
 * ------------------------------------------------------*/
- (void)fetchData
{
    NSDictionary *headers = @{@"accept": @"application/json"};
    NSDictionary *parameters = @{@"q": @"congress", @"fo": @"json"};
    __block NSDictionary *userInfo;
    
    [[UNIRest post:^(UNISimpleRequest *request) {
        [request setUrl:@"http://www.loc.gov/pictures/search/"];
        [request setHeaders:headers];
        [request setParameters:parameters];
    }] asJsonAsync:^(UNIHTTPJsonResponse* response, NSError *error) {
        NSInteger code = response.code;
        NSData *rawBody = response.rawBody;
        
        if(!error){
            if(code!=200){
                return;
            }
            NSError *e = nil;
            NSDictionary* json = [NSJSONSerialization JSONObjectWithData:rawBody                                               options:kNilOptions error:&e];
            if(!e){
                //if success, parse data
                [self parseData:json];
            }else{
                //parse error handling
                userInfo = [NSDictionary dictionaryWithObject:e.localizedDescription forKey:@"error"];
                [self dispatchErrorHandlingEvent:userInfo];
            }
        }else{
            //connection error handling
            userInfo = [NSDictionary dictionaryWithObject:error.localizedDescription forKey:@"error"];
            [self dispatchErrorHandlingEvent:userInfo];
        }
    }];
}

#pragma mark - Data processing

- (void)parseData:(NSDictionary*)data
{
    
    NSDictionary* search = [data objectForKey:@"search"];
    
    //TODO was going to use the total hits count that return from the search result. In order to have pagination ability in the future. Short of time for code exam
    _hitCount = [(NSString*)[search objectForKey:@"hits"] integerValue];
    
    //find results in return data
    NSDictionary* results = [data objectForKey:@"results"];
    
    //set result in CoreData
    [self setResult:results];
}

- (void)setResult:(NSDictionary *)data
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^()
    {
        NSMutableArray* coreDataResults = [dManager fetchArrayFromDBWithEntity:@"Results" forKey:@"index" withPredicate:Nil];
        bool exist = (coreDataResults.count!=0);
        
        if(!exist){
            //if never saved before, map data to local database
            for(id obj in data){
                [self mapResultEntity:obj];
            }
        }else{
            //if exist, check if any values need to be updated, if not, then mape data to local database
            for(id obj in data){
                
                NSString *objIndex = [obj objectForKey:@"index"];
                int index = [objIndex integerValue];
                
                if(index<=coreDataResults.count-1){
                    Results* oldObj = (Results*)[coreDataResults objectAtIndex:index];
                    [self mapEntityProperties:oldObj withData:obj];
                }else if((data.count>coreDataResults.count)&&index>coreDataResults.count){
                    [self mapResultEntity:obj];
                }
            }
        }
        //save
        [self saveToContext];
    });
}

/* -------------------------------------------------------
 * helper function for creating new data entry
 * ------------------------------------------------------*/
- (void)mapResultEntity:(id)obj{
    Results *result= (Results*) [NSEntityDescription insertNewObjectForEntityForName:@"Results" inManagedObjectContext:managedObjectContext];
    NSString *objIndex = [obj objectForKey:@"index"];
    result.index = [NSNumber numberWithInt:[objIndex integerValue]];
    
    [self mapEntityProperties:result withData:obj];
}

/* -------------------------------------------------------
 * helper function for updating existing data
 * ------------------------------------------------------*/
 
- (void)mapEntityProperties:(Results*)result withData:(id)obj
{
    
    for(id property in obj){
        id value= ([obj objectForKey:property]!=[NSNull null])?[obj objectForKey:property]: @"";
        [result setValue:value forKey:property];
    }
}

/* -------------------------------------------------------
 * save data to context
 * ------------------------------------------------------*/
- (void)saveToContext
{
    NSError *error = nil;
    
    if (![managedObjectContext save:&error])
    {
        NSDictionary* userInfo = [NSDictionary dictionaryWithObject:error.localizedDescription forKey:@"error"];
        [self dispatchErrorHandlingEvent:userInfo];
        
    }else{
        [self DisplayContentWithCoreDataEntiry];
    }
}

#pragma mark - Error or Success event dispatching mechanism
/* -------------------------------------------------------
 * Error handling
 * ------------------------------------------------------*/
- (void)dispatchErrorHandlingEvent:(NSDictionary*)userInfo{
    dispatch_async(dispatch_get_main_queue(), ^()
    {
       
       [[NSNotificationCenter defaultCenter] postNotificationName:@"SHOW_PARSE_ERROR" object:nil userInfo:userInfo];
    });
}

/* -------------------------------------------------------
 * success saved, fetch result and sort.
 * Then request for displaying content in UITableView
 * ------------------------------------------------------*/
- (void)DisplayContentWithCoreDataEntiry{
    NSDictionary *userInfo;
    NSMutableArray* coreDataResults = [dManager fetchArrayFromDBWithEntity:@"Results" forKey:@"index" withPredicate:Nil];
    NSSortDescriptor * sort = [[NSSortDescriptor alloc] initWithKey:@"index" ascending:true];
    NSArray* sortedArray = [coreDataResults sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
    
    userInfo = [NSDictionary dictionaryWithObject:sortedArray forKey:@"results"];
    
    dispatch_async(dispatch_get_main_queue(), ^()
    {
       [[NSNotificationCenter defaultCenter] postNotificationName:@"DATA_MAP_SUCCESS" object:nil userInfo:userInfo];
    });
}


@end


