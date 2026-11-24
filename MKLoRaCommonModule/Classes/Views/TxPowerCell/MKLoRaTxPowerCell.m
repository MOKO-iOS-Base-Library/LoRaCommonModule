//
//  MKLoRaTxPowerCell.m
//  MKLoRaCommonModule
//
//  Created by aa on 2026/11/20.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "MKLoRaTxPowerCell.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "NSString+MKAdd.h"

#import "MKSlider.h"

@implementation MKLoRaTxPowerCellModel

@end

@interface MKLoRaTxPowerCell ()

@property (nonatomic, strong)UILabel *msgLabel;

@property (nonatomic, strong)UILabel *noteLabel;

@property (nonatomic, strong)UILabel *valueLabel;

@property (nonatomic, strong)MKSlider *slider;

@end

@implementation MKLoRaTxPowerCell

+ (MKLoRaTxPowerCell *)initCellWithTableView:(UITableView *)tableView {
    MKLoRaTxPowerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKLoRaTxPowerCellIdenty"];
    if (!cell) {
        cell = [[MKLoRaTxPowerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKLoRaTxPowerCellIdenty"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.msgLabel];
        [self.contentView addSubview:self.noteLabel];
        [self.contentView addSubview:self.valueLabel];
        [self.contentView addSubview:self.slider];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.msgLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(-15.f);
        make.top.mas_equalTo(10.f);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    CGSize noteSize = [NSString sizeWithText:self.noteLabel.text
                                     andFont:self.noteLabel.font
                                  andMaxSize:CGSizeMake(kViewWidth - 2 * 15.f, MAXFLOAT)];
    [self.noteLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(-15.f);
        make.top.mas_equalTo(self.msgLabel.mas_bottom).mas_offset(5.f);
        make.height.mas_equalTo(noteSize.height);
    }];
    [self.slider mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(self.valueLabel.mas_left).mas_offset(-5.f);
        make.top.mas_equalTo(self.noteLabel.mas_bottom).mas_offset(10.f);
        make.height.mas_equalTo(10.f);
    }];
    [self.valueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.width.mas_equalTo(60.f);
        make.centerY.mas_equalTo(self.slider.mas_centerY);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
}

#pragma mark - event method

- (void)txPowerSliderValueChanged {
    self.valueLabel.text = [self txPowerValueText:self.slider.value];
    if ([self.delegate respondsToSelector:@selector(mk_lora_txPowerCell_valueChanged:)]) {
        [self.delegate mk_lora_txPowerCell_valueChanged:(NSInteger)self.slider.value];
    }
}

#pragma mark - private method

- (NSString *)txPowerValueText:(float)sliderValue {
    NSInteger index = (NSInteger)sliderValue;
    NSArray *txPowerList = self.dataModel.txPowerList;
    if (index >= 0 && index < txPowerList.count) {
        return txPowerList[index];
    }
    return @"0dBm";
}

- (NSString *)txPowerNoteText:(NSArray <NSString *>*)txPowerList {
    if (!txPowerList.count) {
        return @"";
    }
    NSMutableArray *noteList = [NSMutableArray array];
    for (NSString *txPower in txPowerList) {
        NSString *value = [txPower stringByReplacingOccurrencesOfString:@"dBm" withString:@""];
        if (value.length && ![value hasPrefix:@"-"] && ![value isEqualToString:@"0"]) {
            //正数前面补上"+"
            value = [@"+" stringByAppendingString:value];
        }
        [noteList addObject:value];
    }
    return [NSString stringWithFormat:@"(%@)", [noteList componentsJoinedByString:@","]];
}

#pragma mark - setter

- (void)setDataModel:(MKLoRaTxPowerCellModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel) {
        return;
    }
    self.slider.maximumValue = (_dataModel.txPowerList.count > 0) ? (_dataModel.txPowerList.count - 1) : 0;
    self.slider.value = _dataModel.txPower;
    if (_dataModel.customNoteText.length) {
        self.noteLabel.text = _dataModel.customNoteText;
    } else {
        self.noteLabel.text = [self txPowerNoteText:_dataModel.txPowerList];
    }
    self.valueLabel.text = [self txPowerValueText:_dataModel.txPower];
    [self setNeedsLayout];
}

#pragma mark - getter

- (UILabel *)msgLabel {
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc] init];
        _msgLabel.textAlignment = NSTextAlignmentLeft;
        _msgLabel.font = MKFont(15.f);
        _msgLabel.textColor = DEFAULT_TEXT_COLOR;
        _msgLabel.text = @"Tx Power";
    }
    return _msgLabel;
}

- (UILabel *)noteLabel {
    if (!_noteLabel) {
        _noteLabel = [[UILabel alloc] init];
        _noteLabel.font = MKFont(13.f);
        _noteLabel.textColor = RGBCOLOR(223, 223, 223);
        _noteLabel.textAlignment = NSTextAlignmentLeft;
        _noteLabel.numberOfLines = 0;
    }
    return _noteLabel;
}

- (MKSlider *)slider {
    if (!_slider) {
        _slider = [[MKSlider alloc] init];
        _slider.maximumValue = 0.f;
        _slider.minimumValue = 0.f;
        _slider.value = 0.f;
        [_slider addTarget:self
                    action:@selector(txPowerSliderValueChanged)
          forControlEvents:UIControlEventValueChanged];
    }
    return _slider;
}

- (UILabel *)valueLabel {
    if (!_valueLabel) {
        _valueLabel = [[UILabel alloc] init];
        _valueLabel.textColor = DEFAULT_TEXT_COLOR;
        _valueLabel.textAlignment = NSTextAlignmentLeft;
        _valueLabel.font = MKFont(11.f);
        _valueLabel.text = @"0dBm";
    }
    return _valueLabel;
}

@end
