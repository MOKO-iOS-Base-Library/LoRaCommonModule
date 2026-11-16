#import "MKBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKDebuggerCellModel : NSObject

@property (nonatomic, assign)NSInteger index;

@property (nonatomic, copy)NSString *timeMsg;

@property (nonatomic, assign)BOOL selected;

@property (nonatomic, copy)NSString *logInfo;

@end

@protocol MKDebuggerCellDelegate <NSObject>

- (void)mk_debuggerCellSelectedChanged:(NSInteger)index selected:(BOOL)selected;

@end

@interface MKDebuggerCell : MKBaseCell

@property (nonatomic, strong)MKDebuggerCellModel *dataModel;

@property (nonatomic, weak)id <MKDebuggerCellDelegate>delegate;

+ (MKDebuggerCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
