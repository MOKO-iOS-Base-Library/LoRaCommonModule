#import "MKLoRaOtherTypeContentController.h"
#import "Pages/PayloadContentSelections/OtherTypeContentPage/Protocol/MKLoRaOtherTypeContentPageProtocol.h"
#import "Views/OtherAddOptionsCell/MKLoRaOtherAddOptionsCell.h"
#import "Views/OtherTypeContentCell/MKLoRaOtherTypeContentCell.h"

#import "Masonry.h"
#import "MLInputDodger.h"
#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"
#import "UITableView+MKAdd.h"
#import "MKTableSectionLineHeader.h"
#import "MKHudManager.h"

@interface MKLoRaOtherTypeContentController ()<UITableViewDelegate,UITableViewDataSource,MKLoRaOtherAddOptionsCellDelegate,MKLoRaOtherTypeContentCellDelegate>
@property (nonatomic, strong)MKBaseTableView *tableView;
@property (nonatomic, strong)NSMutableArray *section0List;
@property (nonatomic, strong)NSMutableArray *section1List;
@property (nonatomic, strong)NSMutableArray *headerList;
@end

@implementation MKLoRaOtherTypeContentController
- (void)dealloc { NSLog(@"MKLoRaOtherTypeContentController销毁"); }

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.view.shiftHeightAsDodgeViewForMLInputDodger = 50.0f;
    [self.view registerAsDodgeViewForMLInputDodgerWithOriginalY:self.view.frame.origin.y];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self readDatasFromDevice];
}

#pragma mark - super method
- (void)rightButtonMethod { [self saveDataToDevice]; }

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return (section == 1) ? 0.f : 10.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath { return 44.f; }
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MKTableSectionLineHeader *headerView = [MKTableSectionLineHeader initHeaderViewWithTableView:tableView];
    headerView.headerModel = self.headerList[section];
    return headerView;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView { return self.headerList.count; }
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) return self.section0List.count;
    if (section == 1) return self.section1List.count;
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MKLoRaOtherAddOptionsCell *cell = [MKLoRaOtherAddOptionsCell initCellWithTableView:tableView];
        cell.dataModel = self.section0List[indexPath.row]; cell.delegate = self;
        return cell;
    }
    MKLoRaOtherTypeContentCell *cell = [MKLoRaOtherTypeContentCell initCellWithTableView:tableView];
    cell.dataModel = self.section1List[indexPath.row]; cell.delegate = self;
    return cell;
}

