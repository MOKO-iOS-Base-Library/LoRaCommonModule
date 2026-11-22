//
//  MKLoRaSettingAccountCell.m
//  MKLoRaCommonModule
//
//  Created by aa on 2026/11/18.
//

#import "MKLoRaSettingAccountCell.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "NSString+MKAdd.h"
#import "UIView+MKAdd.h"

@implementation MKLoRaSettingAccountCellModel
@end

@interface MKLoRaSettingAccountCell ()

@property (nonatomic, strong)UILabel *msgLabel;

@property (nonatomic, strong)UILabel *logoutBtn;

@end

@implementation MKLoRaSettingAccountCell

+ (MKLoRaSettingAccountCell *)initCellWithTableView:(UITableView *)tableView {
    MKLoRaSettingAccountCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKLoRaSettingAccountCellIdenty"];
    if (!cell) {
        cell = [[MKLoRaSettingAccountCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKLoRaSettingAccountCellIdenty"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.msgLabel];
        [self.contentView addSubview:self.logoutBtn];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(self.logoutBtn.mas_left).mas_offset(-15.f);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    [self.logoutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.width.mas_equalTo(85.f);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(30.f);
    }];
}

#pragma mark - event method
- (void)logoutBtnPressed {
    if ([self.delegate respondsToSelector:@selector(mk_loraSettingAccountCell_logoutBtnPressed)]) {
        [self.delegate mk_loraSettingAccountCell_logoutBtnPressed];
    }
}

#pragma mark - setter
- (void)setDataModel:(MKLoRaSettingAccountCellModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel || ![_dataModel isKindOfClass:MKLoRaSettingAccountCellModel.class]) {
        return;
    }
    self.msgLabel.text = [@"Account:" stringByAppendingString:SafeStr(_dataModel.account)];
}

#pragma mark - getter
- (UILabel *)msgLabel {
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc] init];
        _msgLabel.textColor = DEFAULT_TEXT_COLOR;
        _msgLabel.textAlignment = NSTextAlignmentLeft;
        _msgLabel.font = MKFont(15.f);
    }
    return _msgLabel;
}

- (UILabel *)logoutBtn {
    if (!_logoutBtn) {
        _logoutBtn = [[UILabel alloc] init];
        _logoutBtn.textColor = NAVBAR_COLOR_MACROS;
        _logoutBtn.textAlignment = NSTextAlignmentRight;
        _logoutBtn.font = MKFont(13.f);
        _logoutBtn.text = @"Logout";
        [_logoutBtn addTapAction:self selector:@selector(logoutBtnPressed)];
    }
    return _logoutBtn;
}

@end
