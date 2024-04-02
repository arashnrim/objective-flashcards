//
//  Card+CoreDataProperties.m
//  Objective Flashcards
//
//  Created by Arash on 2/4/24.
//
//

#import "Card+CoreDataProperties.h"

@implementation Card (CoreDataProperties)

+ (NSFetchRequest<Card *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Card"];
}

@dynamic frontText;
@dynamic backText;
@dynamic memberOf;

@end
