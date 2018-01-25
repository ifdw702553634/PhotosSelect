//
//  DWPhotoSelectViewController.m
//  PhotoSelect
//
//  Created by mude on 2018/1/25.
//  Copyright © 2018年 mude. All rights reserved.
//

#import "DWPhotoSelectViewController.h"
#import "PhotoSelectCollectionViewCell.h"
#import "DWAlbumViewController.h"
#import "DWPhotoDetailsViewController.h"

static NSString *kPhotoSelectCollectionViewCell = @"kPhotoSelectCollectionViewCell";
@interface DWPhotoSelectViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>{
    NSUInteger isSecond;
}
@property (strong, nonatomic) UILabel *photoNum;
@property (strong, nonatomic) UICollectionView *photoCollection;
@property (strong, nonatomic) UIButton *detailBtn;
@property (strong, nonatomic) UILabel *completeLbl;
@property (strong, nonatomic) UIButton *completeBtn;

@end

@implementation DWPhotoSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _navTitle;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelClick)];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self prepareView];
    if (_selectArr.count == 0) {
        _selectArr = [[NSMutableArray alloc] init];
    }
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.photoCollection reloadData];
    self.photoNum.text = [NSString stringWithFormat:@"%lu",(unsigned long)_selectArr.count];
    if (_selectArr.count == 0) {
        _photoNum.backgroundColor = [UIColor lightGrayColor];
        _completeBtn.enabled = NO;
        _detailBtn.enabled = NO;
        _completeLbl.textColor = [UIColor lightGrayColor];
        [_detailBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }else{
        _photoNum.backgroundColor = THEME_COLOR;
        _completeBtn.enabled = YES;
        _detailBtn.enabled = YES;
        _completeLbl.textColor = THEME_COLOR;
        [_detailBtn setTitleColor:THEME_COLOR forState:UIControlStateNormal];
    }
}

-(void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    //滚动到指定位置
    if (isSecond < 2) {
        [_photoCollection scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_photoArr.count-1 inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
        isSecond ++;
    }
}

-(void)prepareView{
    __weak DWPhotoSelectViewController *weakSelf = self;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //设置collectionView滚动方向
    
    _photoCollection = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [self.view addSubview:_photoCollection];
    _photoCollection.backgroundColor = BG_COLOR;
    _photoCollection.delegate = self;
    _photoCollection.dataSource = self;
    [_photoCollection registerClass:[PhotoSelectCollectionViewCell class] forCellWithReuseIdentifier:kPhotoSelectCollectionViewCell];
    [_photoCollection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(weakSelf.view).with.insets(UIEdgeInsetsMake(0, 0, 50, 0));
    }];
    UIView *lineV = [[UIView alloc] init];
    lineV.backgroundColor = LINE_COLOR;
    [self.view addSubview:lineV];
    [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.photoCollection.mas_bottom);
        make.left.mas_equalTo(weakSelf.view);
        make.right.mas_equalTo(weakSelf.view);
        make.height.mas_equalTo(1.f);
    }];
    
    UIView *bottomV = [[UIView alloc] init];
    bottomV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomV];
    [bottomV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lineV.mas_bottom);
        make.left.mas_equalTo(weakSelf.view);
        make.right.mas_equalTo(weakSelf.view);
        make.bottom.mas_equalTo(weakSelf.view);
    }];
    
    _detailBtn = [[UIButton alloc] init];
    [_detailBtn setTitle:@"预览" forState:UIControlStateNormal];
    [bottomV addSubview:_detailBtn];
    [_detailBtn addTarget:self action:@selector(photoDetail:) forControlEvents:UIControlEventTouchUpInside];
    [_detailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bottomV);
        make.left.mas_equalTo(bottomV);
        make.bottom.mas_equalTo(bottomV);
        make.width.mas_equalTo(60.f);
    }];
    
    UIView *comV = [[UIView alloc] init];
    comV.backgroundColor = [UIColor clearColor];
    [bottomV addSubview:comV];
    [comV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bottomV);
        make.right.mas_equalTo(bottomV);
        make.bottom.mas_equalTo(bottomV);
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
    
    _photoNum = [[UILabel alloc] init];
    [comV addSubview:_photoNum];
    _photoNum.text = @"0";
    _photoNum.textAlignment = NSTextAlignmentCenter;
    _photoNum.font = [UIFont systemFontOfSize:12.f];
    [_photoNum setBackgroundColor:THEME_COLOR];
    [_photoNum setTextColor:[UIColor whiteColor]];
    [_photoNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(18.f, 18.f));
        make.right.mas_equalTo(weakSelf.completeLbl.mas_left).offset(-7.f);
        make.centerY.mas_equalTo(comV.mas_centerY);
    }];
    _photoNum.layer.cornerRadius = 9.f;
    _photoNum.layer.masksToBounds = YES;
    
    _completeBtn = [[UIButton alloc] init];
    _completeBtn.backgroundColor = [UIColor clearColor];
    [comV addSubview:_completeBtn];
    [_completeBtn addTarget:self action:@selector(sendPhoto:) forControlEvents:UIControlEventTouchUpInside];
    [_completeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(comV).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}
