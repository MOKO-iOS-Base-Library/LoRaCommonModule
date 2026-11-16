//
//  MKOtherAddOptionsCell.m
//  MKLoRaCommonModule
//

#import "MKOtherAddOptionsCell.h"

#import "Masonry.h"
#import "MKMacroDefines.h"
#import "UIView+MKAdd.h"

@interface MKOtherAddOptionsCell ()

@property (nonatomic, strong)UILabel *msgLabel;

@property (nonatomic, strong)UIButton *addButton;

@end

@implementation MKOtherAddOptionsCellModel
@end

@implementation MKOtherAddOptionsCell

+ (MKOtherAddOptionsCell *)initCellWithTableView:(UITableView *)tableView {
    MKOtherAddOptionsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKOtherAddOptionsCellIdenty"];
    if (!cell) {
        cell = [[MKOtherAddOptionsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKOtherAddOptionsCellIdenty"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.msgLabel];
        [self.contentView addSubview:self.addButton];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.addButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.width.mas_equalTo(30.f);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(30.f);
    }];
    [self.msgLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(self.addButton.mas_left).mas_offset(-15.f);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
}

#pragma mark - event method
- (void)addButtonPressed {
    if ([self.delegate respondsToSelector:@selector(mk_otherAddOptionsCellAddPressed:)]) {
        [self.delegate mk_otherAddOptionsCellAddPressed:self.dataModel.index];
    }
}

#pragma mark - setter
- (void)setDataModel:(MKOtherAddOptionsCellModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel || ![_dataModel isKindOfClass:MKOtherAddOptionsCellModel.class]) return;
    self.msgLabel.text = SafeStr(_dataModel.msg);
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

- (UIButton *)addButton {
    if (!_addButton) {
        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addButton addTarget:self action:@selector(addButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addButton;
}

@end
