//
//  DeckViewController.h
//  Objective Flashcards
//
//  Created by Arash on 3/4/24.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface DeckViewController : UITableViewController

@property (nonatomic) NSManagedObjectID* selectedDeckId;

@end

NS_ASSUME_NONNULL_END
