//
//  Deck+CoreDataProperties.m
//  Objective Flashcards
//
//  Created by Arash on 2/4/24.
//
//

#import "Deck+CoreDataProperties.h"

@implementation Deck (CoreDataProperties)

+ (NSFetchRequest<Deck *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Deck"];
}

@dynamic deckTitle;
@dynamic deckDescription;
@dynamic contains;

@end
