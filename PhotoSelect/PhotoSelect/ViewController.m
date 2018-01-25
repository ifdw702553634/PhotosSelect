//
//  ViewController.m
//  PhotoSelect
//
//  Created by mude on 2018/1/25.
//  Copyright © 2018年 mude. All rights reserved.
//

#import "ViewController.h"
#import "DWAlbumViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Test";
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(10, 50, SCREEN_WIDTH-20, 55)];
    btn.backgroundColor = [UIColor lightGrayColor];
    btn.titleLabel.text = @"相册";
    [btn addTarget:self action:@selector(album) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)album{
    DWAlbumViewController *vc = [[DWAlbumViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
