//
//  DWPhotoDetailsViewController.m
//  PhotoSelect
//
//  Created by mude on 2018/1/25.
//  Copyright © 2018年 mude. All rights reserved.
//

#import "DWPhotoDetailsViewController.h"
#import "DWPhotoSelectViewController.h"
#import "PhotoDetailCollectionViewCell.h"
#import "PhotoSelectCollectionViewFlowLayout.h"

@interface DWPhotoDetailsViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,CustomViewFlowLayoutDelegate>{
    NSMutableArray *imageArr;
    NSArray<PHAsset *> *selectImg;
    BOOL isHidden;
    
    BOOL isFirst;
    NSInteger isSecond;
}
@property (strong, nonatomic) UIView *headView;
@property (strong, nonatomic) UIButton *selectBtn;
@property (strong, nonatomic) UIView *footView;
@property (strong, nonatomic) UIView *bgView;
@property (strong, nonatomic) UILabel *number;
@property (strong, nonatomic) UILabel *completeLbl;
@property (strong, nonatomic) UIButton *completeBtn;

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation DWPhotoDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (_photoType == SelectPhotos) {
        _currentIndex = 0;
        selectImg = [_selectArr mutableCopy];
    }else{
        selectImg = [_photoArr mutableCopy];
    }
    
    BOOL isSelect = NO;
    for (int i = 0; i<_selectArr.count; i++) {
        if ([selectImg[_currentIndex].localIdentifier isEqual: _selectArr[i].localIdentifier]) {
            isSelect = YES;
        }
    }
    if (isSelect == YES) {
        [self.selectBtn setImage:[UIImage imageNamed:@"photo_check"] forState:UIControlStateNormal];
    }else{
        [self.selectBtn setImage: [UIImage imageNamed:@"photo_nocheck"] forState:UIControlStateNormal];
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideHeadAndFoot)];
    [self.bgView addGestureRecognizer:tap];
    [self prepareView];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    if (_selectArr.count == 0) {
        _number.backgroundColor = [UIColor lightGrayColor];
        _completeBtn.enabled = NO;
        _completeLbl.textColor = [UIColor lightGrayColor];
    }else{
        _number.backgroundColor = THEME_COLOR;
        _completeBtn.enabled = YES;
        _completeLbl.textColor = THEME_COLOR;
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
-(void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    //滚动到指定位置
    if (isSecond < 2) {
        [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionRight animated:NO];
        isSecond ++;
    }
}

-(void)prepareView{
    __weak DWPhotoDetailsViewController *weakSelf = self;
    
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_bgView];
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.edges.mas_equalTo(weakSelf.view).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    /*
     *   创建核心内容 UICollectionView
     */
    self.view.backgroundColor = [UIColor blackColor];
    
    PhotoSelectCollectionViewFlowLayout *flowLayout = [[PhotoSelectCollectionViewFlowLayout alloc] init];
    flowLayout.delegate = self;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.pagingEnabled = YES;
    
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    [_collectionView registerClass:[PhotoDetailCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([PhotoDetailCollectionViewCell class])];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [_bgView addSubview:_collectionView];
    
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(_bgView).with.insets(UIEdgeInsetsMake(0, 0, 50, 0));
    }];
    
    
    _headView = [[UIView alloc] init];
    _headView.backgroundColor = [UIColor clearColor];
    [_bgView addSubview:_headView];
    [_headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.view);
        make.left.mas_equalTo(weakSelf.view);
        make.right.mas_equalTo(weakSelf.view);
        make.height.mas_equalTo(64.f);
    }];
    
    UIView *headBg = [[UIView alloc] init];
    headBg.backgroundColor = [UIColor blackColor];
    headBg.alpha = 0.7f;
    [_headView addSubview:headBg];
    [headBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(weakSelf.headView).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    _selectBtn = [[UIButton alloc] init];
    [_headView addSubview:_selectBtn];
    [_selectBtn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.view).offset(9.f);
        make.right.mas_equalTo(weakSelf.view);
        make.height.mas_equalTo(55.f);
        make.width.mas_equalTo(55.f);
    }];
    
    UIButton *backBtn = [[UIButton alloc] init];
    [backBtn setImage:[UIImage imageNamed:@"arrow_white_left"] forState:UIControlStateNormal];
    [_headView addSubview:backBtn];
    [backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.view).offset(9.f);
        make.left.mas_equalTo(weakSelf.view);
        make.height.mas_equalTo(55.f);
        make.width.mas_equalTo(34.f);
    }];
    
    _footView = [[UIView alloc] init];
    _footView.backgroundColor = [UIColor whiteColor];
    [_bgView addSubview:_footView];
    [_footView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.collectionView.mas_bottom);
        make.left.mas_equalTo(weakSelf.view);
        make.right.mas_equalTo(weakSelf.view);
        make.bottom.mas_equalTo(weakSelf.view);
    }];
    
    UIView *comV = [[UIView alloc] init];
    comV.backgroundColor = [UIColor clearColor];
    [_footView addSubview:comV];
    [comV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.footView);
        make.right.mas_equalTo(weakSelf.footView);
        make.bottom.mas_equalTo(weakSelf.footView);
        make.width.mas_equalTo(75.f);
    }];
    
    _completeLbl = [[UILabel alloc] init];
    _completeLbl.text = @"完成";
    _completeLbl.font = [UIFont systemFontOfSize:16.f];
    [_completeLbl setTextColor:THEME_COLOR];
    [comV addSubview:_completeLbl];
    [_completeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(comV).offset(-8.f);
        make.centerY.mas_equalTo(comV.mas_centerY);
    }];
    
    _number = [[UILabel alloc] init];
    [comV addSubview:_number];
    _number.text = @"0";
    _number.textAlignment = NSTextAlignmentCenter;
    _number.font = [UIFont systemFontOfSize:12.f];
    [_number setBackgroundColor:THEME_COLOR];
    [_number setTextColor:[UIColor whiteColor]];
    [_number mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(18.f, 18.f));
        make.right.mas_equalTo(weakSelf.completeLbl.mas_left).offset(-7.f);
        make.centerY.mas_equalTo(comV.mas_centerY);
    }];
    _number.layer.cornerRadius = 9.f;
    _number.layer.masksToBounds = YES;
    _number.text = [NSString stringWithFormat:@"%lu",(unsigned long)_selectArr.count];
    
    _completeBtn = [[UIButton alloc] init];
    _completeBtn.backgroundColor = [UIColor clearColor];
    [comV addSubview:_completeBtn];
    [_completeBtn addTarget:self action:@selector(completeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_completeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(comV).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

-(void)hideHeadAndFoot{
    if (isHidden == NO) {
        isHidden = YES;
        self.headView.hidden = YES;
        self.footView.hidden = YES;
    }else{
        isHidden = NO;
        self.headView.hidden = NO;
        self.footView.hidden = NO;
    }
}
- (void)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)completeBtnClick:(id)sender {
    for (UIViewController *controller in self.navigationController.viewControllers) {
//        if ([controller isKindOfClass:[TroubleDetailViewController class]]) {
//            TroubleDetailViewController *revise =(TroubleDetailViewController *)controller;
//            revise.photoArr = [_selectArr mutableCopy];
//            [self.navigationController popToViewController:revise animated:YES];
//        }
    }
}


- (void)selectBtnClick:(id)sender {
    
    BOOL isSelect = NO;
    int number = 0;
    for (int i = 0; i<_selectArr.count; i++) {
        if ([selectImg[_currentIndex].localIdentifier isEqual: _selectArr[i].localIdentifier]) {
            isSelect = YES;
            number = i;
            break;
        }
    }
    if (isSelect == YES) {
        [self.selectBtn setImage: [UIImage imageNamed:@"photo_check"] forState:UIControlStateNormal];
        [_selectArr removeObjectAtIndex:number];
    }else{
        if (_selectArr.count >= ((_allowSelect == 0)?_maximumImg:_allowSelect)) {
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"最多上传%ld张照片",(long)_maximumImg] preferredStyle:UIAlertControllerStyleAlert];
            [alertVC setDismissInterval:1.5f];
            [self presentViewController:alertVC animated:YES completion:nil];
        }else{
            [self.selectBtn setImage: [UIImage imageNamed:@"photo_nocheck"] forState:UIControlStateNormal];
            [_selectArr addObject:selectImg[_currentIndex]];
        }
    }
    
    if (_selectArr.count == 0) {
        _number.backgroundColor = [UIColor lightGrayColor];
        _completeBtn.enabled = NO;
        _completeLbl.textColor = [UIColor lightGrayColor];
    }else{
        _number.backgroundColor = THEME_COLOR;
        _completeBtn.enabled = YES;
        _completeLbl.textColor = THEME_COLOR;
    }
    
    self.number.text = [NSString stringWithFormat:@"%lu",(unsigned long)_selectArr.count];
}

