//
//  student.h
//  SQLite
//
//  Created by 薛涛 on 17/2/9.
//  Copyright © 2017年 Xuetao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface student : NSObject

@property (nonatomic, assign) NSInteger number;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *sex;

@end
