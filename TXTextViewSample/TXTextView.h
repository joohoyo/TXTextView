#import <UIKit/UIKit.h>

@interface TXTextView : UIView <UIWebViewDelegate>

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic) CGFloat lineSpacing;
@property (nonatomic) BOOL editable;

- (id)initWithText:(NSString *)text withFont:(UIFont *)font withLineSpacing:(CGFloat)lineSpacing;

@end
