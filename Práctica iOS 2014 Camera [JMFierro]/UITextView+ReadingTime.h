//
//  UITextView+WordCount.h
//  Práctica iOS 2014 Camera [JMFierro]
//
//  José Manuel Fierro Conchouso on 27/04/14.
//
//

#import <UIKit/UIKit.h>

@interface UITextView (ReadingTime)

@property (nonatomic) BOOL enableReadingTime;
@property (nonatomic) NSUInteger wordsPerMinute;
@property (nonatomic, readonly) NSUInteger numberOfWords;

- (NSUInteger)readingTime;
- (NSUInteger)remainingReadingTime;

@end
