//
//  LevelDB.h
//
//  Copyright 2011 Pave Labs. 
//  See LICENCE for details.
//

#import <Foundation/Foundation.h>

#import "leveldb/db.h"

using namespace leveldb;

typedef BOOL (^KeyBlock)(NSString *key);
typedef BOOL (^KeyValueBlock)(NSString *key, id value);

@interface LevelDB : NSObject {
    
    DB *db;
    ReadOptions readOptions;
    WriteOptions writeOptions;
}

@property (nonatomic, retain) NSString *path;

+ (id)libraryPath;
+ (LevelDB *)databaseInLibraryWithName:(NSString *)name;

- (id)initWithPath:(NSString *)path;

- (void)putObject:(id)value forKey:(NSString *)key;

- (id)getObject:(NSString *)key;
- (NSString *)getString:(NSString *)key;
- (NSDictionary *)getDictionary:(NSString *)key;
- (NSArray *)getArray:(NSString *)key;

//iteration methods
- (NSArray *)allKeys;
- (void)iterateKeys:(KeyBlock)block;
- (void)iterate:(KeyValueBlock)block;

//clear methods
- (void)deleteObject:(NSString *)key;
- (void)clear;
- (void)deleteDatabase;

@end
