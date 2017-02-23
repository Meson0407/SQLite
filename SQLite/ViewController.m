//
//  ViewController.m
//  SQLite
//
//  Created by 薛涛 on 17/2/9.
//  Copyright © 2017年 Xuetao. All rights reserved.
//

#import "ViewController.h"
#import <sqlite3.h>
#import "student.h"

#define PATH [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]

static sqlite3 *db; // 指向数据库的指针 我们的其他操作都由这个指针来完成

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    student *stu = [[student alloc] init];
    
    stu.number = 1110;
    stu.age = 20;
    stu.name = @"bill";
    stu.sex = @"boy";
    
    [self openSqlite];
    [self createTable];
    [self addStudent:stu];
    
    NSMutableArray *arr = [self selectWithStu];
    NSLog(@"arr = %@", arr);
}

#pragma mark - open
- (void)openSqlite {
    if (db != nil) {
        NSLog(@"数据库已经打开");
        return;
    }
    
    // 获取文件路径
    NSString *strPath = [PATH stringByAppendingPathComponent:@"my.sqlite"];
    NSLog(@"%@", strPath);
    
    int result = sqlite3_open([strPath UTF8String], &db);
    if (result == SQLITE_OK) {
        NSLog(@"数据库打开成功");
    } else {
        NSLog(@"数据库打开失败");
    }
}

#pragma mark - create
- (void)createTable {
    // sqplite语句
    NSString *sqlite = [NSString stringWithFormat:@"create table if not exists 'student' ('number' integer primary key autoincrement not null,'name' text,'sex' text,'age' integer)"];
    char *error = NULL;
    int result = sqlite3_exec(db, [sqlite UTF8String], nil, nil, &error);
    
    if (result == SQLITE_OK) {
        NSLog(@"创建成功");
    } else {
        NSLog(@"创建失败");
    }
}

#pragma mark - add
- (void)addStudent:(student *)stu {
    NSString *sqlite = [NSString stringWithFormat:@"insert into student(number,name,sex,age) values('%ld','%@','%@','%ld')", stu.number, stu.name, stu.sex, stu.age];
    char *error = NULL;
    int result = sqlite3_exec(db, [sqlite UTF8String], nil, nil, &error);
    if (result == SQLITE_OK) {
        NSLog(@"添加数据成功");
    } else {
        NSLog(@"添加数据失败");
    }
}

#pragma mark - select
- (NSMutableArray *)selectWithStu {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSString *sqlite = [NSString stringWithFormat:@"select * from student"];
    sqlite3_stmt *stmt = NULL;// 伴随指针
    int result = sqlite3_prepare(db, sqlite.UTF8String, -1, &stmt, NULL);
    if (result == SQLITE_OK) {
        NSLog(@"查询成功");
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            student *stu = [[student alloc] init];
            stu.number = sqlite3_column_int(stmt, 0);
            stu.name = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 1)];
            stu.sex = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 2)];
            stu.age = sqlite3_column_int(stmt, 3);
            [array addObject:stu];
        }
    } else {
        NSLog(@"查询失败");
    }
    sqlite3_finalize(stmt);
    return array;
}

#pragma mark - update
- (void)updataWithStu:(student *)stu {
    NSString *sqlite = [NSString stringWithFormat:@"update student set name = '%@',sex = '%@', age = '%ld' where number = '%ld'", stu.name, stu.sex, stu.age, stu.number];
    char *error = NULL;
    int result = sqlite3_exec(db, [sqlite UTF8String], nil, nil, &error);
    if (result == SQLITE_OK) {
        NSLog(@"修改数据成功");
    } else {
        NSLog(@"修改数据失败");
    }
}

#pragma mark - delete
- (void)delete:(student *)stu {
    NSString *sqlite = [NSString stringWithFormat:@"delete from student where number = '%ld'", stu.number];
    char *error = NULL;
    int result = sqlite3_exec(db, [sqlite UTF8String], nil, nil, &error);
    if (result == SQLITE_OK) {
        NSLog(@"删除数据成功");
    } else {
        NSLog(@"删除数据失败%s", error);
    }
}

#pragma mark - close
- (void)closeSqlite {
    int result = sqlite3_close(db);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
