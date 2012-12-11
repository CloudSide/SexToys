//
//  LdbHandle.h
//  v
//
//  Created by  on 12-3-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef BOOL (^KeyBlock)(NSString *key);
typedef BOOL (^KeyValueBlock)(NSString *key, id value);

@class LevelDB;

@interface LdbHandler : NSObject {

    LevelDB *_leveldb;
}

/*
 
 改成了成员方法
 
+ (void)putObject:(id)value forKey:(NSString *)key inLDB:(NSString *)ldbName;
+ (id)getObject:(NSString *)key inLDB:(NSString *)ldbName;
+ (NSString *)getString:(NSString *)key inLDB:(NSString *)ldbName;
+ (NSDictionary *)getDictionary:(NSString *)key inLDB:(NSString *)ldbName;
+ (NSArray *)getArray:(NSString *)key inLDB:(NSString *)ldbName;
+ (void)deleteObject:(NSString *)key inLDB:(NSString *)ldbName;
+ (void)clearInLDB:(NSString *)ldbName;
+ (NSArray *)allKeysInLDB:(NSString *)ldbName;
+ (void)deleteLDB:(NSString *)ldbName;
 */

+ (LdbHandler *)sharedDb;
+ (LdbHandler *)sharedCacheDb;
- (id)initWithDbName:(NSString *)dbName;

/*
 set methods
 */
- (void)putObject:(id)value forKey:(NSString *)key;


/*
 get methods
 */
- (id)getObject:(NSString *)key;
- (NSString *)getString:(NSString *)key;
- (NSDictionary *)getDictionary:(NSString *)key;
- (NSArray *)getArray:(NSString *)key;


/*
 iteration methods
 */
- (NSArray *)allKeys;
- (void)iterateKeys:(KeyBlock)block;
- (void)iterate:(KeyValueBlock)block;


/*
 clear methods
 */
- (void)deleteObject:(NSString *)key;
- (void)clear;
- (void)deleteDatabase;


@end
