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
                [self parseData:json];
            }else{
                NSLog(@"JSON serialization error %@", e);
            }
        }else{
            NSLog(@"error %@", error);
            //TODO if connection error, check if there's data saved locally,
            //if not saved, show error msg on load screen
            //if saved, display the saved data
            userInfo = [NSDictionary dictionaryWithObject:@"There is a connection problem, please try again later on." forKey:@"errorMsg"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SHOW_PARSE_ERROR" object:nil userInfo:userInfo];
        }
    }];
}

- (void)parseData:(NSDictionary*)data
{
    //NSLog(@"%@", [data objectForKey:@"search"]);
    NSDictionary* search = [data objectForKey:@"search"];
    _hitCount = [(NSString*)[search objectForKey:@"hits"] integerValue];
    //NSLog(@"hitCount %d", _hitCount);
    NSDictionary* results = [data objectForKey:@"results"];
    [self setResult:results];
}

- (void)setResult:(NSDictionary *)data
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^()
    {
        dManager = [DocumentManager sharedInstance];
        managedObjectContext = [dManager managedObjectContext];
        NSMutableArray* coreDataResults = [dManager fetchArrayFromDBWithEntity:@"Results" forKey:@"index" withPredicate:Nil];
        
        bool exist = (coreDataResults.count!=0);
        
        if(!exist){
            for(id obj in data){
                [self mapResultEntity:obj];
            }
        }else{
            for(id obj in data){
                //NSLog(@"count %d", coreDataResults.count);
                NSString *objIndex = [obj objectForKey:@"index"];
                int index = [objIndex integerValue];
                //NSLog(@"index %d", index);
                if(index<=coreDataResults.count-1){
                    Results* oldObj = (Results*)[coreDataResults objectAtIndex:index];
                    [self mapEntityProperties:oldObj withData:obj];
                }else if((data.count>coreDataResults.count)&&index>coreDataResults.count){
                    [self mapResultEntity:obj];
                }
            }
        }
        [self saveToContext];
    });
}

- (void)mapResultEntity:(id)obj{
    Results *result= (Results*) [NSEntityDescription insertNewObjectForEntityForName:@"Results" inManagedObjectContext:managedObjectContext];
    NSString *objIndex = [obj objectForKey:@"index"];
    result.index = [NSNumber numberWithInt:[objIndex integerValue]];
    
    [self mapEntityProperties:result withData:obj];
}

- (void)mapEntityProperties:(Results*)result withData:(id)obj
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^()
    {
        for(id property in obj){
            id value= ([obj objectForKey:property]!=[NSNull null])?[obj objectForKey:property]: @"";
            [result setValue:value forKey:property];
        }
    });
}

- (void)saveToContext
{
    NSError *error = nil;
    NSDictionary *userInfo;
    if (![managedObjectContext save:&error])
    {
        NSLog(@"%@", error);
    }else{
        NSMutableArray* coreDataResults = [dManager fetchArrayFromDBWithEntity:@"Results" forKey:@"index" withPredicate:Nil];
        NSSortDescriptor * sort = [[NSSortDescriptor alloc] initWithKey:@"index" ascending:true];
        NSArray* sortedArray = [coreDataResults sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
        
        userInfo = [NSDictionary dictionaryWithObject:sortedArray forKey:@"results"];
        
        dispatch_async(dispatch_get_main_queue(), ^()
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"DATA_MAP_SUCCESS" object:nil userInfo:userInfo];
        });
    }
}


@end


