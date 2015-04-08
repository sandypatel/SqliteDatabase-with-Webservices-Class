#import "DBHandler.h"
static DBHandler *sharedInstance = nil;
@implementation DBHandler
{
    NSFileManager *fileManager;
}
+(DBHandler*)getSharedInstance{
    if (!sharedInstance) {
        sharedInstance = [[super allocWithZone:NULL]init];
        [sharedInstance checkDBAndCopy];
    }
    return sharedInstance;
}
-(id)init{
    self = [super init];
    if(self){
        arrData = [[NSMutableArray alloc]init];
        dicData = [[NSMutableDictionary alloc]init];
    }
    return self;
}
-(void)checkDBAndCopy{
    
    NSArray *dirPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    
    NSString *connectionPath = [dirPath objectAtIndex:0];
    
    strDBPath = [connectionPath stringByAppendingPathComponent:@"SecurityVaultDB.sqlite"];
    
    NSLog(@"%@",strDBPath);
    
    fileManager = [[NSFileManager alloc]init];
    
    if (![fileManager fileExistsAtPath:strDBPath]) {
        
        NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"SecurityVaultDB.sqlite"];
        
        [fileManager copyItemAtPath:databasePathFromApp toPath:strDBPath error:nil];
        
        //NSLog(@"%@",databasePathFromApp);
        
    }
}
-(BOOL)insertData:(NSString*)query
{
    BOOL isSuccess = NO;
    
    [self checkDBAndCopy];
    
    if (sqlite3_open([strDBPath UTF8String], &contactDB)==SQLITE_OK)
    {
        
        sqlite3_stmt *statement=nil;
        
        if (sqlite3_prepare_v2(contactDB, [query UTF8String], -1, &statement, nil)==SQLITE_OK) {
            
            sqlite3_step(statement);
            isSuccess =YES;
            
        }sqlite3_finalize(statement);
        
    }
    sqlite3_close(contactDB);
    
    return isSuccess;
}
-(BOOL)DeleteRecord:(NSString *)query{
    
    BOOL isSuccess = NO;
    
    [self checkDBAndCopy];
    
    if (sqlite3_open([strDBPath UTF8String], &contactDB)==SQLITE_OK) {
        
        sqlite3_stmt *compileStatement;
        
        //sqlite3_bind_text(saveStmt, 1, [dateString UTF8String] , -1, SQLITE_TRANSIENT)
        
        if (sqlite3_prepare_v2(contactDB, [query UTF8String], -1, &compileStatement, NULL)==SQLITE_OK) {
            
            sqlite3_step(compileStatement);
            isSuccess = YES;
        }
        sqlite3_finalize(compileStatement);
        
    }
    sqlite3_close(contactDB);
    
    return isSuccess;
}
- (NSMutableArray *)GetAlarmDetails:(NSString *)query
{
    [arrData removeAllObjects];
    [self checkDBAndCopy];
    if (sqlite3_open([strDBPath UTF8String], &contactDB)==SQLITE_OK) {
        
        sqlite3_stmt *stmt;
        
        if (sqlite3_prepare_v2(contactDB, [query UTF8String], -1, &stmt, NULL)==SQLITE_OK) {
            while (sqlite3_step(stmt)==SQLITE_ROW) {
                dicData =[[NSMutableDictionary alloc]init];
                [dicData setObject:[NSString stringWithFormat:@"%s",sqlite3_column_text(stmt, 0)]forKey:@"ID"];
                [dicData setObject:[NSString stringWithFormat:@"%s",sqlite3_column_text(stmt, 1)]forKey:@"AlarmTime"];
                [dicData setObject:[NSString stringWithFormat:@"%s",sqlite3_column_text(stmt, 2)]forKey:@"Active"];
                [dicData setObject:[NSString stringWithFormat:@"%s",sqlite3_column_text(stmt, 3)]forKey:@"SnoozeTime"];
                [arrData addObject:dicData];
            }
        }
        sqlite3_finalize(stmt);
    }
    sqlite3_close(contactDB);
    
    return arrData;
    dicData=nil;
}
- (NSMutableArray *)GetBedDetails:(NSString *)query
{
    [arrData removeAllObjects];
    [self checkDBAndCopy];
    if (sqlite3_open([strDBPath UTF8String], &contactDB)==SQLITE_OK) {
        
        sqlite3_stmt *stmt;
        
        if (sqlite3_prepare_v2(contactDB, [query UTF8String], -1, &stmt, NULL)==SQLITE_OK) {
            while (sqlite3_step(stmt)==SQLITE_ROW) {
                dicData =[[NSMutableDictionary alloc]init];
                [dicData setObject:[NSString stringWithFormat:@"%s",sqlite3_column_text(stmt, 0)]forKey:@"ID"];
                [dicData setObject:[NSString stringWithFormat:@"%s",sqlite3_column_text(stmt, 1)]forKey:@"BadTime"];
                [dicData setObject:[NSString stringWithFormat:@"%s",sqlite3_column_text(stmt, 2)]forKey:@"WakeUpTime"];
                [arrData addObject:dicData];
            }
        }
        sqlite3_finalize(stmt);
    }
    sqlite3_close(contactDB);
    
    return arrData;
    dicData=nil;
}
- (NSMutableArray *)GetTimeFormat:(NSString *)query
{
    [arrData removeAllObjects];
    dicData=nil;
    [self checkDBAndCopy];
    if (sqlite3_open([strDBPath UTF8String], &contactDB)==SQLITE_OK) {
        
        sqlite3_stmt *stmt;
        
        if (sqlite3_prepare_v2(contactDB, [query UTF8String], -1, &stmt, NULL)==SQLITE_OK) {
            while (sqlite3_step(stmt)==SQLITE_ROW) {
                dicData =[[NSMutableDictionary alloc]init];
                [dicData setObject:[NSString stringWithFormat:@"%s",sqlite3_column_text(stmt, 0)]forKey:@"ID"];
                [dicData setObject:[NSString stringWithFormat:@"%s",sqlite3_column_text(stmt, 1)]forKey:@"Format"];
                [dicData setObject:[NSString stringWithFormat:@"%s",sqlite3_column_text(stmt, 2)]forKey:@"SoundName"];
                [arrData addObject:dicData];
            }
        }
        sqlite3_finalize(stmt);
    }
    sqlite3_close(contactDB);
    return arrData;
}
-(BOOL)CheckDataFromDB:(NSString *)query{
    
    BOOL Success=NO;
    //  [self checkDBAndCopy];
    
    if (sqlite3_open([strDBPath UTF8String], &contactDB)==SQLITE_OK) {
        
        sqlite3_stmt *complieStmt;
        
        if (sqlite3_prepare_v2(contactDB, [query UTF8String], -1, &complieStmt, NULL)==SQLITE_OK) {
            
            while (sqlite3_step(complieStmt)==SQLITE_ROW) {
                Success = YES;
            }
        }
        
        sqlite3_finalize(complieStmt);
        
    }
    sqlite3_close(contactDB);
    
    return Success;
    
}
@end
