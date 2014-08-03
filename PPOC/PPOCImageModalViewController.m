//
//  PPOCImageModalViewController.m
//  PPOC
//
//  Created by Luan-Ling Chiang on 7/27/14.
//  Copyright (c) 2014 gdeformer. All rights reserved.
//

#import "PPOCImageModalViewController.h"

@interface PPOCImageModalViewController ()
{
    float w;
    float h;
    float imgY;
    float imgW;
    float imgH;
}
@end

@implementation PPOCImageModalViewController
@synthesize closeBtn = _closeBtn;
@synthesize imageZoomScroll = _imageZoomScroll;
@synthesize imageZoom = _imageZoom;
@synthesize imageUrl = _imageUrl;

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
    w = self.view.frame.size.width;
    h = self.view.frame.size.height;
    
    UIColor *blue = [UIColor colorWithRed:(0/255.f) green:(120/255.f) blue:(147/255.f) alpha:1.0];
    
    _closeBtn.layer.shadowOpacity = 0.7;
    _closeBtn.layer.shadowColor = [blue CGColor];
    _closeBtn.layer.shadowOffset = CGSizeMake(0, 0);
    _closeBtn.layer.shadowRadius = 3;
    _closeBtn.layer.masksToBounds = NO;
    
    _imageZoomScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, w, h)];
    [_imageZoomScroll setBackgroundColor:[UIColor blackColor]];
    _imageZoom = [[AsyncImageView alloc]init];
    [_imageZoomScroll addSubview:_imageZoom];
    
    [[AsyncImageLoader sharedLoader] loadImageWithURL:_imageUrl target:self success:@selector(onImageLoaded) failure:@selector(thumbImageLoadError)];
    
    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:_imageZoom];
    _imageZoom.imageURL = _imageUrl;
    
    [self.view insertSubview:_imageZoomScroll belowSubview:_closeBtn];
}

-(void)onImageLoaded
{
    NSLog(@"image loaded");
    [self getImageScrollView];
}

-(void)thumbImageLoadError
{
    
}

- (void)getImageScrollView
{
    if(_imageZoomScroll){
        float ratio;
        
        self.navigationController.navigationBarHidden = YES;
        
        imgW = _imageZoom.image.size.width;
        imgH = _imageZoom.image.size.height;
        ratio = w/imgW;
        
        if(imgW<w){
            imgW = imgW*ratio;
            imgH = imgH*ratio;
        }
        
        imgY = (h-(imgH))/2;
        
        _imageZoom.frame = CGRectMake(0, imgY, imgW,  imgH);
        
        CGSize imageFrame = CGSizeMake(imgW, imgH);
        _imageZoomScroll.delegate = self;
        _imageZoomScroll.contentSize = imageFrame;
        _imageZoomScroll.maximumZoomScale = 4;
        
        _imageZoomScroll.minimumZoomScale = 1;
        [_imageZoomScroll setZoomScale:1];
    }
}

-(UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageZoom;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    
    float scale = [scrollView zoomScale];
    float newY;
    float updateW =_imageZoom.frame.size.width;
    float updateH =_imageZoom.frame.size.height;
    newY = imgY*((3.8-scale)*.15);
    if(scale<1.2){
        newY = imgY;
    }
    _imageZoom.frame = CGRectMake(0, newY, updateW,  updateH);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)unwindToDetailView:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}
@end
