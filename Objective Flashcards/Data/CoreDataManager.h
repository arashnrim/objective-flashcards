//
//  CoreDataManager.h
//  Objective Flashcards
//
//  Created by Arash on 4/4/24.
//

#import "Deck+CoreDataClass.h"
#import "CoreData/CoreData.h"

@interface CoreDataManager : NSObject

- (id)initWithContext: (NSManagedObjectContext *)context;

#pragma mark - Deck-related methods
- (NSMutableArray *)getDecks;
- (Deck *)getDeckByID:(NSManagedObjectID *)deckID;

#pragma mark - Card-related methods
- (NSMutableArray *)getCardsForDeckWithID: (NSManagedObjectID *)deckID;

@end
