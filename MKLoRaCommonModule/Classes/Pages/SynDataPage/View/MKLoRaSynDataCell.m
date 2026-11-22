//
//  MKLoRaSynDataCell.m
//  MKLoRaCommonModule
//
//  Created by Trae on 2026/11/22.
//

#import "MKLoRaSynDataCell.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "NSString+MKAdd.h"

static NSString *const MKLoRaSynDataCellIdenty = @"MKLoRaSynDataCellIdenty";

static CGFloat const msgLabelFontSize = 14.f;

@interface MKLoRaSynDataCell ()

@property (nonatomic, strong)UILabel *timeLabel;

@property (nonatomic, strong)UILabel *macAddressLabel;

@property (nonatomic, strong)UILabel *rssiLabel;

@property (nonatomic, strong)UILabel *deviceTypeLabel;

@property (nonatomic, strong)UILabel *rawDataLabel;

@property (nonatomic, strong)UIStackView *stackView;

@property (nonatomic, strong)UIView *lineView;

@property (nonatomic, strong)NSArray *timeZoneList;

@end

@implementation MKLoRaSynDataCell

+ (MKLoRaSynDataCell *)initCellWithTableView:(UITableView *)tableView {
    MKLoRaSynDataCell *cell = [tableView dequeueReusableCellWithIdentifier:MKLoRaSynDataCellIdenty];
    if (!cell) {
        cell = [[MKLoRaSynDataCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MKLoRaSynDataCellIdenty];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = COLOR_WHITE_MACROS;
        [self.contentView addSubview:self.stackView];
        [self.contentView addSubview:self.lineView];
    }
    return self;
}

#pragma mark - super method
- (void)layoutSubviews {
    [super layoutSubviews];
    [self.stackView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(-15.f);
        make.top.mas_equalTo(15.f);
        make.bottom.mas_equalTo(-15.f);
    }];
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(-15.f);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(CUTTING_LINE_HEIGHT);
    }];
}

#pragma mark -
+ (CGFloat)fetchCellHeight:(NSDictionary *)dataDic
                   showMac:(BOOL)showMac
                  showRSSI:(BOOL)showRSSI
            showDeviceType:(BOOL)showDeviceType {
    UIFont *font = MKFont(msgLabelFontSize);
    CGFloat height = 30.f;
    NSString *timeString = [@"Time: " stringByAppendingString:[self timeStringWithData:dataDic]];
    height += [self labelHeight:timeString font:font];
    if (showMac) {
        height += 5.f + [self labelHeight:[self macStringWithData:dataDic title:@"MAC Address:"] font:font];
    }
    if (showRSSI) {
        height += 5.f + [self labelHeight:[self rssiStringWithData:dataDic] font:font];
    }
    if (showDeviceType) {
        height += 5.f + [self labelHeight:[self deviceTypeStringWithData:dataDic] font:font];
    }
    NSString *rawData = @"Raw Data: N/A";
    if (ValidStr(dataDic[@"rawData"])) {
        rawData = [@"Raw Data: " stringByAppendingString:dataDic[@"rawData"]];
    }
    height += 5.f + [self labelHeight:rawData font:font];
    return height;
}

+ (NSString *)timeStringWithData:(NSDictionary *)dataDic {
    if (ValidStr(dataDic[@"date"])) {
        return dataDic[@"date"];
    }
    NSDictionary *dateDic = dataDic[@"dateDic"];
    if (ValidDict(dateDic)) {
        return [NSString stringWithFormat:@"%@/%@/%@ %@:%@:%@",
                dateDic[@"year"],dateDic[@"month"],dateDic[@"day"],
                dateDic[@"hour"],dateDic[@"minute"],dateDic[@"second"]];
    }
    if (ValidStr(dataDic[@"timestamp"])) {
        NSString *timeZone = [self timeZoneString:[dataDic[@"timezone"] integerValue]];
        return [NSString stringWithFormat:@"%@ %@",dataDic[@"timestamp"],timeZone];
    }
    return @"N/A";
}

#pragma mark - private method
+ (CGFloat)labelHeight:(NSString *)text font:(UIFont *)font {
    CGSize size = [NSString sizeWithText:text
                                andFont:font
                             andMaxSize:CGSizeMake(kViewWidth - 30.f, MAXFLOAT)];
    return MAX(size.height, font.lineHeight);
}

+ (NSString *)macStringWithData:(NSDictionary *)dataDic title:(NSString *)title {
    if (ValidStr(dataDic[@"macAddress"])) {
        return [title stringByAppendingString:dataDic[@"macAddress"]];
    }
    return [title stringByAppendingString:@"N/A"];
}

+ (NSString *)rssiStringWithData:(NSDictionary *)dataDic {
    if (ValidStr(dataDic[@"rssi"]) || ValidNum(dataDic[@"rssi"])) {
        return [NSString stringWithFormat:@"RSSI: %@dBm",dataDic[@"rssi"]];
    }
    return @"RSSI: N/A";
}

+ (NSString *)deviceTypeStringWithData:(NSDictionary *)dataDic {
    if (ValidStr(dataDic[@"deviceType"])) {
        return [@"Device Type: " stringByAppendingString:dataDic[@"deviceType"]];
    }
    return @"Device Type: N/A";
}

