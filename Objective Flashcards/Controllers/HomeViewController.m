//
//  ViewController.m
//  Objective Flashcards
//
//  Created by Arash on 29/3/24.
//

#import "HomeViewController.h"
#import "../Views/DeckTableViewCell.h"
#import "../AppDelegate.h"
#import "Deck+CoreDataClass.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Encourages the app to have large titles where possible
    self.navigationController.navigationBar.prefersLargeTitles = YES;
    
    // Sets the delegate and data source of the table view to the VC
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // Creates height spacing for each row
    self.tableView.estimatedRowHeight = 180;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    // Adds a button at the top right with an alert to create a deck
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:@"New Deck" style:UIBarButtonItemStylePlain target:self action:@selector(createDecks)];
    self.navigationItem.rightBarButtonItem = button;
}

-(NSMutableArray *)getDecks {
    NSMutableArray *decks;
    
    NSManagedObjectContext *context = ((AppDelegate *)UIApplication.sharedApplication.delegate).persistentContainer.viewContext;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Deck"];
    decks = [[context executeFetchRequest:request error:nil] mutableCopy];
    
    return decks;
}

-(void)createDecks {
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:@"New Desk"
                                message:@"What would you like to call your desk, and what's it about?"
                                preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Deck name";
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Deck description";
    }];
    
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *actionCreate = [UIAlertAction actionWithTitle:@"Create" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // TODO: Add functionality here
        
        NSManagedObjectContext *context = ((AppDelegate *)UIApplication.sharedApplication.delegate).persistentContainer.viewContext;
        Deck *newDeck = [[Deck alloc] initWithContext:context];
        
        UITextField *textFieldDeckTitle = alert.textFields[0];
        UITextField *textFieldDescriptionTitle = alert.textFields[1];
        newDeck.deckTitle = textFieldDeckTitle.text;
        newDeck.deckDescription = textFieldDescriptionTitle.text;
        
        [context save:nil];
        [self.tableView reloadData];
        NSLog(@"Created deck with title \"%@\" and description \"%@\".", textFieldDeckTitle.text, textFieldDescriptionTitle.text);
    }];
    
    [alert addAction:actionCancel];
    [alert addAction:actionCreate];
    
    [self presentViewController:alert animated:YES completion:nil];
}

// Determines the number of rows to fill in the table view. A required implementation under UITableViewDataSource.
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self getDecks].count;
}

// Returns the table cell at the index specified. A required implementation under UITableView.
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DeckTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    cell.labelTitle.text = ((Deck *)[self getDecks][indexPath.row]).deckTitle;
    cell.labelDescription.text = ((Deck *)[self getDecks][indexPath.row]).deckDescription;
    
    return cell;
}

// Handles the event when users tap the row at the index specified.
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: Handle flashcard deck selection
}


@end
