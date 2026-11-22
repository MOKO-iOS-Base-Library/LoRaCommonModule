//
//  MKLoRaSynTableHeaderView.h
//  MKLoRaCommonModule
//
//  Created by Trae on 2026/11/22.
//

#import <UIKit/UIKit.h>

#import "MKTextField.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKLoRaSynDataIconButton : UIControl

@property (nonatomic, strong)UIImageView *topIcon;

@property (nonatomic, strong)UILabel *msgLabel;

@end

@interface MKLoRaSynTableHeaderView : UIView

@property (nonatomic, strong, readonly)MKTextField *textField;

@property (nonatomic, strong, readonly)UIButton *startButton;

@property (nonatomic, strong, readonly)MKLoRaSynDataIconButton *synButton;

@property (nonatomic, strong, readonly)MKLoRaSynDataIconButton *emptyButton;

@property (nonatomic, strong, readonly)MKLoRaSynDataIconButton *exportButton;

@property (nonatomic, strong, readonly)UILabel *sumLabel;

@property (nonatomic, strong, readonly)UILabel *countLabel;

@end

NS_ASSUME_NONNULL_END
