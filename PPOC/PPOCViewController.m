//
//  PPOCViewController.m
//  PPOC
//
//  Created by Luan-Ling Chiang on 7/19/14.
//  Copyright (c) 2014 gdeformer. All rights reserved.
//

#import "PPOCViewController.h"
#import "UNIRest.h"
#import "PPOCCell.h"
#import "Results.h"
#import "PPOCDetailViewController.h"

@interface PPOCViewController ()
{
    NSMutableArray* aResult;
    UIView* loadScreen;
    UIActivityIndicatorView *spinner;
    NSMutableArray *tableItems;
    NSMutableDictionary *cachedImages;
}
@end

@implementation PPOCViewController
@synthesize model = _model;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _model = [PPOCAppModel sharedInstance];
    
    self.navigationController.navigationBar.translucent=true;
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        //iOS 7 method check
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    [self setNavigationBarStyle];
    
    [self getLoadScreen];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fetchCompleted:) name:@"DATA_MAP_SUCCESS" object:nil];
    
    cachedImages = [[NSMutableDictionary alloc] init];
    tableItems = [[NSMutableArray alloc] init];
}

- (BOOL)prefersStatusBarHidden{
    return YES;
}

- (void)getLoadScreen
{
    float w = self.view.frame.size.width;
    float h = self.view.frame.size.height;
    float spinnerSize = 50;
    
    loadScreen = [[UIView alloc]initWithFrame:CGRectMake(0, 0, w, h)];
    [loadScreen setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:loadScreen];
    
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.frame = CGRectMake((w-spinnerSize)/2, h*0.3, spinnerSize, spinnerSize);
    [loadScreen addSubview:spinner];
    [spinner startAnimating];
}

-(void)detachLoadScreen
{
    [UIView animateWithDuration:0.3 animations:^{
        loadScreen.alpha = 0;
    } completion:^(BOOL finished) {
        [spinner stopAnimating];
        [spinner removeFromSuperview];
        [loadScreen removeFromSuperview];
    }];
}

- (void)setNavigationBarStyle
{
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    
    UIImage *image = [UIImage imageNamed: @"navbar_logo.png"];
    UIImageView *imageview = [[UIImageView alloc] initWithImage: image];
    self.navigationItem.titleView = imageview;
    UIColor *blue = [UIColor colorWithRed:(0/255.f) green:(120/255.f) blue:(147/255.f) alpha:1.0];
    
    navigationBar.backgroundColor = [UIColor clearColor];
    navigationBar.layer.shadowOpacity = 0.3;
    navigationBar.layer.shadowColor = [blue CGColor];
    navigationBar.layer.shadowOffset = CGSizeMake(0, 0);
    navigationBar.layer.shadowRadius = 12;
    navigationBar.layer.masksToBounds = NO;
}

- (void)fetchCompleted:(NSNotification *) notification
{
    [self detachLoadScreen];
    NSDictionary *userInfo = notification.userInfo;
    aResult = [userInfo objectForKey:@"results"];
    [self.tableView reloadData];
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return aResult.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PPOCCell* cell;
    if([tableView respondsToSelector:@selector(dequeueReusableCellWithIdentifier:forIndexPath:)]){
        //iOS 6 method
        cell = [tableView dequeueReusableCellWithIdentifier:@"ResultCell" forIndexPath:indexPath];
    }else{
        //iOS 5 methos
        cell = [tableView dequeueReusableCellWithIdentifier:@"ResultCell"];
    }
    
    Results* result = aResult[indexPath.row];
    
    cell.titleLabel.text = result.title;
    cell.titleLabel.frame = CGRectMake(140, 30, 150, 60);
    cell.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
    
    NSString *date = [result.source_created substringToIndex:10];
    cell.dateLabel.frame = CGRectMake(140, 12, cell.dateLabel.frame.size.width, cell.dateLabel.frame.size.height);
    cell.dateLabel.text = date;
    
    if(!cell.colorBlock){
        cell.colorBlock = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 4, cell.frame.size.height-1)];
        [cell.colorBlock setBackgroundColor:[UIColor colorWithRed:(0/255.f) green:(120/255.f) blue:(174/255.f) alpha:1]];
        cell.colorBlock.alpha=0.4;
        [cell addSubview:cell.colorBlock];
    }
    
    if(!cell.backgroundBlock){
        cell.backgroundBlock = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, cell.frame.size.height)];
        [cell.backgroundBlock setBackgroundColor:[UIColor colorWithRed:(0/255.f) green:(120/255.f) blue:(174/255.f) alpha:1]];
        [cell insertSubview:cell.backgroundBlock belowSubview:cell.image];
        cell.backgroundBlock.alpha= 0.05;
    }
    
    cell.imageUrl = result.image;
    [cell loadThumb];
    [cell sizeToFit];
    [cell setNeedsDisplay];
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showPhotoDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Results* result = aResult[indexPath.row];
        PPOCDetailViewController *destViewController = segue.destinationViewController;
        destViewController.result = result;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
