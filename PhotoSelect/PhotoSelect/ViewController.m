//
//  ViewController.m
//  PhotoSelect
//
//  Created by mude on 2018/1/25.
//  Copyright © 2018年 mude. All rights reserved.
//

#import "ViewController.h"
#import "DWPhotoSelectView.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Test";
    
    DWPhotoSelectView *photoView = [[DWPhotoSelectView alloc] initWithFrame:CGRectMake(21, 21, SCREEN_WIDTH-42, SCREEN_HEIGHT-21) withItemSize:CGSizeMake((SCREEN_WIDTH-21*2-37*2)/3.0f, (SCREEN_WIDTH-21*2-37*2)/3.0f) withMinimumLineSpacing:10.f withMinimumInteritemSpacing:37.f withAllowSelect:5];
    [self.view addSubview:photoView];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
