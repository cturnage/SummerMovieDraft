//
//  AppDelegate.h
//  SummerMovieDraft
//
//  Created by Chris Tot on 6/7/13.
//  Copyright (c) 2013 christurnage. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic) bool isConnected;
@property (strong, nonatomic) NSUserDefaults *defaults;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

- (void)networkCheck;

@end
