//
//  StorageManager.m
//  Lyrics
//
//  Created by Daniel Cristolovean on 7/26/12.
//  Copyright (c) 2012 Daniel Cristolovean. All rights reserved.
//

#import "StorageManager.h"
#import "Additions.h"
#import "SettingsManager.h"

static StorageManager *current = nil;

@implementation StorageManager

@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;
@synthesize managedObjectContextCustom = __managedObjectContextCustom;
@synthesize managedObjectModelCustom = __managedObjectModelCustom;
@synthesize persistentStoreCoordinatorCustom = __persistentStoreCoordinatorCustom;

#pragma mark - Singleton

+ (id)current {
	@synchronized(self) {
		if (current == nil)
			current = [[super allocWithZone:NULL] init];
	}
	return current;
}

#pragma mark - Temp data creation

- (void)getStuff {
}

#pragma mark - Save context

- (void)saveData {
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Save error: %@", [error localizedDescription]);
    }
}

- (void)saveDataCustom {
    NSError *error;
    if (![self.managedObjectContextCustom save:&error]) {
        NSLog(@"Save error: %@", [error localizedDescription]);
    }
}

#pragma mark - Favorites

- (NSMutableArray *)getFavorites {
    
    NSError *error;
    NSMutableArray *favorites;
    
    NSMutableArray *items = [[NSMutableArray alloc] init];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Favorites" inManagedObjectContext:self.managedObjectContextCustom];
    [fetchRequest setEntity:entity];
    favorites = [NSMutableArray arrayWithArray:[self.managedObjectContextCustom executeFetchRequest:fetchRequest error:&error]];
    
    if (favorites) {
        NSMutableArray *onlyAuthors = [[NSMutableArray alloc] init];
        NSMutableArray *authors = [[NSMutableArray alloc] init];
        NSMutableArray *poems = [[NSMutableArray alloc] init];
        for (Favorites *f in favorites) {
            if ([NSString isEmpty:f.songName] || [f.songName isEqualToString:@" "])
                [onlyAuthors addObject:f.bandName];
            [authors addObject:f.bandName];
            [poems addObject:f.songName];
        }
        
        if (onlyAuthors.count > 0) {
            fetchRequest = [[NSFetchRequest alloc] init];
            NSEntityDescription *entity = [NSEntityDescription entityForName:@"Band" inManagedObjectContext:self.managedObjectContext];
            [fetchRequest setEntity:entity];
            [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"name IN %@", onlyAuthors]];
            [items addObjectsFromArray:[self.managedObjectContext executeFetchRequest:fetchRequest error:&error]];
        }
        
        if (authors.count > 0) {
            fetchRequest = [[NSFetchRequest alloc] init];
            NSEntityDescription *entity2 = [NSEntityDescription entityForName:@"Song" inManagedObjectContext:self.managedObjectContext];
            [fetchRequest setEntity:entity2];
            [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"title IN %@", poems]];
            NSMutableArray *temp = [NSMutableArray arrayWithArray:[self.managedObjectContext executeFetchRequest:fetchRequest error:&error]];
            if (temp && temp.count > 0) {
                for (Song *p in temp) {
                    for (NSString *auth in authors) {
                        if ([p.band.name isEqualToString:auth]) {
                            [items addObject:p];
                            break;
                        }
                    }
                }
            }
        }
    }
    
    return items;
}

- (BOOL)favoriteExists:(NSString *)bandName andSong:(NSString *)songName {
    NSError *error;
    NSMutableArray *items;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Favorites" inManagedObjectContext:self.managedObjectContextCustom];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"bandName == %@ AND songName == %@", bandName, songName]];
    
    items = [NSMutableArray arrayWithArray:[self.managedObjectContextCustom executeFetchRequest:fetchRequest error:&error]];
    
    if (items && items.count > 0)
        return YES;
    
    return NO;
    
}

- (void)addFavoriteFor:(NSString *)bandName andSong:(NSString *)songName {
    
    if (![self favoriteExists:bandName andSong:songName]) {
        Favorites *fav = [NSEntityDescription insertNewObjectForEntityForName:@"Favorites" inManagedObjectContext:self.managedObjectContextCustom];
        fav.bandName = bandName;
        fav.songName = songName;
        [self saveDataCustom];
    }
}

- (void)removeFavorite:(NSString *)bandName andSong:(NSString *)songName {
    NSError *error;
    NSMutableArray *items;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Favorites" inManagedObjectContext:self.managedObjectContextCustom];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"bandName == %@ AND songName == %@", bandName, songName]];
    
    items = [NSMutableArray arrayWithArray:[self.managedObjectContextCustom executeFetchRequest:fetchRequest error:&error]];
    
    if (items && items.count > 0) {
        [self.managedObjectContextCustom deleteObject:[items objectAtIndex:0]];
        [self saveDataCustom];
    }
}

#pragma mark - Search

