//
//  PPOCDetailViewController.m
//  PPOC
//
//  Created by Luan-Ling Chiang on 7/24/14.
//  Copyright (c) 2014 gdeformer. All rights reserved.
//

#import "PPOCDetailViewController.h"
#import "PPOCImageModalViewController.h"

@interface PPOCDetailViewController()
{
    BOOL ifOS7;
    float w;
    float h;
    float fontSize;
}

@end

@implementation PPOCDetailViewController
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
    float heroY = _heroImage.frame.origin.y;
    float heroH = _heroImage.frame.size.height;
    float controllerH = [self.navigationController navigationBar].frame.size.height;
    float margin =  16;
    float totalTopH = heroY+heroH+controllerH+margin;
    float newY;
    
    NSLog(@"Results %@", _result.title);
    
    _dateLabel.text = [NSString stringWithFormat:@"Source Created: %@",[_result.source_created substringToIndex:10]];
    _dateLabel.textColor = [UIColor colorWithRed:(0/255.f) green:(120/255.f) blue:(174/255.f) alpha:1];
    _scrollView.frame = CGRectMake(0, (ifOS7)?totalTopH+margin: totalTopH, w, h-totalTopH-margin);
    _scrollView.delegate = self;
    
    if(!_creatorLabel){
        _creatorLabel = [[AbstractTextView alloc]initWithFrame:CGRectMake(margin, 0, w-margin*2, 20)];
        [_scrollView addSubview:_creatorLabel];
    }
    NSLog(@"_result.creator %@", _result.creator);
    _creatorLabel.text = [NSString stringWithFormat:@"Creator: %@", _result.creator];
    
    if(!_pkLabel){
        newY = [self getRelativePosition:_creatorLabel withMargin:margin];
        _pkLabel = [[AbstractTextView alloc]initWithFrame:CGRectMake(margin, newY, w-margin*2, 20)];
        [_scrollView addSubview:_pkLabel];
    }
    
    _pkLabel.text = [NSString stringWithFormat:@"PK: %@", _result.pk];
    
    if(!_createdLabel){
        newY = [self getRelativePosition:_pkLabel withMargin:margin];
        _createdLabel = [[AbstractTextView alloc]initWithFrame:CGRectMake(margin, newY, w-margin*2, 20)];
        [_scrollView addSubview:_createdLabel];
    }
    
    _createdLabel.text = [NSString stringWithFormat:@"Created Pulished Date: %@", _result.created_published_date];
    
    if(!_modifiedLabel){
        newY = [self getRelativePosition:_createdLabel withMargin:margin];
        _modifiedLabel = [[AbstractTextView alloc]initWithFrame:CGRectMake(margin, newY, w-margin*2, 20)];
        [_scrollView addSubview:_modifiedLabel];
    }
    _modifiedLabel.text = [NSString stringWithFormat:@"Modified Date: %@", _result.modified];
    
    if(!_mediumLabel){
        newY = [self getRelativePosition:_modifiedLabel withMargin:margin];
        _mediumLabel = [[AbstractTextView alloc]initWithFrame:CGRectMake(margin, newY, w-margin*2, 20)];
        [_scrollView addSubview:_mediumLabel];
    }
    _mediumLabel.text = [NSString stringWithFormat:@"Medium Brief: %@", _result.medium_brief];
    
    if(!_titleLabel){
        newY = [self getRelativePosition:_mediumLabel withMargin:margin];
        _titleLabel = [[AbstractTextView alloc]initWithFrame:CGRectMake(margin, newY, w-margin*2, 20)];
        [_scrollView addSubview:_titleLabel];
    }
    
    [_titleLabel setText:_result.title];
    
    newY = [self getRelativePosition:_titleLabel withMargin:margin];
    _scrollView.contentSize = CGSizeMake(w, newY);
    
    [self loadImage];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    if ([touch view] == _heroImage)
    {
        //add your code for image touch here
        NSLog(@"touch on image");
        //[self getImageScrollView];
        [self performSegueWithIdentifier:@"modalSegue" sender:self];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    PPOCImageModalViewController* modalViewController = [segue destinationViewController];
    NSURL* imgUrl = [NSURL URLWithString:[_result.image objectForKey:@"full"]];
    modalViewController.imageUrl = imgUrl;
}

- (float)getRelativePosition:(AbstractTextView*)txtView withMargin:(float)margin
{
    float totalH = txtView.frame.origin.y+ txtView.frame.size.height+margin;
    
    return totalH;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
@end
