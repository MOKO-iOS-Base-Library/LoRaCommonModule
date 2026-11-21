//
//  MKLoRaTimingModeAddCell.m
//  MKLoRaCommonModule_Example
//
//  Created by aa on 2026/11/18.
//  Copyright © 2025 aadyx2007@163.com. All rights reserved.
//

#import "MKLoRaTimingModeAddCell.h"

#import "Masonry.h"

#import "MKMacroDefines.h"

@implementation MKLoRaTimingModeAddCellModel
@end

@interface MKLoRaTimingModeAddCell ()

@property (nonatomic, strong)UIView *contentBackView;

@property (nonatomic, strong)UILabel *msgLabel;

@property (nonatomic, strong)UIButton *addButton;

@end

@implementation MKLoRaTimingModeAddCell

+ (MKLoRaTimingModeAddCell *)initCellWithTableView:(UITableView *)tableView {
    MKLoRaTimingModeAddCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKLoRaTimingModeAddCellIdenty"];
    if (!cell) {
        cell = [[MKLoRaTimingModeAddCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKLoRaTimingModeAddCellIdenty"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.contentBackView];
        [self.contentBackView addSubview:self.msgLabel];
        [self.contentBackView addSubview:self.addButton];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.contentBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
    [self.msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(self.addButton.mas_left).mas_offset(-15.f);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.width.mas_equalTo(50.f);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(30.f);
    }];
}

#pragma mark - event method
- (void)addButtonPressed {
    if ([self.delegate respondsToSelector:@selector(mk_loraModule_addButtonPressed)]) {
        [self.delegate mk_loraModule_addButtonPressed];
    }
}

#pragma mark - setter
- (void)setDataModel:(MKLoRaTimingModeAddCellModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel) {
        return;
    }
    self.msgLabel.text = SafeStr(_dataModel.msg);
}

#pragma mark - getter
- (UIView *)contentBackView {
    if (!_contentBackView) {
        _contentBackView = [[UIView alloc] init];
        _contentBackView.backgroundColor = RGBCOLOR(242, 242, 242);
    }
    return _contentBackView;
}

- (UILabel *)msgLabel {
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc] init];
        _msgLabel.textColor = DEFAULT_TEXT_COLOR;
        _msgLabel.textAlignment = NSTextAlignmentLeft;
        _msgLabel.font = MKFont(15.f);
    }
    return _msgLabel;
}

- (UIButton *)addButton {
    if (!_addButton) {
        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addButton setImage:LOADICON(@"MKLoRaCommonModule", @"MKLoRaTimingModeAddCell", @"mk_loraModule_filterEdit_addIcon.png") forState:UIControlStateNormal];
        [_addButton addTarget:self
                       action:@selector(addButtonPressed)
             forControlEvents:UIControlEventTouchUpInside];
    }
    return _addButton;
}

@end
