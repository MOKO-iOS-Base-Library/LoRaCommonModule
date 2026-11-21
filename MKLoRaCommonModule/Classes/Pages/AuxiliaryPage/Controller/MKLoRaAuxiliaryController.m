//
//  MKLoRaAuxiliaryController.m
//  MKLoRaCommonModule
//
//  Created by aa on 2026/11/21.
//

#import "MKLoRaAuxiliaryController.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"

#import "MKNormalTextCell.h"

@interface MKLoRaAuxiliaryController ()<UITableViewDelegate,
UITableViewDataSource>

@property (nonatomic, strong) MKBaseTableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataList;

@property (nonatomic, copy) NSArray<MKLoRaAuxiliaryRowModel *> *rows;

@end

@implementation MKLoRaAuxiliaryController

- (instancetype)initWithRows:(NSArray<MKLoRaAuxiliaryRowModel *> *)rows {
    self = [super init];
    if (self) {
        _rows = [rows copy];
    }
    return self;
}

- (void)dealloc {
    NSLog(@"MKLoRaAuxiliaryController销毁");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self loadSectionDatas];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= self.rows.count) {
        return;
    }
    MKLoRaAuxiliaryRowModel *row = self.rows[indexPath.row];
    if (row.tapHandler) {
        row.tapHandler(self);
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MKNormalTextCell *cell = [MKNormalTextCell initCellWithTableView:tableView];
    cell.dataModel = self.dataList[indexPath.row];
    return cell;
}

#pragma mark - loadSectionDatas
- (void)loadSectionDatas {
    for (MKLoRaAuxiliaryRowModel *row in self.rows) {
        MKNormalTextCellModel *cellModel = [[MKNormalTextCellModel alloc] init];
        cellModel.showRightIcon = YES;
        cellModel.leftMsg = row.title;
        [self.dataList addObject:cellModel];
    }
    [self.tableView reloadData];
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = @"Auxiliary Operation";
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.equalTo(self.view).offset(kTopBarHeight);
        make.bottom.equalTo(self.view).offset(-kSafeAreaHeight);
    }];
}

#pragma mark - getter
- (MKBaseTableView *)tableView {
    if (!_tableView) {
        _tableView = [[MKBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = RGBCOLOR(242, 242, 242);
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSMutableArray *)dataList {
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

@end
