//
//  CoreDataManager.m
//  Objective Flashcards
//
//  Created by Arash on 4/4/24.
//

#import <Foundation/Foundation.h>
#import "CoreDataManager.h"

@interface CoreDataManager ()

@property (nonatomic, weak) NSManagedObjectContext *context;

@end

@implementation CoreDataManager

-(id)initWithContext:(NSManagedObjectContext *)context {
    _context = context;
    
    return self;
}

/// Retrieves the flashcard decks saved on the user's device through persistence.
///
/// - Returns: An `NSMutableArray` of `Deck`s representing the flashcard decks that the user has saved.
- (NSMutableArray *)getDecks {
    NSMutableArray *decks = [NSMutableArray new];
    
    if (!_context) {
        NSLog(@"context is null, meaning that the Core Data stack is misconfigured. Evaluate immediately.");
        return decks;
    }
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Deck"];
    decks = [[_context executeFetchRequest:request error:nil] mutableCopy];
    
    return decks;
}

/// Retrieves the corresponding `Deck` associated with the specified `deckID`.
///
/// - Parameter deckID: An `NSManagedObjectID` representing the ID of the deck to be returned.
///
/// - Returns: Either the `Deck` in its entirety if it's known by the context, a fault that represents a `Deck` otherwise, or `nil` if there is an exception.
///
/// - SeeAlso: [objectWithID](https://developer.apple.com/documentation/coredata/nsmanagedobjectcontext/1506197-objectwithid)
- (Deck *)getDeckByID:(NSManagedObjectID *)deckID {
    Deck *deck;
    
    if (!_context) {
        NSLog(@"_context is null, meaning that the Core Data stack is misconfigured. Evaluate immediately.");
        return nil;
    }
    
    deck = [_context objectWithID:deckID];
    return deck;
}

#pragma mark - Card-related methods

/// Retrieves the `Card`s associated with the currently selected `Deck` through the `"contains"` relationship.
///
/// - Parameter deckID: The ID of the deck to retrieve the cards from.
///
/// - Returns: An `NSMutableArray` containing either entire `Card`s if known by the context, faults that represent `Card`s otherwise, or `nil` if there is an exception.
///
/// - SeeAlso: [objectWithID](https://developer.apple.com/documentation/coredata/nsmanagedobjectcontext/1506197-objectwithid)
- (NSMutableArray *)getCardsForDeckWithID: (NSManagedObjectID *)deckID {
    NSMutableArray *cards = [NSMutableArray new];
    Deck *selectedDeck = [self getDeckByID:deckID];
    
    if (!selectedDeck) {
        NSLog(@"selectedDeck is null, meaning that the currently selected deck is abnormal. Evaluate immediately.");
        return cards;
    }
    if (!_context) {
        NSLog(@"_context is null, meaning that the Core Data stack is misconfigured. Evaluate immediately.");
        return cards;
    }
    
    NSArray *cardIDs = [selectedDeck objectIDsForRelationshipNamed:@"contains"];
    for (int i = 0; i < cardIDs.count; i++) {
        [cards addObject:[_context objectWithID:cardIDs[i]]];
    }
    
    return cards;
}

@end
