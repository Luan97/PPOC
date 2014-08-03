//
//  PPOCIPadDetailViewController.m
//  PPOC
//
//  Created by Luan-Ling Chiang on 8/2/14.
//  Copyright (c) 2014 gdeformer. All rights reserved.
//

#import "PPOCIPadDetailViewController.h"
#import "PPOCImageModalViewController.h"

@interface PPOCIPadDetailViewController ()
{
    BOOL ifOS7;
    float w;
    float h;
    float fontSize;
    UIView *divider;
}
@end

@implementation PPOCIPadDetailViewController
@synthesize result = _result;
@synthesize heroImage = _heroImage;
@synthesize titleLabel = _titleLabel;
@synthesize dateLabel = _dateLabel;
@synthesize scrollView = _scrollView;
@synthesize createdLabel = _createdLabel;
@synthesize modifiedLabel = _modifiedLabel;
@synthesize mediumLabel = _mediumLabel;
@synthesize creatorLabel = _creatorLabel;
@synthesize pkLabel = _pkLabel;


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
    // Do any additional setup after loading the view.
    if([self respondsToSelector:@selector(edgesForExtendedLayout)]){
        self.edgesForExtendedLayout = UIRectEdgeNone;
        ifOS7 = true;
    }else{
        self.navigationController.navigationBar.translucent=false;
        ifOS7 = false;
    }
    
    [_heroImage setBackgroundColor:[UIColor blackColor]];
    
    w = self.view.frame.size.width;
    h = self.view.frame.size.height;
    float fsize = 15;
    float margin =  50;
    float tmargin =  10;
    float halfW = (w/2)-margin-30;
    float totalTopH = 475;
    float controllerH = [self.navigationController navigationBar].frame.size.height;
    float newY;
    float scrollY = (ifOS7)?totalTopH+controllerH+20: totalTopH+controllerH;
    float scrollH = (ifOS7)?h-totalTopH-(margin*3)+20: h-totalTopH-(margin*2);
    
    //set date label text and style
    _dateLabel.text = [NSString stringWithFormat:@"Source Created: %@",[_result.source_created substringToIndex:10]];
    _dateLabel.textColor = [UIColor colorWithRed:(0/255.f) green:(120/255.f) blue:(174/255.f) alpha:1];
    
    //set scrollView frame
    _scrollView.frame = CGRectMake((w/2), scrollY, (w/2)-margin, scrollH);
    _scrollView.delegate = self;
    
    //set title label
    if(!_titleLabel){
        _titleLabel = [[AbstractTextView alloc]initWithFrame:CGRectMake(0, 0, _scrollView.frame.size.width, 20)];
        [_scrollView addSubview:_titleLabel];
    }
    [_titleLabel setSize:fsize];
    _titleLabel.text = [NSString stringWithFormat:@"Description: \n\n%@", _result.title];
    
    //set scrollView contentSize
    newY = [self getRelativePosition:_titleLabel withMargin:tmargin];
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, _titleLabel.frame.size.height+tmargin);
    
    //set creator label
    newY = totalTopH;
    _creatorLabel= [self setupTextViewWithY:newY withCopy:[NSString stringWithFormat:@"Creator: %@", _result.creator]];
    
    //set pkLabel
    newY = [self getRelativePosition:_creatorLabel withMargin:tmargin];
    _pkLabel = [self setupTextViewWithY:newY withCopy:[NSString stringWithFormat:@"PK: %@", _result.pk]];
    
    //set createdLabel
    newY = [self getRelativePosition:_pkLabel withMargin:tmargin];
    _createdLabel = [self setupTextViewWithY:newY withCopy:[NSString stringWithFormat:@"Created Pulished Date: %@", _result.created_published_date]];
    
    //set modifiled Label
    newY = [self getRelativePosition:_createdLabel withMargin:tmargin];
    _modifiedLabel = [self setupTextViewWithY:newY withCopy:[NSString stringWithFormat:@"Modified Date: %@", _result.modified]];
    
    //set medium label
    newY = [self getRelativePosition:_modifiedLabel withMargin:tmargin];
    _mediumLabel = [self setupTextViewWithY:newY withCopy:[NSString stringWithFormat:@"Medium Brief: %@", _result.medium_brief]];
    
    //set middle divider
    divider = [[UIView alloc]initWithFrame:CGRectMake(halfW+margin+6, totalTopH+(tmargin*2), 1, h-totalTopH-(margin*3))];
    [divider setBackgroundColor:[UIColor colorWithRed:(0/255.f) green:(120/255.f) blue:(174/255.f) alpha:1]];
    divider.alpha=0.3;
    [self.view addSubview:divider];
    
    //load AsyncImageView
    [self loadImage];
}

#pragma mark - custom functions
/*
 * ------------------------------------------------------------
 *    factory function to set up AbstractTextView
 * ------------------------------------------------------------
 */
- (AbstractTextView*)setupTextViewWithY:(float)newY withCopy:(NSString*)copy{
    AbstractTextView* txtView;
    float fsize = 15;
    float margin =  50;
    float halfW = (w/2)-margin-30;

    if(!txtView){
        txtView = [[AbstractTextView alloc]initWithFrame:CGRectMake(margin, newY, halfW, 20)];
        [self.view addSubview:txtView];
    }
    [txtView setSize:fsize];
    txtView.text = copy;
    
    return txtView;
}

/*
 * ------------------------------------------------------------
 *    position calculation helper function
 * ------------------------------------------------------------
 */
- (float)getRelativePosition:(AbstractTextView*)txtView withMargin:(float)margin
{
    float totalH = txtView.frame.origin.y+ txtView.frame.size.height+margin;
    
    return totalH;
}

/*
 * ------------------------------------------------------------
 *    load image function
 * ------------------------------------------------------------
 */
- (void)loadImage
{
    
    NSURL* imgUrl = [NSURL URLWithString:[_result.image objectForKey:@"full"]];
    _heroImage.crossfadeDuration = 0;
	
    //cancel loading previous image for cell
    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:_heroImage];
    
    //load the image
    _heroImage.imageURL = imgUrl;
    [_heroImage setBackgroundColor:[UIColor blackColor]];
}


#pragma mark - touch

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    if ([touch view] == _heroImage)
    {
        [self performSegueWithIdentifier:@"modalSegue" sender:self];
    }
}

#pragma mark - segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    PPOCImageModalViewController* modalViewController = [segue destinationViewController];
    NSURL* imgUrl = [NSURL URLWithString:[_result.image objectForKey:@"full"]];
    modalViewController.imageUrl = imgUrl;
}

#pragma mark - memory related
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
