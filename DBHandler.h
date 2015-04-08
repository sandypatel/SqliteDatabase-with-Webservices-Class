#import <Foundation/Foundation.h>
#import <sqlite3.h>
@interface DBHandler : NSObject
{
    sqlite3 *contactDB;
    
    NSString *strDBPath;
    NSMutableArray *arrData;
    NSMutableDictionary *dicData;
}
+(DBHandler*)getSharedInstance;
-(void)checkDBAndCopy;

-(BOOL)insertData:(NSString*)query;
-(BOOL)CheckDataFromDB:(NSString *)query;
-(BOOL)DeleteRecord:(NSString *)query;

-(NSMutableArray *)GetAlarmDetails:(NSString *)query;
- (NSMutableArray *)GetBedDetails:(NSString *)query;
- (NSMutableArray *)GetTimeFormat:(NSString *)query;
@end
