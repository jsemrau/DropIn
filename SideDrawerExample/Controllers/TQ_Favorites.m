//
//  TQ_Favorites.m
//  dropin
//
//  Created by tenqyu on 24/10/16.
//  Copyright © 2016 tenqyu. All rights reserved.
//

#import "TQ_Favorites.h"
#import "MMDrawerBarButtonItem.h"

@interface TQ_Favorites ()

@end

@implementation TQ_Favorites

@synthesize favEventsAll,likedIDs,likesTable, likedArray;

-(void) viewWillAppear:(BOOL)animated{
    
    [self setupLeftMenuButton];
    [self.navigationController setHidesNavigationBarHairline:YES];
    
    [self.likesTable setDataSource:self];
    self.likesTable.delegate = self;
    self.likesTable = likesTable;
    
    self.likesTable.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    /* Set delegate for empty data source */
    //self.likesTable.emptyDataSetSource = self;
    //self.likesTable.emptyDataSetDelegate = self;
    
     [self.navigationController setHidesNavigationBarHairline:YES];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Loop over the favourited list
    //extract the matching events
    //this means you won't
    
    NSUserDefaults *prefs;
    
    prefs= [NSUserDefaults standardUserDefaults];
    self.likedIDs=[[prefs objectForKey:@"likedItems"] mutableCopy];
    
    NSLog(@"data %lu", (unsigned long)[likedIDs count]);
    
    NSMutableArray *data= [[NSMutableArray alloc] initWithCapacity:[self.likedIDs count]];
    
    for (NSMutableDictionary *event in self.favEventsAll){
        
            [data addObject:event];
        
    }
    
    NSLog(@"data %@", favEventsAll);
    
    self.likedArray = [[NSArray alloc] initWithArray:data];
    
    [self.likesTable reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be likedIDs.
}

- (void)setupLeftMenuButton {
    
    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton];
}

- (void)leftDrawerButtonPress:(id)leftDrawerButtonPress {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}


#pragma mark UITableView Methods

/*- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
 {
 return 60;
 }*/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView

{
    // Return the number of sections.
    return 1;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    static NSString *CellIdentifier = @"favCell";
    
    favCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        //cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        // More initializations if needed.
        
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"favCell" owner:self options:nil];
        
        for(id currentObject in topLevelObjects)
        {
            if([currentObject isKindOfClass:[favCell class]])
            {
                cell = (favCell *)currentObject;
                break;
            }
        }
    }
    
    
    
    cell.contentMode=UIViewContentModeScaleAspectFill;
    
    
    
   NSDictionary *text=[self.likedArray objectAtIndex:indexPath.row];
   cell.title.text=[text objectForKey:@"title"];
   cell.desc.text=[text objectForKey:@"description"];
    
   return cell;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //   NSLog(@"Number of games %lu",(unsigned long)[self.gameList count]);
    
    if ( [self.likedArray count]==0) {
        
        return 0;
        
    } else {
        
       return [self.likedArray count];
        
    }
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // Goto details view
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    TQ_EventDetailsViewController *eventDetails = [storyboard instantiateViewControllerWithIdentifier:@"EVENT_DETAILS"];
    
    
    NSMutableDictionary *text=[self.likedArray objectAtIndex:indexPath.row];
    
    eventDetails.handOver=text;
    
    [self.navigationController pushViewController:eventDetails animated:YES];
    
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