- (NSMutableArray *)getSearchData:(NSString *)filter {
    
    NSError *error;
    NSMutableArray *items;
    NSMutableArray *items2;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Band" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"name like[cd] %@", [NSString stringWithFormat:@"*%@*", filter]]];
    
    items = [NSMutableArray arrayWithArray:[self.managedObjectContext executeFetchRequest:fetchRequest error:&error]];
    
    fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity2 = [NSEntityDescription entityForName:@"Song" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity2];
    
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"title like[cd] %@", [NSString stringWithFormat:@"*%@*", filter]]];
    
    items2 = [NSMutableArray arrayWithArray:[self.managedObjectContext executeFetchRequest:fetchRequest error:&error]];
    
    return [NSMutableArray arrayWithArray:[items arrayByAddingObjectsFromArray:items2]];
}

#pragma mark - Writer & Poems

- (Band *)getBandForSong:(Song *)song {
    NSMutableArray *bands = [self getBands];
    
    for (Band *band in bands) {
        for (Song *p in band.songs)
            if (p == song)
                return band;
    }
    
    return nil;
}

- (int)getPositionForSong:(Song *)song {
    
    Band *band = [self getBandForSong:song];
    
    NSMutableArray *poemsUnsorted = [[NSMutableArray alloc] init];
    
    for (Song *p in band.songs)
        [poemsUnsorted addObject:p];
    
    NSArray *poems = [poemsUnsorted sortedArrayUsingComparator:^(id a, id b) {
        NSString *first = [(Song *)a title];
        NSString *second = [(Song *)b title];
        return [first compare:second];
    }];
    
    int a = 0;
    
    for (Song *p in poems) {
        if (p == song)
            return a;
        a++;
    }
    
    return 0;
}

- (NSMutableArray *)getBands {
    
    NSError *error;
    NSMutableArray *items;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Band" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:descriptor]];
       
    items = [NSMutableArray arrayWithArray:[self.managedObjectContext executeFetchRequest:fetchRequest error:&error]];
    
    return items;
}

#pragma mark - Application's Documents directory

- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSString *)stringApplicationDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
}

#pragma mark - Core Data stack

- (NSManagedObjectContext *)managedObjectContext {
    
    if (__managedObjectContext != nil) {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)     {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

- (void)reloadManagedObjectContext {
    
    __managedObjectContext = nil;
    __persistentStoreCoordinator = nil;
    __managedObjectModel = nil;
    
}

- (NSManagedObjectModel *)managedObjectModel {
    
    if (__managedObjectModel != nil) {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Lyrics" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (__persistentStoreCoordinator != nil)     {
        return __persistentStoreCoordinator;
    }
    
    NSString *storePath = @"";
   
    storePath = [[self stringApplicationDocumentsDirectory] stringByAppendingPathComponent:@"Lyrics_Speed_Thrash.sqlite"];
    
    NSString *installedVersion = [[SettingsManager current] getVersion];
    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    
    if (installedVersion == nil || ![currentVersion isEqualToString:installedVersion]) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:storePath]) {
            [fileManager removeItemAtPath:storePath error:nil];
        }
    }
    
    [[SettingsManager current] setVersion:currentVersion];
    
    NSURL *storeURL = [NSURL fileURLWithPath:storePath];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:storePath]) {
        NSString *defaultStorePath = @"";
        
        defaultStorePath = [[NSBundle mainBundle] pathForResource:@"Lyrics_Speed_Thrash" ofType:@"sqlite"];
               
        if (defaultStorePath)
            [fileManager copyItemAtPath:defaultStorePath toPath:storePath error:NULL];
    }
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error])     {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return __persistentStoreCoordinator;
}

- (NSManagedObjectContext *)managedObjectContextCustom {
    
    if (__managedObjectContextCustom != nil) {
        return __managedObjectContextCustom;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinatorCustom];
    if (coordinator != nil) {
        __managedObjectContextCustom = [[NSManagedObjectContext alloc] init];
        [__managedObjectContextCustom setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContextCustom;
}

- (void)reloadManagedObjectContextCustom {
    
    __managedObjectContextCustom = nil;
    __persistentStoreCoordinatorCustom = nil;
    __managedObjectModelCustom = nil;
    
}

- (NSManagedObjectModel *)managedObjectModelCustom {
    
    if (__managedObjectModelCustom != nil) {
        return __managedObjectModelCustom;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"CustomDataLyrics" withExtension:@"momd"];
    __managedObjectModelCustom = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModelCustom;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinatorCustom {
    if (__persistentStoreCoordinatorCustom != nil)     {
        return __persistentStoreCoordinatorCustom;
    }
    
    NSString *storePath = [[self stringApplicationDocumentsDirectory] stringByAppendingPathComponent:@"CustomDataLyrics"];
    NSURL *storeURL = [NSURL fileURLWithPath:storePath];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:storePath]) {
        NSString *defaultStorePath  = [[NSBundle mainBundle] pathForResource:@"CustomDataLyrics" ofType:@"sqlite"];
        if (defaultStorePath)
            [fileManager copyItemAtPath:defaultStorePath toPath:storePath error:NULL];
    }
    
    NSError *error = nil;
    __persistentStoreCoordinatorCustom = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModelCustom]];
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    
    if (![__persistentStoreCoordinatorCustom addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error])     {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return __persistentStoreCoordinatorCustom;
}

@end
