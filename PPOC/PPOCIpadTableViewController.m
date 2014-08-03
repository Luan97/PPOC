//
//  PPOCIpadTableViewController.m
//  PPOC
//
//  Created by Luan-Ling Chiang on 7/30/14.
//  Copyright (c) 2014 gdeformer. All rights reserved.
//

#import "PPOCIpadTableViewController.h"
#import "UNIRest.h"
#import "PPOCDoubleCell.h"
#import "Results.h"
#import "PPOCDetailViewController.h"
#import "AbstractTextView.h"

@interface PPOCIpadTableViewController ()
{
    NSMutableArray* aResult;
    UIView* loadScreen;
    UIActivityIndicatorView *spinner;
    AbstractTextView * errorMsg;

}
@end

@implementation PPOCIpadTableViewController
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showErrorMsg:) name:@"SHOW_PARSE_ERROR" object:nil];
}

- (void)showErrorMsg:(NSNotification *) notification
{
    [spinner stopAnimating];
    [spinner removeFromSuperview];
    
    if(!errorMsg){
        errorMsg = [[AbstractTextView alloc]initWithFrame:CGRectMake(35, 100, self.view.frame.size.width-70, 20)];
        [self.view addSubview:errorMsg];
        [errorMsg setSize:16];
    }
    NSString * error = @"OOPS!\n\n";
    error = [error stringByAppendingString:[[notification userInfo] objectForKey:@"error"]];
    error = [error stringByAppendingString:@" Please make sure you have internet access or try again later. \n\nThanks!"];
    errorMsg.textColor = [UIColor colorWithRed:(0/255.f) green:(120/255.f) blue:(147/255.f) alpha:1.0];
    
    [errorMsg setText:error];
}

- (BOOL)prefersStatusBarHidden
{
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
    int cnt = (int)roundf(aResult.count/2);
    NSInteger count = (NSInteger) cnt;
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PPOCDoubleCell* cell;
    if([tableView respondsToSelector:@selector(dequeueReusableCellWithIdentifier:forIndexPath:)]){
        //iOS 6 method
        cell = [tableView dequeueReusableCellWithIdentifier:@"ResultCell" forIndexPath:indexPath];
    }else{
        //iOS 5 method
        cell = [tableView dequeueReusableCellWithIdentifier:@"ResultCell"];
    }
    
    Results* result = aResult[indexPath.row*2];
    Results* result2 = aResult[(indexPath.row*2)+1];
    
    cell.titleLabel.text = result.title;
    cell.titleLabel.frame = CGRectMake(145, 53, 190, 60);
    cell.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
    
    cell.titleLabelTwo.text = result2.title;
    cell.titleLabelTwo.frame = CGRectMake(531, 53, 190, 60);
    cell.titleLabelTwo.lineBreakMode = UILineBreakModeWordWrap;
    
    NSString *date = [result.source_created substringToIndex:10];
    cell.dateLabel.frame = CGRectMake(145, 36, cell.dateLabel.frame.size.width, cell.dateLabel.frame.size.height);
    cell.dateLabel.text = date;
    
    date = [result2.source_created substringToIndex:10];
    cell.dateLabelTwo.frame = CGRectMake(531, 36, cell.dateLabelTwo.frame.size.width, cell.dateLabelTwo.frame.size.height);
    cell.dateLabelTwo.text = date;
    
    if(!cell.colorBlock){
        cell.colorBlock = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, cell.frame.size.height-1)];
        [cell.colorBlock setBackgroundColor:[UIColor colorWithRed:(0/255.f) green:(120/255.f) blue:(174/255.f) alpha:1]];
        cell.colorBlock.alpha=0.4;
        [cell addSubview:cell.colorBlock];
    }
    
    if(!cell.colorBlockTwo){
        cell.colorBlockTwo = [[UIView alloc]initWithFrame:CGRectMake(cell.frame.size.width/2, 0, 3, cell.frame.size.height-1)];
        [cell.colorBlockTwo setBackgroundColor:[UIColor colorWithRed:(0/255.f) green:(120/255.f) blue:(174/255.f) alpha:1]];
        cell.colorBlockTwo.alpha=0.4;
        [cell addSubview:cell.colorBlockTwo];
    }
    
    if(!cell.backgroundBlock){
        cell.backgroundBlock = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, cell.frame.size.height)];
        [cell.backgroundBlock setBackgroundColor:[UIColor colorWithRed:(0/255.f) green:(120/255.f) blue:(174/255.f) alpha:1]];
        [cell insertSubview:cell.backgroundBlock belowSubview:cell.image];
        cell.backgroundBlock.alpha= 0.1;
    }
    
    if(!cell.backgroundBlockTwo){
        cell.backgroundBlockTwo = [[UIView alloc]initWithFrame:CGRectMake(cell.frame.size.width/2, 0, 0, cell.frame.size.height)];
        [cell.backgroundBlockTwo setBackgroundColor:[UIColor colorWithRed:(0/255.f) green:(120/255.f) blue:(174/255.f) alpha:1]];
        [cell insertSubview:cell.backgroundBlockTwo belowSubview:cell.imageTwo];
        cell.backgroundBlockTwo.alpha= 0.1;
    }
    
    cell.buttonOne.tag=indexPath.row*2;
    cell.buttonTwo.tag=(indexPath.row*2)+1;
    
    cell.image.image= nil;
    cell.imageTwo.image= nil;
    cell.imageUrl = result.image;
    cell.imageTwoUrl = result2.image;
    
    [cell loadThumb];
    [cell sizeToFit];
    [cell setNeedsDisplay];
    
    [cell.buttonOne addTarget:self action:@selector(showDetailView:) forControlEvents:UIControlEventTouchUpInside];
    [cell.buttonTwo addTarget:self action:@selector(showDetailView:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (void)showDetailView:(UIButton*)sender
{
    [self performSegueWithIdentifier:@"showPhotoDetail" sender:sender];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showPhotoDetail"]) {
        UIButton *btn = (UIButton*)sender;
        int tag = btn.tag;
        
        Results *result = result = aResult[tag];
        
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