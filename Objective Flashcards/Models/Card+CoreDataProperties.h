//
//  Card+CoreDataProperties.h
//  Objective Flashcards
//
//  Created by Arash on 2/4/24.
//
//

#import "Card+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Card (CoreDataProperties)

+ (NSFetchRequest<Card *> *)fetchRequest NS_SWIFT_NAME(fetchRequest());

@property (nullable, nonatomic, copy) NSString *frontText;
@property (nullable, nonatomic, copy) NSString *backText;
@property (nullable, nonatomic, retain) Deck *memberOf;

@end

NS_ASSUME_NONNULL_END
