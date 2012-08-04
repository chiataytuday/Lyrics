//
//  StorageManager.h
//  Lyrics
//
//  Created by Daniel Cristolovean on 7/26/12.
//  Copyright (c) 2012 Daniel Cristolovean. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Band.h"
#import "Song.h"
#import "Favorites.h"

@interface StorageManager : NSObject

@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContextCustom;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModelCustom;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinatorCustom;

- (void)saveData;
- (void)saveDataCustom;

- (void)getStuff;
- (NSMutableArray *)getBands;
- (NSMutableArray *)getFavorites;
- (NSMutableArray *)getSearchData:(NSString *)filter;

- (void)addFavoriteFor:(NSString *)bandName andSong:(NSString *)songName;
- (void)removeFavorite:(NSString *)bandName andSong:(NSString *)songName;
- (BOOL)favoriteExists:(NSString *)bandName andSong:(NSString *)songName;

- (Band *)getBandForSong:(Song *)song;
- (int)getPositionForSong:(Song *)song;

+ (id)current;

@end
