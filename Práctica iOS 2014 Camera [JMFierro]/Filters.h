//
//  Filters.h
//  Práctica iOS 2014 Camera [JMFierro]
//
//  Created by José Manuel Fierro Conchouso on 05/05/14.
//  Copyright (c) 2014 José Manuel Fierro Conchouso. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CellFilterDelegate

-(void)addFilter:(NSString *)nameFilter;

@end

@interface Filters : NSObject{
    id delegate;
}

@property (nonatomic, retain) id<CellFilterDelegate> delegate;


@end
