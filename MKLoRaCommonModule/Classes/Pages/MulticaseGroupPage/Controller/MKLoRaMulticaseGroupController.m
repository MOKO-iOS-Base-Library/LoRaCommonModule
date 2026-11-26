#import "MKLoRaMulticaseGroupController.h"
#import "Pages/MulticaseGroupPage/Protocol/MKLoRaMulticaseGroupPageProtocol.h"

#import "Masonry.h"
#import "MLInputDodger.h"
#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"
#import "UITableView+MKAdd.h"
#import "MKHudManager.h"
#import "MKTextSwitchCell.h"
#import "MKTextFieldCell.h"

@interface MKLoRaMulticaseGroupController ()<UITableViewDelegate,UITableViewDataSource,mk_textSwitchCellDelegate,MKTextFieldCellDelegate>
@property (nonatomic, strong)MKBaseTableView *tableView;
@property (nonatomic, strong)NSMutableArray *section0List;
@property (nonatomic, strong)NSMutableArray *section1List;
@end

@implementation MKLoRaMulticaseGroupController
- (void)dealloc { NSLog(@"MKLoRaMulticaseGroupController销毁"); }

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.view.shiftHeightAsDodgeViewForMLInputDodger = 50.0f;
    [self.view registerAsDodgeViewForMLInputDodgerWithOriginalY:self.view.frame.origin.y];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self readDataFromDevice];
}

#pragma mark - super method
- (void)rightButtonMethod { [self saveDataToDevice]; }

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath { return 44.f; }

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView { return 2; }
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) return self.section0List.count;
    if (section == 1) return (self.protocol.isOn ? self.section1List.count : 0);
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MKTextSwitchCell *cell = [MKTextSwitchCell initCellWithTableView:tableView];
        cell.dataModel = self.section0List[indexPath.row]; cell.delegate = self;
        return cell;
    }
    MKTextFieldCell *cell = [MKTextFieldCell initCellWithTableView:tableView];
    cell.dataModel = self.section1List[indexPath.row]; cell.delegate = self;
    return cell;
}

#pragma mark - mk_textSwitchCellDelegate
- (void)mk_textSwitchCellStatusChanged:(BOOL)isOn index:(NSInteger)index {
    if (index == 0) {
        self.protocol.isOn = isOn;
        ((MKTextSwitchCellModel *)self.section0List[0]).isOn = isOn;
        [self.tableView mk_reloadSection:1 withRowAnimation:UITableViewRowAnimationNone];
        return;
    }
}

#pragma mark - MKTextFieldCellDelegate
- (void)mk_deviceTextCellValueChanged:(NSInteger)index textValue:(NSString *)value {
    if (index == 0) { self.protocol.mcAddr = value; ((MKTextFieldCellModel *)self.section1List[0]).textFieldValue = value; return; }
    if (index == 1) { self.protocol.mcAppSkey = value; ((MKTextFieldCellModel *)self.section1List[1]).textFieldValue = value; return; }
    if (index == 2) { self.protocol.mcNwkSkey = value; ((MKTextFieldCellModel *)self.section1List[2]).textFieldValue = value; return; }
}

