//
//  Deck+CoreDataProperties.h
//  Objective Flashcards
//
//  Created by Arash on 2/4/24.
//
//

#import "Deck+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Deck (CoreDataProperties)

+ (NSFetchRequest<Deck *> *)fetchRequest NS_SWIFT_NAME(fetchRequest());

@property (nullable, nonatomic, copy) NSString *deckTitle;
@property (nullable, nonatomic, copy) NSString *deckDescription;
@property (nullable, nonatomic, retain) Card *contains;

@end

NS_ASSUME_NONNULL_END
