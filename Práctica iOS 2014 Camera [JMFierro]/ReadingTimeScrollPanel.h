//
//  ReadingTimeScrollPanel.h
//  Práctica iOS 2014 Camera [JMFierro]
//
//  José Manuel Fierro Conchouso on 27/04/14.
//
//

/*
 Este código de scroll
 esta basado en el de
 https://gist.github.com/FlorianMielke/1437123
 */

#import <UIKit/UIKit.h>
#import "UITextView+ReadingTime.h"

@interface ReadingTimeScrollPanel : UIView <UITextViewDelegate, UIScrollViewDelegate>

@property (strong, nonatomic) UILabel *titleLabel;
@property (assign, nonatomic) CGFloat cornerRadius UI_APPEARANCE_SELECTOR;
@property (assign, nonatomic) CGFloat titleLabelPadding UI_APPEARANCE_SELECTOR;
@property (strong, nonatomic) UIColor *calloutBackgroundColor UI_APPEARANCE_SELECTOR;

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView;

@end