+ (NSString *)timeZoneString:(NSInteger)timezoneIndex {
    static NSArray *timeZoneList = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        timeZoneList = @[@"UTC-12:00",@"UTC-11:30",@"UTC-11:00",@"UTC-10:30",@"UTC-10:00",@"UTC-09:30",
                         @"UTC-09:00",@"UTC-08:30",@"UTC-08:00",@"UTC-07:30",@"UTC-07:00",@"UTC-06:30",
                         @"UTC-06:00",@"UTC-05:30",@"UTC-05:00",@"UTC-04:30",@"UTC-04:00",@"UTC-03:30",
                         @"UTC-03:00",@"UTC-02:30",@"UTC-02:00",@"UTC-01:30",@"UTC-01:00",@"UTC-00:30",
                         @"UTC+00:00",@"UTC+00:30",@"UTC+01:00",@"UTC+01:30",@"UTC+02:00",@"UTC+02:30",
                         @"UTC+03:00",@"UTC+03:30",@"UTC+04:00",@"UTC+04:30",@"UTC+05:00",@"UTC+05:30",
                         @"UTC+06:00",@"UTC+06:30",@"UTC+07:00",@"UTC+07:30",@"UTC+08:00",@"UTC+08:30",
                         @"UTC+09:00",@"UTC+09:30",@"UTC+10:00",@"UTC+10:30",@"UTC+11:00",@"UTC+11:30",
                         @"UTC+12:00",@"UTC+12:30",@"UTC+13:00",@"UTC+13:30",@"UTC+14:00"];
    });
    NSInteger index = timezoneIndex + 24;
    if (index < 0 || index >= timeZoneList.count) {
        return @"";
    }
    return timeZoneList[index];
}

#pragma mark - setter
- (void)setDataModel:(NSDictionary *)dataModel {
    _dataModel = dataModel;
    if (!ValidDict(_dataModel)) {
        return;
    }
    self.timeLabel.text = [@"Time: " stringByAppendingString:[[self class] timeStringWithData:dataModel]];
    self.macAddressLabel.text = [[self class] macStringWithData:dataModel title:SafeStr(self.macTitle)];
    self.rssiLabel.text = [[self class] rssiStringWithData:dataModel];
    self.deviceTypeLabel.text = [[self class] deviceTypeStringWithData:dataModel];
    if (ValidStr(dataModel[@"rawData"])) {
        self.rawDataLabel.text = [@"Raw Data: " stringByAppendingString:dataModel[@"rawData"]];
    }else {
        self.rawDataLabel.text = @"Raw Data: N/A";
    }
    
    self.macAddressLabel.hidden = !self.showMacAddress;
    self.rssiLabel.hidden = !self.showRSSI;
    self.deviceTypeLabel.hidden = !self.showDeviceType;
    [self setNeedsLayout];
}

- (void)setShowMacAddress:(BOOL)showMacAddress {
    _showMacAddress = showMacAddress;
    self.macAddressLabel.hidden = !showMacAddress;
}

- (void)setShowRSSI:(BOOL)showRSSI {
    _showRSSI = showRSSI;
    self.rssiLabel.hidden = !showRSSI;
}

- (void)setShowDeviceType:(BOOL)showDeviceType {
    _showDeviceType = showDeviceType;
    self.deviceTypeLabel.hidden = !showDeviceType;
}

- (void)setMacTitle:(NSString *)macTitle {
    _macTitle = macTitle;
    self.macAddressLabel.text = [[self class] macStringWithData:self.dataModel title:SafeStr(macTitle)];
}

#pragma mark - getter
- (UIStackView *)stackView {
    if (!_stackView) {
        _stackView = [[UIStackView alloc] initWithArrangedSubviews:@[self.timeLabel,
                                                                    self.macAddressLabel,
                                                                    self.rssiLabel,
                                                                    self.deviceTypeLabel,
                                                                    self.rawDataLabel]];
        _stackView.axis = UILayoutConstraintAxisVertical;
        _stackView.alignment = UIStackViewAlignmentFill;
        _stackView.spacing = 5.f;
    }
    return _stackView;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [self createMsgLabel];
        _timeLabel.text = @"Time:";
        _timeLabel.numberOfLines = 0;
    }
    return _timeLabel;
}

- (UILabel *)macAddressLabel {
    if (!_macAddressLabel) {
        _macAddressLabel = [self createMsgLabel];
        _macAddressLabel.text = @"MAC Address:";
    }
    return _macAddressLabel;
}

- (UILabel *)rssiLabel {
    if (!_rssiLabel) {
        _rssiLabel = [self createMsgLabel];
        _rssiLabel.text = @"RSSI:";
    }
    return _rssiLabel;
}

- (UILabel *)deviceTypeLabel {
    if (!_deviceTypeLabel) {
        _deviceTypeLabel = [self createMsgLabel];
        _deviceTypeLabel.text = @"Device Type:";
    }
    return _deviceTypeLabel;
}

- (UILabel *)rawDataLabel {
    if (!_rawDataLabel) {
        _rawDataLabel = [self createMsgLabel];
        _rawDataLabel.text = @"Raw Data:";
        _rawDataLabel.numberOfLines = 0;
    }
    return _rawDataLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = CUTTING_LINE_COLOR;
    }
    return _lineView;
}

- (UILabel *)createMsgLabel {
    UILabel *msgLabel = [[UILabel alloc] init];
    msgLabel.textColor = UIColorFromRGB(0x333333);
    msgLabel.textAlignment = NSTextAlignmentLeft;
    msgLabel.font = MKFont(msgLabelFontSize);
    return msgLabel;
}

@end