#pragma mark - interface
- (void)readDataFromDevice {
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
    [self.protocol configDataWithSucBlock:^{
        @strongify(self); [[MKHudManager share] hide];
        NSString *successMsg = @"Success";
        if ([self.protocol respondsToSelector:@selector(multicaseGroupPageSuccessMsg)]) {
            NSString *msg = [self.protocol multicaseGroupPageSuccessMsg];
            if (msg.length) {
                successMsg = msg;
            }
        }
        [self.view showCentralToast:successMsg];
    }
                               failedBlock:^(NSError * _Nonnull error) {
        @strongify(self); [[MKHudManager share] hide]; [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - loadSectionDatas
- (void)loadSectionDatas {
    [self loadSection0Datas];
    [self loadSection1Datas];
    [self.tableView reloadData];
}
- (void)loadSection0Datas {
    MKTextSwitchCellModel *cellModel = [[MKTextSwitchCellModel alloc] init];
    cellModel.index = 0; cellModel.msg = [self pageTitle];
    if ([self.protocol respondsToSelector:@selector(multicaseGroupPageSwitchMsgFont)]) {
        UIFont *msgFont = [self.protocol multicaseGroupPageSwitchMsgFont];
        if (msgFont) {
            cellModel.msgFont = msgFont;
        }
    }
    if ([self.protocol respondsToSelector:@selector(multicaseGroupPageSwitchMsgColor)]) {
        UIColor *msgColor = [self.protocol multicaseGroupPageSwitchMsgColor];
        if (msgColor) {
            cellModel.msgColor = msgColor;
        }
    }
    cellModel.isOn = self.protocol.isOn;
    [self.section0List addObject:cellModel];
}
- (void)loadSection1Datas {
    MKTextFieldCellModel *m1 = [[MKTextFieldCellModel alloc] init];
    m1.index = 0; m1.msg = @"McAddr"; m1.textFieldTextFont = MKFont(13.f);
    m1.textFieldType = mk_hexCharOnly; m1.clearButtonMode = UITextFieldViewModeAlways;
    m1.maxLength = 8; m1.textFieldValue = self.protocol.mcAddr;
    [self.section1List addObject:m1];
    
    MKTextFieldCellModel *m2 = [[MKTextFieldCellModel alloc] init];
    m2.index = 1; m2.msg = @"McAppSkey"; m2.textFieldTextFont = MKFont(13.f);
    m2.textFieldType = mk_hexCharOnly; m2.clearButtonMode = UITextFieldViewModeAlways;
    m2.maxLength = 32; m2.textFieldValue = self.protocol.mcAppSkey;
    [self.section1List addObject:m2];
    
    MKTextFieldCellModel *m3 = [[MKTextFieldCellModel alloc] init];
    m3.index = 2; m3.msg = @"McNwkSkey"; m3.textFieldTextFont = MKFont(13.f);
    m3.textFieldType = mk_hexCharOnly; m3.clearButtonMode = UITextFieldViewModeAlways;
    m3.maxLength = 32; m3.textFieldValue = self.protocol.mcNwkSkey;
    [self.section1List addObject:m3];
}

#pragma mark - UI
- (void)loadSubViews {
    UIImage *saveIcon = nil;
    if ([self.protocol respondsToSelector:@selector(multicaseGroupPageSaveIcon)]) {
        saveIcon = [self.protocol multicaseGroupPageSaveIcon];
    }
    if (!saveIcon) {
        saveIcon = LOADICON(@"MKLoRaCommonModule", @"MKLoRaMulticaseGroupController", @"mk_loraModule_loraDeviceMode_slotSaveIcon.png");
    }
    [self.rightButton setImage:saveIcon forState:UIControlStateNormal];
    self.defaultTitle = [self pageTitle];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.equalTo(self.view).offset(kTopBarHeight);
        make.bottom.equalTo(self.view).offset(-kSafeAreaHeight);
    }];
}

- (NSString *)pageTitle {
    if ([self.protocol respondsToSelector:@selector(multicaseGroupPageTitle)]) {
        NSString *title = [self.protocol multicaseGroupPageTitle];
        if (title.length) {
            return title;
        }
    }
    return @"Multicase Group";
}

#pragma mark - getter
- (MKBaseTableView *)tableView {
    if (!_tableView) { _tableView = [[MKBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain]; _tableView.delegate = self; _tableView.dataSource = self; }
    return _tableView;
}
- (NSMutableArray *)section0List { if (!_section0List) { _section0List = [NSMutableArray array]; } return _section0List; }
- (NSMutableArray *)section1List { if (!_section1List) { _section1List = [NSMutableArray array]; } return _section1List; }
@end