- (void)sendPhoto:(id)sender {
    for (UIViewController *controller in self.navigationController.viewControllers) {
//        if ([controller isKindOfClass:[TroubleDetailViewController class]]) {
//            TroubleDetailViewController *revise =(TroubleDetailViewController *)controller;
//            revise.photoArr = [_selectArr mutableCopy];
//            [self.navigationController popToViewController:revise animated:YES];
//        }
    }
}
- (void)photoDetail:(id)sender {
    DWPhotoDetailsViewController *vc = [[DWPhotoDetailsViewController alloc] init];
    vc.selectArr = _selectArr;
    vc.photoType = SelectPhotos;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)cancelClick{
    for (UIViewController *controller in self.navigationController.viewControllers) {
//        if ([controller isKindOfClass:[TroubleDetailViewController class]]) {
//            TroubleDetailViewController *revise =(TroubleDetailViewController *)controller;
//            [self.navigationController popToViewController:revise animated:YES];
//        }
    }
}
#pragma mark -- UICollectionViewDataSource

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize itemSize = CGSizeMake((SCREEN_WIDTH-15)/4.0, (SCREEN_WIDTH-15)/4.0);
    return itemSize;
}
//定义每个UICollectionView 的边距
-(UIEdgeInsets)collectionView:( UICollectionView *)collectionView layout:( UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:( NSInteger )section {
    return UIEdgeInsetsMake(3, 3, 3, 3);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return  1.f;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return  2.0f;
}

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _photoArr.count;
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoSelectCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kPhotoSelectCollectionViewCell forIndexPath:indexPath];
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    // 同步获得图片, 只会返回1张图片
    options.synchronous = NO;
    CGSize size = CGSizeMake(180, 180);
    // 从asset中获得图片
    [[PHImageManager defaultManager] requestImageForAsset:self.photoArr[indexPath.row] targetSize:size contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        BOOL downloadFinined = ![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey] && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue];
        //设置BOOL判断，确认返回高清照片
        if (downloadFinined) {
            if (result != nil) {
                cell.photo.image = result;
            }
        }
    }];
    BOOL isSelect = NO;
    for (int i = 0; i<_selectArr.count; i++) {
        if ([self.photoArr[indexPath.row].localIdentifier isEqual:_selectArr[i].localIdentifier]) {
            isSelect = YES;
            break;
        }
    }
    if (isSelect == YES) {
        [cell.selectBtn setImage: [UIImage imageNamed:@"photo_check"] forState:UIControlStateNormal];
    }else{
        [cell.selectBtn setImage: [UIImage imageNamed:@"photo_nocheck"] forState:UIControlStateNormal];
    }
    
    __block PhotoSelectCollectionViewCell *weakCell = cell;
    cell.selectBlock = ^{
        BOOL isSelect = NO;
        int number = 0;
        for (int i = 0; i<_selectArr.count; i++) {
            if ([self.photoArr[indexPath.row].localIdentifier isEqual: _selectArr[i].localIdentifier]) {
                isSelect = YES;
                number = i;
                break;
            }
        }
        if (isSelect == YES) {
            [weakCell.selectBtn setImage: [UIImage imageNamed:@"photo_nocheck"] forState:UIControlStateNormal];
            [_selectArr removeObjectAtIndex:number];
        }else{
            if (_selectArr.count >= ((_allowSelect == 0)?_maximumImg:_allowSelect)) {
                UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"最多上传%ld张照片",(long)_maximumImg] preferredStyle:UIAlertControllerStyleAlert];
                [alertVC setDismissInterval:1.5f];
                [self presentViewController:alertVC animated:YES completion:nil];
            }else{
                [weakCell.selectBtn setImage: [UIImage imageNamed:@"photo_check"] forState:UIControlStateNormal];
                [_selectArr addObject:self.photoArr[indexPath.row]];
            }
        }
        
        if (_selectArr.count == 0) {
            _photoNum.backgroundColor = [UIColor lightGrayColor];
            _completeBtn.enabled = NO;
            _detailBtn.enabled = NO;
            _completeLbl.textColor = [UIColor lightGrayColor];
            [_detailBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        }else{
            _photoNum.backgroundColor = THEME_COLOR;
            _completeBtn.enabled = YES;
            _detailBtn.enabled = YES;
            _completeLbl.textColor = THEME_COLOR;
            [_detailBtn setTitleColor:THEME_COLOR forState:UIControlStateNormal];
        }
        
        self.photoNum.text = [NSString stringWithFormat:@"%lu",(unsigned long)_selectArr.count];
        DBG(@"%ld",(long)indexPath.row);
    };
    
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    DWPhotoDetailsViewController *vc = [[DWPhotoDetailsViewController alloc] init];
    vc.selectArr = _selectArr;
    vc.photoArr = [_photoArr mutableCopy];
    vc.currentIndex = indexPath.row;
    vc.photoType = AllPhotos;
    vc.maximumImg = _maximumImg;
    vc.allowSelect = _allowSelect;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
