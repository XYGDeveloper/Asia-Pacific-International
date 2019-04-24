//
//  QuotationViewController.m
//  YJOTC
//
//  Created by l on 2018/9/14.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "QuotationViewController.h"
#import "SegmentContainer.h"

#import "YTData_listModel+Request.h"
#import "SafeCategory.h"
#import "EmptyManager.h"
@interface QuotationViewController ()<SegmentContainerDelegate>
@property (nonatomic,strong)SegmentContainer *container;
@property (nonatomic,strong)NSMutableArray *titleArray;
//@property (nonatomic,strong)XNGetLabelListApi *api;
@property (nonatomic,strong)NSArray *tagArray;
@property (nonatomic,strong)NSArray *outArray;
@property (nonatomic, assign) CGFloat myWidth;

@end

@implementation QuotationViewController

#pragma mark - Properties

- (instancetype)init {
    return [self initWithWidth:kScreenWidth];
}

- (instancetype)initWithWidth:(CGFloat)width {
    self = [super init];
    if (self) {
        self.myWidth = width;
    }
    return self;
}

- (SegmentContainer *)container {
    if (!_container) {
        _container = [[SegmentContainer alloc] initWithFrame:CGRectMake(0,0, self.myWidth,kScreenHeight)];
        _container.parentVC = self;
        _container.delegate = self;
        _container.averageSegmentation = NO;
        _container.titleFont = [PFRegularFont(13) fontWithBold];
        _container.titleNormalColor = kColorFromStr(@"#333333");
        _container.titleSelectedColor = kColorFromStr(@"#896FED");
//        _container.minIndicatorWidth = kScreenW/self.titleArray.count;
        _container.indicatorColor = kColorFromStr(@"#896FED");
        _container.indicatorOffset = 20;
        _container.containerBackgroundColor = [UIColor whiteColor];
        _container.topBar.backgroundColor = [UIColor whiteColor];
    }
    return _container;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.container];
    [self loadData];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
}

- (void)loadData{
    
    kShowHud;
    [YTData_listModel requestQuotationsWithSuccess:^(NSArray<YTData_listModel *> * _Nonnull array, YWNetworkResultModel * _Nonnull obj) {
        kHideHud;
        self.titleArray = [NSMutableArray array];
        self.outArray  = array;
        for (YTData_listModel *model in self.outArray) {
            [self.titleArray addObject:model.name];
        }
        NSLog(@"%@",self.outArray);
        [self.container reloadData];
    } failure:^(NSError * _Nonnull error) {
        kHideHud;
        [self showTips:error.localizedDescription];
        if (error.code) {
            [[EmptyManager sharedManager] showNetErrorOnView:self.view response:error.localizedDescription operationBlock:^{
                [self loadData];
            }];
        }
    }];
    
}

- (NSUInteger)numberOfItemsInSegmentContainer:(SegmentContainer *)segmentContainer {
    return self.outArray.count;
}

- (id)segmentContainer:(SegmentContainer *)segmentContainer contentForIndex:(NSUInteger)index {
    QuotationListViewController *exchange = [QuotationListViewController new];
    YTData_listModel *model = [self.outArray safeObjectAtIndex:index];
    exchange.list = model.data_list;
    exchange.didSelectCellBlock = self.didSelectCellBlock;
    return exchange;
}

- (NSString *)segmentContainer:(SegmentContainer *)segmentContainer titleForItemAtIndex:(NSUInteger)index {
    return [self.titleArray safeObjectAtIndex:index];
}

@end