#pragma mark --- UICollectionviewDelegate or dataSource
-(NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return selectImg.count;
}

-(UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoDetailCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([PhotoDetailCollectionViewCell class]) forIndexPath:indexPath];
    
    if(_photoArr.count != 0){
        [cell loadPHAssetItemForPics:selectImg[indexPath.row]];
    }else{
        [cell loadPHAssetItemForPics:selectImg[indexPath.row]];//为了防止查看选中图片时第一张图片改变
        [self viewDidLayoutSubviews];
    }
    
    cell.handleSingleBlock = ^{
        [self hideHeadAndFoot];
    };
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[PhotoDetailCollectionViewCell class]]) {
        [(PhotoDetailCollectionViewCell *)cell recoverSubview];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[PhotoDetailCollectionViewCell class]]) {
        [(PhotoDetailCollectionViewCell *)cell recoverSubview];
    }
}
#pragma mark - 实现CustomViewFlowLayoutDelegate
- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout cellCenteredAtIndexPath:(NSIndexPath *)indexPath page:(int)page{
    
    if(isSecond >= 2){
        if (page < selectImg.count) {
            _currentIndex = page;
            BOOL isSelect = NO;
            for (int i = 0; i<_selectArr.count; i++) {
                if ([selectImg[_currentIndex].localIdentifier isEqual: _selectArr[i].localIdentifier]) {
                    isSelect = YES;
                    break;
                }
            }
            if (isSelect == YES) {
                [self.selectBtn setImage: [UIImage imageNamed:@"photo_check"] forState:UIControlStateNormal];
            }else{
                [self.selectBtn setImage: [UIImage imageNamed:@"photo_nocheck"] forState:UIControlStateNormal];
            }
        }
    }
    
}

@end
