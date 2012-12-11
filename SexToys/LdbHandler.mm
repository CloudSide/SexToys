//
//  LdbHandle.m
//  v
//
//  Created by  on 12-3-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LdbHandler.h"
#import "LevelDB.h"

static LdbHandler *kSharedDb = nil;
static LdbHandler *kSharedCacheDb = nil;

@implementation LdbHandler

/*
 set methods
 */

- (void)putObject:(id)value forKey:(NSString *)key {

    [_leveldb putObject:value forKey:key];
}


/*
 get methods
 */

- (id)getObject:(NSString *)key {

    return [_leveldb getObject:key];
}

- (NSString *)getString:(NSString *)key {

    return [_leveldb getString:key];
}

- (NSDictionary *)getDictionary:(NSString *)key {
    
    return [_leveldb getDictionary:key];

}

- (NSArray *)getArray:(NSString *)key {

    return [_leveldb getArray:key];
}


/*
 iteration methods
 */

- (NSArray *)allKeys {

    return [_leveldb allKeys];
}

- (void)iterateKeys:(KeyBlock)block {

    [_leveldb iterateKeys:block];
}

- (void)iterate:(KeyValueBlock)block {

    [_leveldb iterate:block];
}


/*
 clear methods
 */

- (void)deleteObject:(NSString *)key {

    [_leveldb deleteObject:key];
}

- (void)clear {

     [_leveldb clear];
}

- (void)deleteDatabase {

    [_leveldb deleteDatabase];
}

#pragma mark -

- (id)initWithDbName:(NSString *)dbName {
    
    if (self = [super init]) {
        
        _leveldb = [[LevelDB databaseInLibraryWithName:dbName] retain];
    }
    
    return self;
}

+ (LdbHandler *)sharedDb {

    if (kSharedDb == nil) {
        
        kSharedDb = [[LdbHandler alloc] initWithDbName:@"shared_db.ldb"];
    }
    
    return kSharedDb;
}

+ (LdbHandler *)sharedCacheDb {
    
    if (kSharedCacheDb == nil) {
        
        kSharedCacheDb = [[LdbHandler alloc] initWithDbName:@"shared_cache_db.ldb"];
    }
    
    return kSharedCacheDb;
}

- (void)dealloc {

    [_leveldb release];
    [super dealloc];
}


@end