#pragma mark - MKLoRaOtherAddOptionsCellDelegate
- (void)mk_loraModule_otherAddOptionsCellAddPressed:(NSInteger)index {
    if (self.section1List.count >= 10) {
        [self.view showCentralToast:@"You can set up to 10 data blocks!"];
        return;
    }
    MKLoRaOtherTypeContentCellModel *cellModel = [[MKLoRaOtherTypeContentCellModel alloc] init];
    cellModel.blockNumber = 0;
    cellModel.blockIndex = self.section1List.count;
    cellModel.msg = [NSString stringWithFormat:@"Data block %ld",(long)(self.section1List.count + 1)];
    cellModel.unitMsg = @"Byte";
    [self.section1List addObject:cellModel];
    [self.tableView mk_reloadSection:1 withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - MKLoRaOtherTypeContentCellDelegate
- (void)mk_loraModule_otherCellDeletedWithNumber:(NSInteger)blockNumber blockIndex:(NSInteger)blockIndex {
    if (blockNumber != 0) return;
    if (self.section1List.count == 0 || blockIndex >= self.section1List.count) return;
    [self.section1List removeObjectAtIndex:blockIndex];
    for (NSInteger i = 0; i < self.section1List.count; i ++) {
        MKLoRaOtherTypeContentCellModel *cellModel = self.section1List[i];
        cellModel.blockIndex = i;
        cellModel.msg = [NSString stringWithFormat:@"Data block %ld",(long)(i + 1)];
    }
    [self.tableView mk_reloadSection:1 withRowAnimation:UITableViewRowAnimationNone];
}
- (void)mk_loraModule_otherCellDataTypeChanged:(NSString *)dataType blockNumber:(NSInteger)blockNumber blockIndex:(NSInteger)blockIndex {
    if (blockNumber != 0) return;
    if (self.section1List.count == 0 || blockIndex >= self.section1List.count) return;
    ((MKLoRaOtherTypeContentCellModel *)self.section1List[blockIndex]).dataType = dataType;
}
- (void)mk_loraModule_otherCellStartIndexChanged:(NSString *)startIndex blockNumber:(NSInteger)blockNumber blockIndex:(NSInteger)blockIndex {
    if (blockNumber != 0) return;
    if (self.section1List.count == 0 || blockIndex >= self.section1List.count) return;
    ((MKLoRaOtherTypeContentCellModel *)self.section1List[blockIndex]).startIndex = startIndex;
}
- (void)mk_loraModule_otherCellEndIndexChanged:(NSString *)endIndex blockNumber:(NSInteger)blockNumber blockIndex:(NSInteger)blockIndex {
    if (blockNumber != 0) return;
    if (self.section1List.count == 0 || blockIndex >= self.section1List.count) return;
    ((MKLoRaOtherTypeContentCellModel *)self.section1List[blockIndex]).endIndex = endIndex;
}

#pragma mark - interface
- (void)readDatasFromDevice {
    [[MKHudManager share] showHUDWithTitle:@"Reading..." inView:self.view isPenetration:NO];
    @weakify(self);
    [self.protocol readDataWithSucBlock:^{ @strongify(self); [[MKHudManager share] hide]; [self loadSectionDatas]; }
                             failedBlock:^(NSError * _Nonnull error) {
        @strongify(self); [[MKHudManager share] hide]; [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)saveDataToDevice {
    [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
    @weakify(self);
    NSMutableArray *optionList = [NSMutableArray array];
    for (NSInteger i = 0; i < self.section1List.count; i ++) {
        MKLoRaOtherTypeContentCellModel *cellModel = self.section1List[i];
        if (!ValidStr(cellModel.startIndex) || !ValidStr(cellModel.endIndex)) {
            [[MKHudManager share] hide];
            [self.view showCentralToast:[NSString stringWithFormat:@"Data block %@ Params Error",@(i + 1)]];
            return;
        }
        NSMutableDictionary *optionDict = [NSMutableDictionary dictionary];
        [optionDict setObject:SafeStr(cellModel.dataType) forKey:@"dataType"];
        [optionDict setObject:@([cellModel.startIndex integerValue]) forKey:@"minIndex"];
        [optionDict setObject:@([cellModel.endIndex integerValue]) forKey:@"maxIndex"];
        [optionList addObject:optionDict];
    }
    [self.protocol configBlockOptionList:optionList sucBlock:^{ @strongify(self); [[MKHudManager share] hide]; [self.view showCentralToast:@"Success"]; }
                            failedBlock:^(NSError * _Nonnull error) {
        @strongify(self); [[MKHudManager share] hide]; [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - loadSectionDatas
- (void)loadSectionDatas {
    [self loadSection0Datas];
    [self loadSection1Datas];
    for (NSInteger i = 0; i < 2; i ++) {
        MKTableSectionLineHeaderModel *headerModel = [[MKTableSectionLineHeaderModel alloc] init];
        [self.headerList addObject:headerModel];
    }
    [self.tableView reloadData];
}
- (void)loadSection0Datas {
    MKLoRaOtherAddOptionsCellModel *cellModel = [[MKLoRaOtherAddOptionsCellModel alloc] init];
    cellModel.index = 0; cellModel.msg = @"Data block Options";
    [self.section0List addObject:cellModel];
}
- (void)loadSection1Datas {
    for (NSInteger i = 0; i < self.protocol.blockList.count; i ++) {
        NSDictionary *model = self.protocol.blockList[i];
        MKLoRaOtherTypeContentCellModel *cellModel = [[MKLoRaOtherTypeContentCellModel alloc] init];
        cellModel.blockNumber = 0; cellModel.blockIndex = i;
        cellModel.msg = [NSString stringWithFormat:@"Data block %ld",(long)(i + 1)];
        cellModel.dataType = SafeStr(model[@"dataType"]);
        cellModel.startIndex = [NSString stringWithFormat:@"%ld",(long)[model[@"minIndex"] integerValue]];
        cellModel.endIndex = [NSString stringWithFormat:@"%ld",(long)[model[@"maxIndex"] integerValue]];
        cellModel.unitMsg = @"Byte";
        [self.section1List addObject:cellModel];
    }
}

#pragma mark - UI
- (void)loadSubViews {
    [self.rightButton setImage:LOADICON(@"MKLoRaCommonModule", @"MKLoRaOtherTypeContentController", @"mk_loraModule_loraDeviceMode_slotSaveIcon.png") forState:UIControlStateNormal];
    self.defaultTitle = @"Other Type Content";
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.equalTo(self.view).offset(kTopBarHeight);
        make.bottom.equalTo(self.view).offset(-kSafeAreaHeight);
    }];
}

#pragma mark - getter
- (MKBaseTableView *)tableView {
    if (!_tableView) { _tableView = [[MKBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain]; _tableView.delegate = self; _tableView.dataSource = self; }
    return _tableView;
}
- (NSMutableArray *)section0List { if (!_section0List) { _section0List = [NSMutableArray array]; } return _section0List; }
- (NSMutableArray *)section1List { if (!_section1List) { _section1List = [NSMutableArray array]; } return _section1List; }
- (NSMutableArray *)headerList { if (!_headerList) { _headerList = [NSMutableArray array]; } return _headerList; }
@end
