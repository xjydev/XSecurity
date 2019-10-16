//
//  SelectImageViewController.m
//  XSecurity
//
//  Created by XiaoDev on 2019/10/12.
//  Copyright © 2019 XiaoDev. All rights reserved.
//

#import "SelectImageViewController.h"
#import "UIColor+Hex.h"
#import "XTools.h"
@interface SelectImageViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (strong, nonatomic) UICollectionView *mainCollectionView;

@end

@implementation SelectImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.mainCollectionView];
}
- (UICollectionView *)mainCollectionView {
    if (!_mainCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing = 18;
        layout.minimumInteritemSpacing = 10;
        layout.itemSize = CGSizeMake(40,40);
        layout.sectionInset = UIEdgeInsetsMake(18, 18, 18, 18);
        _mainCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0,250,250) collectionViewLayout:layout];
        _mainCollectionView.delegate = self;
        _mainCollectionView.dataSource = self;
        _mainCollectionView.backgroundColor = kGray1Color;
        [_mainCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"selectImageCellid"];
    }
    return _mainCollectionView;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 16;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"selectImageCellid" forIndexPath:indexPath];
    UIImageView *imageV = [cell.contentView viewWithTag:301];
    if (!imageV) {
        imageV = [[UIImageView alloc]initWithFrame:cell.contentView.bounds];
        imageV.tag = 301;
        [cell.contentView addSubview:imageV];
    }
    NSString *imageS = [NSString stringWithFormat:@"ximage_%@",@(indexPath.row)];
    [imageV setImage:[UIImage imageNamed:imageS]];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectedBack) {
        self.selectedBack(indexPath.row);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    return UIEdgeInsetsMake(5, 5, 5, 5);
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
