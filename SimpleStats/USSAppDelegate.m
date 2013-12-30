//
//  USSAppDelegate.m
//  SimpleStats
//
//  Created by Daniel Johnson on 11/23/13.
//  Copyright (c) 2013 Daniel Johnson. All rights reserved.
//

#import "USSAppDelegate.h"
#import "FCModel.h"

#import "USSTeam.h"
#import "USSPlayer.h"
#import "USSGame.h"

#import "USSRosterViewController.h"
#import "USSGameListViewController.h"

@implementation USSAppDelegate

- (BOOL)turnOnForeignKeys:(FMDatabase *)db
{
    NSString *sql = @"PRAGMA foreign_keys;";
    FMResultSet *rs = [db executeQuery:sql];
    int enabled = 0;
    if ([rs next]) {
        enabled = [rs intForColumnIndex:0];
    }
    [rs close];

    if(!enabled) {

        sql = @"PRAGMA foreign_keys = ON;";
        [db executeUpdate:sql];      
        //check
        sql = @"PRAGMA foreign_keys;";
        FMResultSet *rs = [db executeQuery:sql];
        if ([rs next]) {
            enabled = [rs intForColumnIndex:0];
        }
        [rs close];
    }
    return enabled;
}


- (void) makeSampleData {
    USSTeam * team = [USSTeam new];
    team.name = @"Whiplash";
    [team save];
    
    for (int i = 0; i < 7; i++) {
        USSPlayer *player = [USSPlayer new];
        player.teamID = team.id;
        player.name = [NSString stringWithFormat:@"John %d Doe", i];
        player.number = [NSString stringWithFormat:@"%d",i];
        [player save];
    }
    
    USSGame *game = [USSGame new];
    game.opponent = @"Union";
    game.date = [NSDate dateWithTimeIntervalSinceNow:0.0];
    game.teamID = team.id;
    [game save];
    
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *dbPath = [documentsPath stringByAppendingPathComponent:@"database.sqlite3"];
    
    [FCModel openDatabaseAtPath:dbPath withSchemaBuilder:^(FMDatabase *db, int *schemaVersion) {
        [db setLogsErrors:YES];
        
        // My custom failure handling. Yours may vary.
        void (^failedAt)(int statement) = ^(int statement){
            int lastErrorCode = db.lastErrorCode;
            NSString *lastErrorMessage = db.lastErrorMessage;
            [db rollback];
            NSAssert3(0, @"Migration statement %d failed, code %d: %@", statement, lastErrorCode, lastErrorMessage);
        };
        
        //Turn on Foreign keys every time.
        if (![self turnOnForeignKeys:db]) {
            failedAt(0);
        }
        
        [db beginTransaction];
        
        if (*schemaVersion < 1) {
            if (! [db executeUpdate:
                   @"CREATE TABLE USSTeam ("
                   @"    id          INTEGER PRIMARY KEY AUTOINCREMENT,"
                   @"    name        TEXT NOT NULL DEFAULT ''"
                   @");"
                   ])  failedAt(1);
        
        
            if (! [db executeUpdate:
                   @"CREATE TABLE USSPlayer ("
                   @"    id           INTEGER PRIMARY KEY AUTOINCREMENT,"
                   @"    name    TEXT NOT NULL DEFAULT '',"
                   @"    number       TEXT NOT NULL DEFAULT '',"
                   @"    teamID       INTEGER NOT NULL,"
                   @"    FOREIGN KEY(teamID) REFERENCES USSTeam(id)"
                   @");"
                   ]) failedAt(2);
            
            if (! [db executeUpdate:@"CREATE INDEX IF NOT EXISTS name ON USSPlayer(teamID);"]) failedAt(3);
            
            if (! [db executeUpdate:
                   @"CREATE TABLE USSGame ("
                   @"    id           INTEGER PRIMARY KEY AUTOINCREMENT,"
                   @"    date         INTEGER NOT NULL,"
                   @"    teamID       INTEGER NOT NULL,"
                   @"    opponent     TEXT NOT NULL DEFAULT '',"
                   @"    FOREIGN KEY(teamID) REFERENCES USSTeam(id)"
                   @");"
                   ]) failedAt(4);
            
            if (! [db executeUpdate:
                   @"CREATE TABLE USSPoint ("
                   @"     id         INTEGER PRIMARY KEY AUTOINCREMENT,"
                   @"     gameID     INTEGER NOT NULL,"
                   @"     startTime  INTEGER,"
                   @"     endTime    INTEGER,"
                   @"     onOffense  INTEGER,"
                   @"     outcome     INTEGER,"
                   @"     FOREIGN KEY(gameID) REFERENCES USSGame(id)"
                   @");"
                   ]) failedAt(5);
            
            
            if (! [db executeUpdate:
                   @"CREATE TABLE USSPlayerPointLink ("
                   @"    id            INTEGER PRIMARY KEY AUTOINCREMENT,"
                   @"    playerID      INTEGER NOT NULL,"
                   @"    pointID       INTEGER NOT NULL,"
                   @"    FOREIGN KEY(playerID) REFERENCES USSPlayer(id) ON DELETE CASCADE,"
                   @"    FOREIGN KEY(pointID) REFERENCES USSPoint(id) ON DELETE CASCADE"
                   @");"
                   ]) failedAt(6);
            
            if (! [db executeUpdate:@"CREATE INDEX IF NOT EXISTS name ON USSPlayerPoint(playerID);"]) failedAt(7);
            
            if (! [db executeUpdate:@"CREATE INDEX IF NOT EXISTS name ON USSPlayerPoint(pointID);"]) failedAt(8);
            
            if (! [db executeUpdate:
                   @"CREATE TABLE USSPossession ("
                   @"    id         INTEGER PRIMARY KEY AUTOINCREMENT,"
                   @"    pointID    INTEGER NOT NULL,"
                   @"    passCount  INTEGER NOT NULL DEFAULT 0,"
                   @"    outcome    INTEGER,"
                   @"    startTime  INTEGER,"
                   @"    endTime    INTEGER,"
                   @"    onOffense  INTEGER NOT NULL,"
                   @"    FOREIGN KEY(pointID) REFERENCES USSPoint(id) ON DELETE CASCADE"
                   @");"
                   ]) failedAt(9);
            
            *schemaVersion = 1;
        }
        
        // If you wanted to change the schema in a later app version, you'd add something like this here:
        /*
         if (*schemaVersion < 2) {
         if (! [db executeUpdate:@"ALTER TABLE Person ADD COLUMN title TEXT NOT NULL DEFAULT ''"]) failedAt(3);
         *schemaVersion = 2;
         }
         
         */
        
        [db commit];
    }];
    
    //[self makeSampleData];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    
    
    
    USSRosterViewController *rosterViewController = [[USSRosterViewController alloc] init];
    USSTeam * team = [USSTeam instanceWithPrimaryKey:@(1)];
    [rosterViewController configureWithTeam:team];
    
    UINavigationController *rosterController = [[UINavigationController alloc] initWithRootViewController:rosterViewController];
    //TODO MAKE PROPER TAB BAR ITEMS
    #pragma TODO
    rosterController.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemContacts tag:1];
    
    
    USSGameListViewController *gameViewController = [[USSGameListViewController alloc] init];
    [gameViewController configureWithTeam:team];
    UINavigationController *gameController = [[UINavigationController alloc] initWithRootViewController:gameViewController];
    
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    
    tabBarController.viewControllers = @[rosterController, gameController];
    
    self.window.rootViewController = tabBarController;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
