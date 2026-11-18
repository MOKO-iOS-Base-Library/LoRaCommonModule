//
//  MKLoRaPayloadContentController.m
//  MKLoRaCommonModule
//
//  Created by aa on 2026/11/18.
//

#import "MKLoRaPayloadContentController.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"

#import "MKSettingTextCell.h"
#import "MKTableSectionLineHeader.h"

@interface MKLoRaPayloadContentController ()<UITableViewDelegate,
UITableViewDataSource>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *dataList;

@property (nonatomic, strong)NSMutableArray *headerList;

@end

@implementation MKLoRaPayloadContentController

- (void)dealloc {
    NSLog(@"MKLoRaPayloadContentController销毁");
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MKTableSectionLineHeader *header = [MKTableSectionLineHeader initHeaderViewWithTableView:tableView];
    header.headerModel = self.headerList[section];
    return header;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section != 0) {
        return;
    }
    UIViewController *vc = nil;
    switch (indexPath.row) {
        case 0:
            vc = [self.protocol beaconContentViewController];
            break;
        case 1:
            vc = [self.protocol uidContentViewController];
            break;
        case 2:
            vc = [self.protocol urlContentViewController];
            break;
        case 3:
            vc = [self.protocol tlmContentViewController];
            break;
        case 4:
            vc = [self.protocol bxpBeaconContentViewController];
            break;
        case 5:
            vc = [self.protocol bxpInfoContentViewController];
            break;
        case 6:
            vc = [self.protocol bxpAccContentViewController];
            break;
        case 7:
            vc = [self.protocol bxpTHContentViewController];
            break;
        case 8:
            vc = [self.protocol bxpButtonContentViewController];
            break;
        case 9:
            vc = [self.protocol bxpTagContentViewController];
            break;
        case 10:
            vc = [self.protocol tofContentViewController];
            break;
        case 11:
            vc = [self.protocol pirContentViewController];
            break;
        case 12:
            vc = [self.protocol nanoBeaconContentViewController];
            break;
        case 13:
            vc = [self.protocol otherContentViewController];
            break;
        default:
            break;
    }
    if (vc) {
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.headerList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MKSettingTextCell *cell = [MKSettingTextCell initCellWithTableView:tableView];
    cell.dataModel = self.dataList[indexPath.row];
    return cell;
}

#pragma mark - loadSections
- (void)loadSectionDatas {
    MKSettingTextCellModel *cellModel1 = [[MKSettingTextCellModel alloc] init];
    cellModel1.leftMsg = @"iBeacon Content";
    [self.dataList addObject:cellModel1];
    
    MKSettingTextCellModel *cellModel2 = [[MKSettingTextCellModel alloc] init];
    cellModel2.leftMsg = @"Eddystone-UID Content";
    [self.dataList addObject:cellModel2];
    
    MKSettingTextCellModel *cellModel3 = [[MKSettingTextCellModel alloc] init];
    cellModel3.leftMsg = @"Eddystone-URL Content";
    [self.dataList addObject:cellModel3];
    
    MKSettingTextCellModel *cellModel4 = [[MKSettingTextCellModel alloc] init];
    cellModel4.leftMsg = @"Eddystone-TLM Content";
    [self.dataList addObject:cellModel4];
    
    MKSettingTextCellModel *cellModel5 = [[MKSettingTextCellModel alloc] init];
    cellModel5.leftMsg = @"BXP-iBeacon Content";
    [self.dataList addObject:cellModel5];
    
    MKSettingTextCellModel *cellModel6 = [[MKSettingTextCellModel alloc] init];
    cellModel6.leftMsg = @"BXP-Device Info Content";
    [self.dataList addObject:cellModel6];
    
    MKSettingTextCellModel *cellModel7 = [[MKSettingTextCellModel alloc] init];
    cellModel7.leftMsg = @"BXP-ACC Content";
    [self.dataList addObject:cellModel7];
    
    MKSettingTextCellModel *cellModel8 = [[MKSettingTextCellModel alloc] init];
    cellModel8.leftMsg = @"BXP-T&H Content";
    [self.dataList addObject:cellModel8];
    
    MKSettingTextCellModel *cellModel9 = [[MKSettingTextCellModel alloc] init];
    cellModel9.leftMsg = @"BXP-Button Content";
    [self.dataList addObject:cellModel9];
    
    MKSettingTextCellModel *cellModel10 = [[MKSettingTextCellModel alloc] init];
    cellModel10.leftMsg = @"BXP-T&S Content";
    [self.dataList addObject:cellModel10];
    
    MKSettingTextCellModel *cellModel11 = [[MKSettingTextCellModel alloc] init];
    cellModel11.leftMsg = @"BXP-TOF Content";
    [self.dataList addObject:cellModel11];
    
    MKSettingTextCellModel *cellModel12 = [[MKSettingTextCellModel alloc] init];
    cellModel12.leftMsg = @"BXP-PIR Content";
    [self.dataList addObject:cellModel12];
    
    MKSettingTextCellModel *cellModel13 = [[MKSettingTextCellModel alloc] init];
    cellModel13.leftMsg = @"NanoBeacon Info";
    [self.dataList addObject:cellModel13];
    
    MKSettingTextCellModel *cellModel14 = [[MKSettingTextCellModel alloc] init];
    cellModel14.leftMsg = @"Other Type Content";
    [self.dataList addObject:cellModel14];
    
    for (NSInteger i = 0; i < 1; i ++) {
        MKTableSectionLineHeaderModel *headerModel = [[MKTableSectionLineHeaderModel alloc] init];
        [self.headerList addObject:headerModel];
    }
    
    [self.tableView reloadData];
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = @"Payload Content Selection";
    [self setNavTitleFont:MKFont(15.f)];
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

- (NSMutableArray *)headerList {
    if (!_headerList) {
        _headerList = [NSMutableArray array];
    }
    return _headerList;
}

@end
