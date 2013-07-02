  //
//  AppDataManager.m
//  BanBu
//
//  Created by 17xy on 12-8-3.
//
//

#import "AppDataManager.h"
#import "AppCommunicationManager.h"
#import "BanBu_SmileLabel.h"
#import "BanBu_AppDelegate.h"
#import "BanBu_ChatViewController.h"
#import "CJSONSerializer.h"
#import "NSDictionary_JSONExtensions.h"
#import <CommonCrypto/CommonDigest.h>
#import "CJSONDeserializer.h"
#import "BanBu_MyFriendViewController.h"
#define DataBasePath  [DataCachePath stringByAppendingPathComponent:@"data.db"]
@interface AppDataManager()

-(void)createMusic;
@end
@implementation AppDataManager
@synthesize regDic = _regDic;
@synthesize loginid = _loginid;
@synthesize nearBuddys=_nearBuddys;
@synthesize nearDos = _nearDos;
@synthesize zibarString = _zibarString;
@synthesize deep=_deep;
@synthesize isSend=_isSend;
@synthesize LanguageDateString=_LanguageDateString;
@synthesize dateString=_dateString;
@synthesize blackString=_blackString;
@synthesize languageDictionary=_languageDictionary;
@synthesize ballTalk=_ballTalk;
@synthesize Messagetype=_Messagetype;
@synthesize unLoginArr=_unLoginArr;
@synthesize emiNameArr=_emiNameArr;
@synthesize emiLanguageArr=_emiLanguageArr;
@synthesize isSee=_isSee;
@synthesize agreeList=_agreeList;
@synthesize time=_time;
@synthesize talkArr=_talkArr;
@synthesize isPlay=_isPlay;
@synthesize playert=_playert;
@synthesize boolArr=_boolArr;

static AppDataManager *sharedAppDataManager = nil;

-(NSString *)theRevisedName:(NSString*)oldname andUID:(NSString *)uid{
    NSString *output = [NSString string];

    NSMutableDictionary *uidDic = [NSMutableDictionary dictionaryWithDictionary:[UserDefaults valueForKey:MyAppDataManager.useruid]];
    NSArray *renameArr = [NSArray arrayWithArray:[uidDic valueForKey:@"renameflist"]];
    for(NSDictionary *renameDic in renameArr){
        if([[renameDic valueForKey:@"friendid"] isEqualToString:uid]){
            output = [renameDic valueForKey:@"fname"];
            break;
        }
    }
    return ![output isEqualToString:@""]?output:oldname;
}


 #warning 加入全局的异常断点后，导致player出错。

-(void)createMusic
{
//    NSLog(@"%@",_musicName);
   if(![[[[UserDefaults valueForKey:MyAppDataManager.useruid] valueForKey:@"settings"] valueForKey:@"MusicSwith"] length]){
        return;
   }else{
       MyAppDataManager.musicName = [[[UserDefaults valueForKey:MyAppDataManager.useruid] valueForKey:@"settings"] valueForKey:@"MusicSwith"];
   }
    NSString *path=[[NSBundle mainBundle]pathForResource:_musicName ofType:@"mp3"];
    
  if(player)
  {
      [player release];
      
      player=nil;
  
  }
    NSError *musicError;
    
    player=[[AVAudioPlayer alloc]initWithData:[NSData dataWithContentsOfFile:path] error:&musicError];
    
    [player prepareToPlay];
    
    player.volume=1.0;
    
    [player play];
    
}

-(NSString *)IsMinGanWord:(NSString *)input
{
    if(!input)
    {
        input=@"";
        
        return nil;
    }
    
    NSMutableString *change=[[[NSMutableString alloc]initWithString:input] autorelease];
    
    NSArray *stringArr=[MyAppDataManager.blackString componentsSeparatedByString:@","];

    for(int k=0;k<[stringArr count];k++)
    {
        NSRange range=[input rangeOfString:[stringArr objectAtIndex:k]];
        
        if(range.length==0)
        {
            continue;
            
        }else{
            
            NSMutableString *string=[[[NSMutableString alloc]init] autorelease];
            
            for(int i=0;i<range.length;i++)
            {
                
                [string appendString:@"*"];
                
                
            }
            
            [change replaceCharactersInRange:range withString:string];
            
            input=[NSString stringWithString:change];
            
            k=0;
            
            // input=[input substringFromIndex:range.length];
        }
        
        
    }
    
    NSString *output=[NSString stringWithString:change];
    return output;
}

//国际语言
-(NSString *)IsInternationalLanguage:(NSString *)input
{
    
//    NSLog(@"%@",input);
//    NSLog(@"%@",MyAppDataManager.languageDictionary);
    NSString *langauage=[self getPreferredLanguage];
    
    if(!input)
    {
        input=@"";
        
        return nil;
    }
    
    if([langauage isEqual:@"zh-Hans"])
    {
        NSMutableDictionary *chineseDictionary=[[MyAppDataManager.languageDictionary objectForKey:@"language"] objectForKey:@"cn"];
        
        NSArray *keyArr=[chineseDictionary allKeys];
        
        for(int i=0;i<[keyArr count];i++)
        {
            NSString *key=[keyArr objectAtIndex:i];
            
            NSRange range=[input rangeOfString:key];
            
            if(range.length==0)
                continue;
            
            NSString *value=[chineseDictionary valueForKey:[keyArr objectAtIndex:i]];
            
            input=[input stringByReplacingOccurrencesOfString:key withString:value];
            
        }
        
        NSString *outstring=[NSString stringWithString:input];
        
        return outstring;
//        return [chineseDictionary valueForKey:input];
        
    }
    else if ([langauage isEqual:@"ja"])
    {
        
        NSMutableDictionary *chineseDictionary=[[MyAppDataManager.languageDictionary objectForKey:@"language"] objectForKey:@"jp"];
        
        NSArray *keyArr=[chineseDictionary allKeys];
        
        for(int i=0;i<[keyArr count];i++)
        {
            NSString *key=[keyArr objectAtIndex:i];
            
            NSString *value=[chineseDictionary valueForKey:[keyArr objectAtIndex:i]];
            
            input=[input stringByReplacingOccurrencesOfString:key withString:value];
            
        }
        
        NSString *outstring=[NSString stringWithString:input];
        return outstring;
        
    }
    else
    {
        NSMutableDictionary *chineseDictionary=[[MyAppDataManager.languageDictionary objectForKey:@"language"] objectForKey:@"en"];
        
        NSArray *keyArr=[chineseDictionary allKeys];
        for(int i=0;i<[keyArr count];i++)
        {
            NSString *key=[keyArr objectAtIndex:i];
            
            NSString *value=[chineseDictionary valueForKey:[keyArr objectAtIndex:i]];
            input=[input stringByReplacingOccurrencesOfString:key withString:value];
        }
        NSString *outstring=[NSString stringWithString:input];
        return outstring;
        
    }
    
    
}

-(NSString*)getPreferredLanguage
{
    
    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
    NSArray* languages = [defs objectForKey:@"AppleLanguages"];
    NSString* preferredLang = [languages objectAtIndex:0];
    return preferredLang;
}

/*
// 这是返回字符串
const  static  NSString* (^e_tt)(NSString *)=^(NSString *str)
{
    
    return BanBu_release(str);
    
};

// 这是返回构造表的 表名
const static  NSString * (^bindString)(NSString *,NSString *)=^(NSString *a,NSString *b)
{    NSString *u=[NSString stringWithFormat:@"tabel_%@_%@",a,b];
    
     return BanBu_release(u);
};
 
 void (^insertDataForItemandUid)(id,NSString*,NSString*)=^(id data,NSString *itemName,NSString *uid)
 {
 if([itemName isEqual:DIALOGS])
 {
 
 }
 
 };
 

*/

NSString *(^bindLink)(NSString *,NSString *)=^(NSString *itemName,NSString *UID)
{

    return itemName;
};

- (void)initRaysource
{
    
    _regDic = [[NSMutableDictionary alloc]initWithCapacity:20];
    _cellRowMapDic = [[NSMutableDictionary alloc]initWithCapacity:20];
    _nearBuddys = [[NSMutableArray alloc] initWithCapacity:10];
    _nearDos = [[NSMutableArray alloc] initWithCapacity:10];
    _contentArr = [[NSMutableArray alloc]initWithCapacity:10];
    _dialogs = [[NSMutableArray alloc] initWithCapacity:10];
    _friends = [[NSMutableArray alloc] initWithCapacity:10];
    _friendsDos = [[NSMutableArray alloc] initWithCapacity:10];
    _friendViewList= [[NSMutableArray alloc] initWithCapacity:10];
    _talkPeoples = [[NSMutableArray alloc] initWithCapacity:10];
    _zibarString = nil;
    
    _readArr=[[NSMutableArray alloc]initWithCapacity:10];
    
    _playBall=[[NSMutableArray alloc]initWithCapacity:10];
    
    _ballTalk=[[NSMutableArray alloc]initWithCapacity:10];
    
    _isSend=NO;
    
    _languageDictionary=[[NSMutableDictionary alloc]initWithCapacity:10];
    
    _Messagetype=MessageTypeStand;
    
    _keyArr=[[NSMutableArray alloc]initWithCapacity:10];
    
    _valueArr=[[NSMutableArray alloc]initWithCapacity:10];
    
    _messageRadioDictionary=[[NSMutableDictionary alloc]init];
    
    _unLoginArr=[[NSMutableArray alloc]initWithCapacity:10];
    
    _boolArr=[[NSMutableArray alloc]initWithCapacity:10];
    
    _emiNameArr=[[NSMutableArray alloc]initWithObjects:@"打怪兽",@"嘟嘟嘴",@"多变",@"饿了",@"高兴",@"歌王",@"好烦啊",@"加油",@"惊讶",@"可爱",@"可怜",@"麦霸",@"怒火",@"饶命",@"撒娇",@"睡觉",@"痛苦",@"羞羞脸",@"阴谋",@"眨眼",@"发大财",@"喷饭",@"炸飞了",@"凄凉",@"T台秀",@"读书",@"扭屁股",@"舞蹈",@"得意",@"运动",@"救命",@"滚远点",@"江南舞",@"走你", nil];
    
    _emiLanguageArr=[[NSMutableArray alloc]initWithObjects:NSLocalizedString(@"smileItem", nil),NSLocalizedString(@"smileItem1", nil),NSLocalizedString(@"smileItem2", nil),NSLocalizedString(@"smileItem3", nil),NSLocalizedString(@"smileItem4", nil),NSLocalizedString(@"smileItem5", nil),NSLocalizedString(@"smileItem6", nil),NSLocalizedString(@"smileItem7", nil),NSLocalizedString(@"smileItem8", nil),NSLocalizedString(@"smileItem9", nil),NSLocalizedString(@"smileItem10", nil),NSLocalizedString(@"smileItem12", nil),NSLocalizedString(@"smileItem13", nil),NSLocalizedString(@"smileItem15", nil),NSLocalizedString(@"smileItem16", nil),NSLocalizedString(@"smileItem17", nil),NSLocalizedString(@"smileItem19", nil),NSLocalizedString(@"smileItem20", nil),NSLocalizedString(@"smileItem22", nil),NSLocalizedString(@"smileItem23", nil),NSLocalizedString(@"smileItem24", nil),NSLocalizedString(@"smileItem25", nil),NSLocalizedString(@"smileItem26", nil),NSLocalizedString(@"smileItem27", nil),NSLocalizedString(@"smileItem28", nil),NSLocalizedString(@"smileItem29", nil),NSLocalizedString(@"smileItem30", nil),NSLocalizedString(@"smileItem31", nil),NSLocalizedString(@"smileItem32", nil),NSLocalizedString(@"smileItem33", nil),NSLocalizedString(@"smileItem34", nil),NSLocalizedString(@"smileItem35", nil),NSLocalizedString(@"smileItem36", nil),NSLocalizedString(@"smileItem37", nil), nil];
    
    _agreeList=[[NSMutableArray alloc]initWithCapacity:10];
    
    _talkArr=[[NSMutableArray alloc]initWithCapacity:10];
    
    
   
    if(![FileManager fileExistsAtPath:DataCachePath])
        [FileManager createDirectoryAtPath:DataCachePath withIntermediateDirectories:NO attributes:nil error:nil];
    
    _dataBase = [[FMDatabase alloc] initWithPath:DataBasePath];
    if(![_dataBase open])
    {
        [_dataBase close];
        _dataBase = nil;
    }
}

// 这是关闭聊天的公共接收

+ (AppDataManager *)sharedAppDataManager;
{
    @synchronized(self){
        if(sharedAppDataManager == nil){
            sharedAppDataManager = [[[self alloc] init] autorelease];
            [sharedAppDataManager initRaysource];
        }
    }
    return sharedAppDataManager;
}

-(void)setMessagetype:(MessageType)Messagetype
{
  if(Messagetype==_Messagetype)
      return;

    _Messagetype=Messagetype;
    
}


-(NSString *)getTableNameForUid:(NSString *)uid
{
    return [NSString stringWithFormat:@"table_%@_%@",self.useruid,uid];

   // return bindString(self.useruid,uid);

}


//初始化talkPeople1127表
-(void)initTalkPeopleDB{
    if(![_dataBase goodConnection])
        [_dataBase open];
    if(![_dataBase tableExists:TALKPEOPLES])
    {
        NSDictionary *queryDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                  DBFieldType_TEXT,    KeyFromUid,
                                  DBFieldType_TEXT,    KeyUface,
                                  DBFieldType_TEXT,    KeyUname,
                                  DBFieldType_TEXT,    KeyAge,
                                  DBFieldType_BOOL,    KeySex,
                                  
                                  DBFieldType_TEXT,    KeyContent,
                                  DBFieldType_TEXT,    KeyStime,
                                  DBFieldType_INTEGER, KeyUnreadNum,
                                  DBFieldType_INTEGER,    KeyType,
                                  DBFieldType_TEXT,    KeyCompany,
                                  
                                  DBFieldType_TEXT,    KeyHbody,
                                  DBFieldType_TEXT,    KeyJobtitle,
                                  DBFieldType_TEXT,    KeyLiked,
                                  DBFieldType_TEXT,    KeyLovego,
                                  DBFieldType_TEXT,    KeySayme,
                                  
                                  DBFieldType_TEXT,    KeySchool,
                                  DBFieldType_TEXT,    KeySstar,
                                  DBFieldType_TEXT,    KeyWbody,
                                  DBFieldType_TEXT,    KeyXblood,
                                  DBFieldType_TEXT,    KeyDtime,
                                  
                                  DBFieldType_TEXT,    KeyDmeter,
                                  DBFieldType_TEXT,    KeyFacelist,
                                  DBFieldType_BOOL,    KeyMe,
                                  DBFieldType_INTEGER, KeyStatus,
                                  nil];
        
        
        
        NSString *queryCreateTable = [NSString stringWithFormat:@"CREATE TABLE %@ (%@, PRIMARY KEY(userid ASC))",TALKPEOPLES,[self getPar1StrFromDic:queryDic]];
        BOOL f = [_dataBase executeUpdate:queryCreateTable];
        NSString *queryIndex = [NSString stringWithFormat:@"CREATE INDEX _userid ON %@(stime);",TALKPEOPLES];
        BOOL ff = [_dataBase executeUpdate:queryIndex];
        if(!(ff && f))
        {
            NSLog(@"创建失败!");
        }
        
    }
}

//不存在该人，就插入表内
-(BOOL)initTalkPeopleOne:(NSDictionary *)people{
    NSLog(@"疯了啊%@",people);
    if(![_dataBase goodConnection])
        [_dataBase open];
    
    NSString *uid = [people valueForKey:KeyFromUid];
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE userid=%@",TALKPEOPLES,uid];
    FMResultSet *rs = [_dataBase executeQuery:query];
    BOOL new = YES;
    while ([rs next]){
        new = NO;
    }
    if(new){
//        NSLog(@"创建initTalkPeopleOne");
        //            [self insertData:people forItem:TALKPEOPLES forUid:uid];
        NSString *query = [NSString stringWithFormat:@"INSERT INTO %@ (userid,uface,pname,oldyears,sex,content,stime,unreadnum,type,company,hbody,jobtitle,liked,lovego,sayme,school,sstar,wbody,xblood,ltime,dmeter,facelist,me,status) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",TALKPEOPLES];
        
        
        NSDictionary *amsgDic = [NSDictionary dictionaryWithDictionary:[[people valueForKey:@"msglist"] lastObject]];
        
        NSDictionary *saysDic=[AppComManager getAMsgFrom64String:[amsgDic valueForKey:KeySays]];
        NSLog(@"%@",saysDic);
        
        NSString *facelistJson = [[CJSONSerializer serializer] serializeArray: VALUE(KeyFacelist, people)];
        BOOL isMan=[VALUE(KeyGender, people)isEqual:@"m"];
        NSArray *mapArr = [NSArray arrayWithObjects:@"text",@"image",@"location",@"sound",@"emi",nil];
        NSInteger msgType = [mapArr indexOfObject:VALUE(KeyType, saysDic)];
   
        
        NSLog(@"INSERT INTO %@ (userid,uface,pname,oldyears,sex,content,stime,unreadnum,type,company,hbody,jobtitle,liked,lovego,sayme,school,sstar,wbody,xblood,ltime,dmeter,facelist,me,status) VALUES (%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@)",TALKPEOPLES,
              VALUE(KeyFromUid, people),
              VALUE(KeyUface, people),
              VALUE(KeyUname, people),
              VALUE(KeyAge, people),
              [NSNumber numberWithBool:isMan],
              VALUE(KeyLasttalk, saysDic),
              VALUE(KeyStime, amsgDic),
              [NSNumber numberWithInt:0], //keynumber
              [NSNumber numberWithInteger:msgType], //消息类型 （0~4 : text、image、location、sound、emi）
              VALUE(KeyCompany, people),
              VALUE(KeyHbody, people),
              VALUE(KeyJobtitle, people),
              VALUE(KeyLiked, people),
              VALUE(KeyLovego, people),
              VALUE(KeySayme, people),
              VALUE(KeySchool, people),
              VALUE(KeySstar, people),
              VALUE(KeyWbody, people),
              VALUE(KeyXblood, people),
              VALUE(KeyDtime, people),
              VALUE(KeyDmeter, people),
              facelistJson,
              VALUE(KeyMe, people),//  keyme ：别人发的是0；我发的是1
              VALUE(KeyStatus, people)
              );
        
        BOOL s = [_dataBase executeUpdate:query,
                  VALUE(KeyFromUid, people),
                  VALUE(KeyUface, people),
                  VALUE(KeyUname, people),
                  VALUE(KeyAge, people),
                  [NSNumber numberWithBool:isMan],
                  VALUE(KeyLasttalk, saysDic),
                  VALUE(KeyStime, amsgDic),
                  [NSNumber numberWithInt:0], //keynumber
                  [NSNumber numberWithInteger:msgType], //消息类型 （0~4 : text、image、location、sound、emi）
                  VALUE(KeyCompany, people),
                  VALUE(KeyHbody, people),
                  VALUE(KeyJobtitle, people),
                  VALUE(KeyLiked, people),
                  VALUE(KeyLovego, people),
                  VALUE(KeySayme, people),
                  VALUE(KeySchool, people),
                  VALUE(KeySstar, people),
                  VALUE(KeyWbody, people),
                  VALUE(KeyXblood, people),
                  VALUE(KeyDtime, people),
                  VALUE(KeyDmeter, people),
                  facelistJson,
                  VALUE(KeyMe, people),//  keyme ：别人发的是0；我发的是1
                  VALUE(KeyStatus, people)   //ChatStatus：ChatStatusNone
                  ];
        NSLog(@"要不要整儿高啊%@",[saysDic valueForKey:KeyContent]);
        if(!s)
        {
            NSLog(@"database action error:%@",[[_dataBase lastError] description]);
            new = NO;
        }        
    }
 
    return new;

}

//更新表talkPeople1127的人（更新所有字段）
-(void)writeToTalkPeopleOne:(NSDictionary *)dataDic{
    if(![_dataBase goodConnection])
        [_dataBase open];
   
    NSDictionary *amsgDic = [NSDictionary dictionaryWithDictionary:[[dataDic valueForKey:@"msglist"] lastObject]];
    NSDictionary *saysDic=[AppComManager getAMsgFrom64String:[amsgDic valueForKey:KeySays]];
    NSString *facelistJson = [[CJSONSerializer serializer] serializeArray: VALUE(KeyFacelist, dataDic)];
    BOOL isMan=[VALUE(KeyGender, dataDic)isEqual:@"m"];
    NSArray *mapArr = [NSArray arrayWithObjects:@"text",@"image",@"location",@"sound",@"emi",nil];
    NSInteger msgType = [mapArr indexOfObject:VALUE(KeyType, saysDic)];
    NSLog(@"%d",msgType);
    NSString *query = [NSString stringWithFormat:@"UPDATE %@ SET uface=?,pname=?,oldyears=?,sex=?,content=?,stime=?,unreadnum= unreadnum + ?,type=?,company=?,hbody=?,jobtitle=?,liked=?,lovego=?,sayme=?,school=?,sstar=?,wbody=?,xblood=?,ltime=?,dmeter=?,facelist=?,me=?,status=? WHERE userid=?",TALKPEOPLES];

    BOOL s = [_dataBase executeUpdate:query,
              VALUE(KeyUface, dataDic),
              VALUE(KeyUname, dataDic),
              VALUE(KeyAge, dataDic),
              [NSNumber numberWithBool:isMan],
              VALUE(KeyContent, saysDic),
              VALUE(KeyStime, amsgDic),
              [NSNumber numberWithInt:[[dataDic valueForKey:KeyMsglist] count]], //keynumber
              [NSNumber numberWithInteger:msgType],
              VALUE(KeyCompany, dataDic),
              VALUE(KeyHbody, dataDic),
              VALUE(KeyJobtitle, dataDic),
              VALUE(KeyLiked, dataDic),
              VALUE(KeyLovego, dataDic),
              VALUE(KeySayme, dataDic),
              VALUE(KeySchool, dataDic),
              VALUE(KeySstar, dataDic),
              VALUE(KeyWbody, dataDic),
              VALUE(KeyXblood, dataDic),
              VALUE(KeyDtime, dataDic),
              VALUE(KeyDmeter, dataDic),
              facelistJson,
              [NSNumber numberWithBool:NO],//  keyme ：别人发的是0；我发的是1
              [NSNumber numberWithInt:4],   //ChatStatus：ChatStatusNone
              [dataDic valueForKey:KeyFromUid]
              ];
    if(!s)
    {
        NSLog(@"database action error:%@",[[_dataBase lastError] description]);
        
    }
    NSLog(@"UPDATE %@ SET uface='%@',pname='%@',oldyears='%@',sex=%@,content='%@',stime='%@',unreadnum=%@,type='%@',company='%@',hbody='%@',jobtitle='%@',liked='%@',lovego='%@',sayme='%@',school='%@',sstar='%@',wbody='%@',xblood='%@',ltime='%@',dmeter='%@',facelist='%@',me=%@,status=%@ WHERE userid='%@'",TALKPEOPLES,
          VALUE(KeyUface, dataDic),
          VALUE(KeyUname, dataDic),
          VALUE(KeyAge, dataDic),
          [NSNumber numberWithBool:isMan],VALUE(KeyContent, saysDic),
          VALUE(KeyStime, amsgDic),
          [NSNumber numberWithInt:[[dataDic valueForKey:KeyMsglist] count]], //keynumber
          [NSNumber numberWithInteger:msgType],
          VALUE(KeyCompany, dataDic),
          VALUE(KeyHbody, dataDic),
          VALUE(KeyJobtitle, dataDic),
          VALUE(KeyLiked, dataDic),
          VALUE(KeyLovego, dataDic),
          VALUE(KeySayme, dataDic),
          VALUE(KeySchool, dataDic),
          VALUE(KeySstar, dataDic),
          VALUE(KeyWbody, dataDic),
          VALUE(KeyXblood, dataDic),
          VALUE(KeyDtime, dataDic),
          VALUE(KeyDmeter, dataDic),
          facelistJson,
          [NSNumber numberWithBool:NO],//  keyme ：别人发的是0；我发的是1
          [NSNumber numberWithInt:4],
          VALUE(KeyFromUid, dataDic));

}

//在点对点接受消息时，要更新对话列表中该人的最后一条消息content和发出时间，谁发的keyme、消息的状态（发送中、送达、失败），此处局部更新
-(void)setTalkPeopleOne:(NSDictionary *)updataDic{
     
    if(![_dataBase goodConnection])
        [_dataBase open];
    //漏掉了keytype，添上了。
    NSString *query = [NSString stringWithFormat:@"UPDATE %@ SET content=?,stime=?,me=?,status=?,type=? WHERE (userid=?);",TALKPEOPLES];
    NSLog(@"疯了啊UPDATE %@ SET content=%@,stime=%@,me=%@,status=%@,type=%@ WHERE (userid=%@);",TALKPEOPLES,[updataDic valueForKey:@"content"],[updataDic valueForKey:@"stime"],[NSNumber numberWithBool:[[updataDic valueForKey:@"me"] integerValue]],[NSNumber numberWithInt:[[updataDic valueForKey:@"status"] integerValue]],[NSNumber numberWithInt:[[updataDic valueForKey:KeyType] integerValue]],[updataDic valueForKey:@"userid"]);
    BOOL s = [_dataBase executeUpdate:query,
              [updataDic valueForKey:@"content"],
              [updataDic valueForKey:@"stime"],
              [NSNumber numberWithBool:[[updataDic valueForKey:@"me"] integerValue]],
              [NSNumber numberWithInt:[[updataDic valueForKey:@"status"] integerValue]],
              [NSNumber numberWithInt:[[updataDic valueForKey:KeyType] integerValue]],
              [updataDic valueForKey:@"userid"]
              ];
    if(!s)
    {
        NSLog(@"database action error:%@",[[_dataBase lastError] description]);
        
    }
    
    
    
}

//全局接受消息时，写入多人多条消息
-(void)writeToTalkPeopleDB:(NSArray *)dataArr{//人和消息的数组
    
    [self initTalkPeopleDB];

    for(NSDictionary *people in dataArr)
    {
        //不靠谱的数目为0
        /*NSString *query = [NSString stringWithFormat:@"SELECT COUNT(*) AS _VALUE FROM %@ WHERE userid=%@",TALKPEOPLES,uid];
         FMResultSet *rs = [_dataBase executeQuery:@"SELECT COUNT(*) AS _value FROM talkPeoples10158 WHERE (userid=1270);"];
         NSString * count = [rs stringForColumn:@"_value"];
         if(count){
         //count = 1;
         //                    [self updateData:amsg forItem:TALKPEOPLES forUid:nil];
         }else{
         //count = 0；
         //                        [amsg setValue:uid forKey:KeyFromUid];
         //                        [amsg setValue:[NSNumber numberWithInteger:1] forKey:KeyUnreadNum];
         
         [self insertData:people forItem:TALKPEOPLES forUid:uid];
         }
         */
        NSMutableDictionary *changPeople = [NSMutableDictionary dictionaryWithDictionary:people];
        [changPeople setValue:[NSNumber numberWithBool:NO] forKey:KeyMe];
        [changPeople setValue:[NSNumber numberWithInteger:ChatStatusNone] forKey:KeyStatus];
        NSLog(@"%@",changPeople);
        [self initTalkPeopleOne:changPeople];

//        BOOL isUpdate = [self initTalkPeopleOne:changPeople];
        //全局接受消息时有此人了，就需要更新
//        if(isUpdate){
            [self writeToTalkPeopleOne:changPeople];
//        }
        //写入聊天记录表是必须的（一、多条消息均可）
        [self writeToDialogDB:changPeople];

    }
}


//初始化tabel_1127_??????表
-(void)initDialogDB:(NSString *)touid{
    
    if(![_dataBase goodConnection])
        [_dataBase open];
    
    NSString *tableName = [self getTableNameForUid:touid];
    if(![_dataBase tableExists:tableName])
    {
        NSDictionary *queryDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                  DBFieldType_TEXT,    KeyChatid,
                                  DBFieldType_INTEGER, KeyID,
                                  DBFieldType_TEXT,    KeyContent,
                                  DBFieldType_BOOL,    KeyMe,
                                  DBFieldType_INTEGER, KeyStatus,
                                  DBFieldType_INTEGER, KeyType,
                                  DBFieldType_INTEGER, KeyHeight,
                                  DBFieldType_TEXT,    KeyStime,
                                  DBFieldType_BOOL,    KeyShowtime,
                                  DBFieldType_TEXT,    KeyUface,
                                  DBFieldType_INTEGER, KeyMediaStatus,
                                  DBFieldType_TEXT,    KeyShowFrom,
                                  nil];
        
        NSString *query = [NSString stringWithFormat:@"CREATE TABLE %@ (%@ , PRIMARY KEY(chatid ASC))",tableName,[self getPar1StrFromDic:queryDic]];
        NSLog(@"%@",query);
        BOOL ff = [_dataBase executeUpdate:query];

        if(!ff)
        {
            NSLog(@"创建失败!");
         }
    }
  
}

-(void)writeToDialogOne:(NSDictionary *)aMsg andToUid:(NSString *)touid{
    NSLog(@"%@",aMsg);
    [self initDialogDB:touid];
    NSString *tableName = [self getTableNameForUid:touid];
    NSString *dialogQuery = [NSString stringWithFormat:@"INSERT INTO %@ (chatid,ID,content,me,status,type,height,stime,showtime,uface,mediastatus,msgfrom) VALUES (?,?,?,?,?,?,?,?,?,?,?,?)",tableName];
    NSDictionary *aChat = [NSDictionary dictionaryWithDictionary:aMsg];
     //处理消息，高度、来自、状态等等
    
    NSInteger msgType =  [VALUE(KeyType, aMsg) integerValue];
    CGFloat height = 0;
    // 这里是稿时间的
    
    BOOL showFrom=![VALUE(KeyShowFrom, aMsg) isEqual:@"mo"];
    
    if(msgType == ChatCellTypeText)
        height = [BanBu_SmileLabel heightForText:[MyAppDataManager IsInternationalLanguage:VALUE(KeyContent, aMsg)]]+2*CellMarge+TimeLabelHeight;
    else if(msgType == ChatCellTypeImage)
        height = ImageTypeHeight+2*CellMarge+TimeLabelHeight;
    else if(msgType == ChatCellTypeLocation)
        height = locationTypeHeight+2*CellMarge+TimeLabelHeight;
    
    else if(msgType==ChatCellTypeEmi)
        height = ImageTypeHeight+2*CellMarge+TimeLabelHeight;
    else
        height = VoiceTypeHeight+2*CellMarge+TimeLabelHeight;
    
    height=height+(showFrom?18:0);
    
    if(msgType==ChatCellTypeVoice||msgType==ChatCellTypeImage)
    {
        height=height+(showFrom?8:0);
        
    }
#warning 显示发送消息的时间
    BOOL showTime = YES;
    // 获取当前时间
    //        static int k=0;
    //        //                    NSLog(@"%d",k);
    //        [UserDefaults setValue:VALUE(KeyStime, aChat) forKey:[self UserDefautsKey:k]];
    //        [self.dialogs removeAllObjects];
    //        [self readMoreDataForCurrentDialog:DefaultReadNum];
    //         if(!self.dialogs.count)
    //        {
    //            k=0;
    //        }
    //
    //        if(k==0){
    //            showTime = YES;
    //        }
    //        else{
    //
    //            //                        NSLog(@"%@------%@",[self UserDefautsKey:k],[self UserDefautsKey:k-1]);
    //            BOOL isShow=[self fiveMinuteLater:[UserDefaults valueForKey:[self UserDefautsKey:k]] beforeTime:[UserDefaults valueForKey:[self UserDefautsKey:k-1]]];
    //
    //            showTime = isShow;
    //
    //            [UserDefaults  removeObjectForKey:[self UserDefautsKey:k-1]];
    //            if(!isShow){
    //                height = height - TimeLabelHeight;
    //
    //            }
    //        }
    //        k++;
 
    NSLog(@"INSERT INTO %@ (chatid,ID,content,me,status,type,height,stime,showtime,uface,mediastatus,msgfrom) VALUES (%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@)",tableName,VALUE(KeyChatid, aChat),[NSNumber numberWithInt:0],VALUE(KeyContent, aMsg),[NSNumber numberWithBool:YES],[NSNumber numberWithInt:ChatStatusSending],[NSNumber numberWithInteger:msgType],[NSNumber numberWithInteger:height],VALUE(KeyStime, aChat),[NSNumber numberWithBool:showTime],VALUE(KeyUface, aChat),[NSNumber numberWithInteger:MediaStatusNormal],VALUE(KeyShowFrom, aMsg));
    BOOL s1 = [_dataBase executeUpdate:dialogQuery,
               VALUE(KeyChatid, aChat),
               [NSNumber numberWithInt:0],//VALUE(KeyID, aChat),
               VALUE(KeyContent, aMsg),
               [NSNumber numberWithBool:YES],  //keyme ：别人发的是0；我发的是1
               [NSNumber numberWithInt:ChatStatusSending],   //ChatStatus：ChatStatusNone
               [NSNumber numberWithInteger:msgType],//VALUE(KeyType, saysDic),
               [NSNumber numberWithInteger:height],//VALUE(KeyHeight, aChat),
               VALUE(KeyStime, aChat),
               [NSNumber numberWithBool:showTime],//VALUE(KeyShowtime, aChat),
               VALUE(KeyUface, aChat),
               [NSNumber numberWithInteger:MediaStatusNormal],//VALUE(KeyMediaStatus, aChat),
               VALUE(KeyShowFrom, aMsg)];
    if(!s1){
        NSLog(@"database action error:%@",[[_dataBase lastError] description]);
    
}

}

//单纯为了更改上传文件后，服务器返回的url。（只更新KeyContent）
-(void)setDialogOne:(NSDictionary *)aMsg andToUid:(NSString *)touid{
    
    NSString *tableName = [self getTableNameForUid:touid];
    NSString *dialogsOneQuery = [NSString stringWithFormat:@"UPDATE %@ SET content=? WHERE chatid=?",tableName];
    NSLog(@"aaaaaaUPDATE %@ SET content=%@ WHERE chatid=%@",tableName,VALUE(KeyContent, aMsg),[aMsg valueForKey:KeyChatid]);
    BOOL s1 = [_dataBase executeUpdate:dialogsOneQuery,
               VALUE(KeyContent, aMsg),
               [aMsg valueForKey:KeyChatid]
               ];
    if(!s1){
        NSLog(@"更新一条聊天记录的内容database action error:%@",[[_dataBase lastError] description]);
    }
}

//写入多条信息，传入的参数需要带有个人资料。
-(NSArray *)writeToDialogDB:(NSDictionary *)people{
    
    [self initDialogDB:[people valueForKey:KeyFromUid]];
    NSMutableArray *cellDataArr = [NSMutableArray array];
    //一次插入一个人的全部聊天记录
    NSDictionary *dataDic = [NSDictionary dictionaryWithDictionary:people];
    NSArray *dataArr = [NSArray arrayWithArray:[dataDic valueForKey:KeyMsglist]];
    NSString *tableName = [self getTableNameForUid:[people valueForKey:KeyFromUid]];
    NSMutableString *dialogsQuery = [NSMutableString stringWithFormat:@"INSERT INTO %@ (chatid,ID,content,me,status,type,height,stime,showtime,uface,mediastatus,msgfrom) ",tableName];
    for(int i=0;i<dataArr.count;i++)
    {
        NSDictionary *aChat = [NSDictionary dictionaryWithDictionary:[dataArr objectAtIndex:i]];
        NSDictionary *saysDic=[AppComManager getAMsgFrom64String:[aChat valueForKey:KeySays]];
        //处理消息，高度、来自、状态等等
        
        
        NSArray *mapArr = [NSArray arrayWithObjects:@"text",@"image",@"location",@"sound",@"emi",nil];
        NSInteger msgType = [mapArr indexOfObject:VALUE(KeyType, saysDic)];
        CGFloat height = 0;
        NSInteger mediaStatus = MediaStatusNormal;
        // 这里是稿时间的
        
        BOOL showFrom=![VALUE(KeyShowFrom, saysDic) isEqual:@"mo"];
        
        if(msgType == ChatCellTypeText)
            height = [BanBu_SmileLabel heightForText:[MyAppDataManager IsInternationalLanguage:VALUE(KeyContent, saysDic)]]+2*CellMarge+TimeLabelHeight;
        else if(msgType == ChatCellTypeImage)
            height = ImageTypeHeight+2*CellMarge+TimeLabelHeight;
        else if(msgType == ChatCellTypeLocation)
            height = locationTypeHeight+2*CellMarge+TimeLabelHeight;
        
        else if(msgType==ChatCellTypeEmi)
            height = ImageTypeHeight+2*CellMarge+TimeLabelHeight;
        else
            height = VoiceTypeHeight+2*CellMarge+TimeLabelHeight;
        
        height=height+(showFrom?18:0);
        
        if(msgType==ChatCellTypeVoice||msgType==ChatCellTypeImage)
        {
            height=height+(showFrom?8:0);
            mediaStatus = MediaStatusDownload;//下载

        }
        
        
#warning 显示发送消息的时间
        BOOL showTime = YES;
        // 获取当前时间
        //        static int k=0;
        //        //                    NSLog(@"%d",k);
        //        [UserDefaults setValue:VALUE(KeyStime, aChat) forKey:[self UserDefautsKey:k]];
        //        [self.dialogs removeAllObjects];
        //        [self readMoreDataForCurrentDialog:DefaultReadNum];
        //         if(!self.dialogs.count)
        //        {
        //            k=0;
        //        }
        //
        //        if(k==0){
        //            showTime = YES;
        //        }
        //        else{
        //
        //            //                        NSLog(@"%@------%@",[self UserDefautsKey:k],[self UserDefautsKey:k-1]);
        //            BOOL isShow=[self fiveMinuteLater:[UserDefaults valueForKey:[self UserDefautsKey:k]] beforeTime:[UserDefaults valueForKey:[self UserDefautsKey:k-1]]];
        //
        //            showTime = isShow;
        //
        //            [UserDefaults  removeObjectForKey:[self UserDefautsKey:k-1]];
        //            if(!isShow){
        //                height = height - TimeLabelHeight;
        //
        //            }
        //        }
        //        k++;
        
        [dialogsQuery appendFormat:@"SELECT '%@',%@,'%@',%@,%@,'%@',%@,'%@',%@,'%@',%@,'%@'      UNION ALL ",
         VALUE(KeyChatid, aChat),
         [NSNumber numberWithInt:0],//VALUE(KeyID, aChat),
         VALUE(KeyContent, saysDic),
         [NSNumber numberWithBool:NO],  //keyme ：别人发的是0；我发的是1
         [NSNumber numberWithInt:4],   //ChatStatus：ChatStatusNone
         [NSNumber numberWithInteger:msgType],//VALUE(KeyType, saysDic),
         [NSNumber numberWithInteger:height],//VALUE(KeyHeight, aChat),
         VALUE(KeyStime, aChat),
         [NSNumber numberWithBool:showTime],//VALUE(KeyShowtime, aChat),
         VALUE(KeyUface, dataDic),
         [NSNumber numberWithInteger:mediaStatus],//VALUE(KeyMediaStatus, aChat),
         VALUE(KeyShowFrom, saysDic)];
        
        //包装cell的数据字典
        [cellDataArr addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                VALUE(KeyChatid, aChat),KeyChatid,
                                [NSNumber numberWithInt:0],KeyID,
                                VALUE(KeyContent, saysDic),KeyContent,
                                [NSNumber numberWithBool:NO],KeyMe,
                                [NSNumber numberWithInt:4],KeyStatus,
                                [NSNumber numberWithInteger:msgType],KeyType,
                                [NSNumber numberWithInteger:height],KeyHeight,
                                VALUE(KeyStime, aChat),KeyStime,
                                [NSNumber numberWithBool:showTime],KeyShowtime,
                                VALUE(KeyUface, dataDic),KeyUface,
                                [NSNumber numberWithInteger:mediaStatus],KeyMediaStatus,
                                VALUE(KeyShowFrom, saysDic),KeyShowFrom,nil]];
        
        
    }
    [dialogsQuery deleteCharactersInRange:NSMakeRange(dialogsQuery.length-12-1,12)];

    NSLog(@"________________+++++++++++++++++++++++%@",dialogsQuery);
    BOOL s1 = [_dataBase executeUpdate:dialogsQuery];
    if(!s1){
        NSLog(@"database action error:%@",[[_dataBase lastError] description]);
        
    }

    return cellDataArr;
    
}

//更改一条消息的状态（发送中->送达（或者失败）->已读）
-(void)setStatusOfOne:(NSDictionary *)statuDic{
    //更新对话列表的人和这条聊天记录
    NSInteger chatstatus = 0;
    if([[statuDic valueForKey:@"status"] isEqualToString:@"fail"]){
        chatstatus = ChatStatusSendFail;
    }else if([[statuDic valueForKey:@"status"] isEqualToString:@"s"]){//s:送达
        chatstatus = ChatStatusSent;
    }else if([[statuDic valueForKey:@"status"] isEqualToString:@"r"]){//r:已读
        chatstatus = ChatStatusReaded;
        //            NSLog(@"为啥要读呢。。。。。。。");
    }else if([[statuDic valueForKey:@"status"] isEqualToString:@"none"]){
        chatstatus = ChatStatusNone;
    }
    NSLog(@"----一条的消息状态%d",chatstatus);
    //ChatStatusSent= 2；
    NSString *talkPeopleOneQuery = [NSString stringWithFormat:@"UPDATE %@ SET status=? WHERE (userid=?)",TALKPEOPLES];

//    NSString *talkPeopleOneQuery = [NSString stringWithFormat:@"UPDATE %@ SET status=? WHERE (userid=?) AND (status = 2) ",TALKPEOPLES];
    
    BOOL s = [_dataBase executeUpdate:talkPeopleOneQuery,
              [NSNumber numberWithInt:chatstatus],
              [statuDic valueForKey:@"touid"]
              ];
    if(!s)
    {
        NSLog(@"更新对话列表的状态失败database action error:%@",[[_dataBase lastError] description]);
        
    }
    NSString *tableName = [self getTableNameForUid:[statuDic valueForKey:@"touid"]];
    NSString *dialogsOneQuery = [NSString stringWithFormat:@"UPDATE %@ SET status=?,mediastatus=? WHERE chatid=?",tableName];
    NSLog(@"aaaaaaUPDATE %@ SET status=%@,mediastatus=%@ WHERE (chatid=%@) AND (me=1);",tableName,[NSNumber numberWithInteger:chatstatus],VALUE(KeyMediaStatus, statuDic),[statuDic valueForKey:KeyChatid]);
    BOOL s1 = [_dataBase executeUpdate:dialogsOneQuery,
               [NSNumber numberWithInteger:chatstatus],
               VALUE(KeyMediaStatus, statuDic),
               [statuDic valueForKey:KeyChatid]
               ];
    if(!s1){
        NSLog(@"更新一条聊天记录的状态失败database action error:%@",[[_dataBase lastError] description]);
    }

}

//更改对话列表和聊天记录中的送达状态为已读
-(void)setStatusOfAll:(NSArray *)statusList{
    
    if(![_dataBase tableExists:TALKPEOPLES]){
        return;
    }
    for(NSDictionary * onePeople in statusList){
        //        NSArray *statusArr = [NSArray arrayWithObjects:@"fail",@"s",@"sending",@"r",@"none", nil];
        //更新对话列表的状态
        NSInteger chatstatus = 0;
        if([[onePeople valueForKey:@"status"] isEqualToString:@"fail"]){
            chatstatus = ChatStatusSendFail;
        }else if([[onePeople valueForKey:@"status"] isEqualToString:@"s"]){//s:送达
            chatstatus = ChatStatusSent;
        }else if([[onePeople valueForKey:@"status"] isEqualToString:@"sending"]){
            chatstatus = ChatStatusSending;
        }else if([[onePeople valueForKey:@"status"] isEqualToString:@"r"]){//r:已读
            chatstatus = ChatStatusReaded;
            //            NSLog(@"为啥要读呢。。。。。。。");
            
        }else if([[onePeople valueForKey:@"status"] isEqualToString:@"none"]){
            chatstatus = ChatStatusNone;
        }
        NSLog(@"----我的消息状态%d",chatstatus);
        NSString *query = [NSString stringWithFormat:@"UPDATE %@ SET status=? WHERE (userid=?) AND (status = 1)",TALKPEOPLES];
        
        BOOL s = [_dataBase executeUpdate:query,
                  [NSNumber numberWithInt:chatstatus],
                  [onePeople valueForKey:@"touid"]
                  ];
        if(!s)
        {
            NSLog(@"更新对话列表的状态失败database action error:%@",[[_dataBase lastError] description]);
            
        }
        
        if(chatstatus == ChatStatusReaded){
            //更新聊天记录的状态,要先找出最后一条keyme = 0的
            NSString *tableName = [self getTableNameForUid:[onePeople valueForKey:@"touid"]];
            if(![_dataBase tableExists:tableName]){
                continue;
            }
            
            NSString *query1 = [NSString stringWithFormat:@"UPDATE %@ SET status=3 WHERE (me=1) AND (status=1);",tableName];
            
            BOOL s1 = [_dataBase executeUpdate:query1];
            
            if(!s1)
            {
                NSLog(@"database action error:%@",[[_dataBase lastError] description]);
                
            }

        }
                
        
        
    }
    
    
    
}


//更新对话列表和多条聊天记录的状态（只有已读是多条的）（这个好像有bug）
//-(void)setStatusOfAll:(NSArray *)statusList{
//    
//    if(![_dataBase tableExists:TALKPEOPLES]){
//        return;
//    }
//    for(NSDictionary * onePeople in statusList){
//        //        NSArray *statusArr = [NSArray arrayWithObjects:@"fail",@"s",@"sending",@"r",@"none", nil];
//        //更新对话列表的状态
//        NSInteger chatstatus = 0;
//        if([[onePeople valueForKey:@"status"] isEqualToString:@"fail"]){
//            chatstatus = ChatStatusSendFail;
//        }else if([[onePeople valueForKey:@"status"] isEqualToString:@"s"]){//s:送达
//            chatstatus = ChatStatusSent;
//            return;
//        }else if([[onePeople valueForKey:@"status"] isEqualToString:@"sending"]){
//            chatstatus = ChatStatusSending;
//        }else if([[onePeople valueForKey:@"status"] isEqualToString:@"r"]){//r:已读
//            chatstatus = ChatStatusReaded;
////            NSLog(@"为啥要读呢。。。。。。。");
//
//        }else if([[onePeople valueForKey:@"status"] isEqualToString:@"none"]){
//            chatstatus = ChatStatusNone;
//        }
//        NSLog(@"----我的消息状态%d",chatstatus);
//        NSString *query = [NSString stringWithFormat:@"UPDATE %@ SET status=? WHERE (userid=?) AND (status = 1)",TALKPEOPLES];
//        
//        BOOL s = [_dataBase executeUpdate:query,
//                  [NSNumber numberWithInt:chatstatus],
//                  [onePeople valueForKey:@"touid"]
//                  ];
//        if(!s)
//        {
//            NSLog(@"更新对话列表的状态失败database action error:%@",[[_dataBase lastError] description]);
//            
//        }
//        //更新聊天记录的状态,要先找出最后一条keyme = 0的
//        NSString *tableName = [self getTableNameForUid:[onePeople valueForKey:@"touid"]];
//        if(![_dataBase tableExists:tableName]){
////            NSLog(@"真的退出了。。。。。。。");
//            continue;
//        }
//        NSString *maxChatid= [NSString stringWithFormat:@"SELECT MAX(chatid) AS _value FROM %@ WHERE me=0;",tableName];
//        NSLog(@"%@",maxChatid);
//        FMResultSet *rs = [_dataBase executeQuery:maxChatid];
//        NSString * chatid = nil;
//
//        while ([rs next]) {
//            if([[rs stringForColumn:@"_value"]length]){
//                chatid =[NSString stringWithFormat:@"%@",[rs stringForColumn:@"_value"]];
//                
//            }else{
//                NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
//                [formatter setLocale:[NSLocale currentLocale]];
//                [formatter setLocale:[NSLocale currentLocale]];
//                [formatter setDateFormat:@"yyMMdd-HHmmss-00000000"];
//                chatid = [formatter stringFromDate:[NSDate date]];
//                
//            }
//        }
//       
//        
//        NSString *query1 = [NSString stringWithFormat:@"UPDATE %@ SET status=? WHERE (chatid>?) AND (me=1) ;",tableName];
//        
//        BOOL s1 = [_dataBase executeUpdate:query1,
//                   [NSNumber numberWithInt:chatstatus],
//                   chatid
//                   ];
//        
//        if(!(s && s1))
//        {
//            NSLog(@"database action error:%@",[[_dataBase lastError] description]);
//            
//        }
//        
//
//    
//    }
// 
//
//
//}

-(void)setUnreadNumber:(NSInteger)number With:(NSString *)userid;
{
    NSString *query = [NSString stringWithFormat:@"UPDATE %@ SET unreadnum=? WHERE (userid=?);",TALKPEOPLES];
    BOOL s = [_dataBase executeUpdate:query,
              [NSNumber numberWithInt:number],
              userid
              ];
    if(!s)
    {
        NSLog(@"database action error:%@",[[_dataBase lastError] description]);
        
    }

}

////获取最大的chatid，没有就默认生成一个
-(NSString *)searchMaxChatid:(NSString *)chatuid{
    
    if(![_dataBase goodConnection])
        [_dataBase open];
    
    NSString *query = [NSString stringWithFormat:@"SELECT MAX(chatid) AS _value FROM %@",[MyAppDataManager getTableNameForUid:chatuid]];
    NSLog(@"%@",query);
    FMResultSet *rs = [_dataBase executeQuery:query];
    NSString * chatid = nil;

    while ([rs next]) {
        NSLog(@"%@",[rs stringForColumn:@"_value"]);
        if([[rs stringForColumn:@"_value"]length]){
            
            chatid =[NSString stringWithFormat:@"%@",[rs stringForColumn:@"_value"]];
            if([chatid rangeOfString:@"."].location == NSNotFound){
                chatid = [chatid stringByAppendingString:@".1000"];
            }else{
                NSArray *arr = [NSArray arrayWithArray:[chatid componentsSeparatedByString:@"."]];
                chatid = [NSString stringWithFormat:@"%@.%d",[arr objectAtIndex:0],[[arr objectAtIndex:1] intValue]+1];
                NSLog(@"%@",arr);
            }
            NSLog(@"行不行啊，%@",chatid);
        }
        else{
            //当聊天记录为空的时候，需要给指定一个chatid
            NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
            [formatter setLocale:[NSLocale currentLocale]];
            [formatter setLocale:[NSLocale currentLocale]];
            [formatter setDateFormat:@"yyMMdd-HHmmss-00000000"];
            chatid = [formatter stringFromDate:[NSDate date]];
            
        }

    }
     

    return chatid;
}

//删除一条聊天记录
-(void)deleteDialogOne:(NSDictionary *)amsg{
    
    if(![_dataBase goodConnection])
        [_dataBase open];
    NSString *tableName = [self getTableNameForUid:VALUE(KeyUid, amsg)];
    
    NSLog(@"DELETE FROM %@ WHERE chatid=%@",tableName,VALUE(KeyChatid, amsg));

    if(![_dataBase tableExists:tableName])
    {
        [_dataBase close];
        return;
    }
    NSString *query = [NSString stringWithFormat:@"DELETE FROM %@ WHERE chatid=?",tableName];
    NSLog(@"DELETE FROM %@ WHERE chatid=%@",tableName,VALUE(KeyChatid, amsg));
    BOOL s = [_dataBase executeUpdate:query,VALUE(KeyChatid, amsg)];
    if(!s)
    {
        NSLog(@"删除一条聊天记录database action error:%@",[[_dataBase lastError] description]);
    }
  

}
//清空一个人的所有聊天记录
-(void)deleteDialogAll:(NSString *)userID{
    if(![_dataBase goodConnection])
        [_dataBase open];
    NSString *tableName = [self getTableNameForUid:userID];
    if(![_dataBase tableExists:tableName])
    {
        [_dataBase close];
        return;
    }
    
    NSString *query = [NSString stringWithFormat:@"DELETE FROM %@;",tableName];
  
    BOOL s = [_dataBase executeUpdate:query];
    if(!s)
    {
        NSLog(@"database action error:%@",[[_dataBase lastError] description]);
        
    }
    
 
}
//删除一个人及其聊天记录表
-(void)deleteTalkPeople:(NSArray *)peopleArr{
    
    if(![_dataBase goodConnection])
        [_dataBase open];
    if(peopleArr.count){
        
        NSString *query = [NSString stringWithFormat:@"DELETE FROM %@ WHERE userid=?",TALKPEOPLES];
        
        for(NSDictionary *one in peopleArr)
        {
            NSLog(@"DELETE FROM %@ WHERE userid=%@",TALKPEOPLES,VALUE(KeyFromUid, one));
            BOOL s = [_dataBase executeUpdate:query,VALUE(KeyFromUid, one)];
            if(!s)
            {
                NSLog(@"database action error:%@",[[_dataBase lastError] description]);
                
            }else{
                //对话列表的人删除成功后，删除聊天记录表
                [self removeTableNamed:[self getTableNameForUid:[one valueForKey:KeyFromUid]]];
            }
            
           
        }

    }
   
}

- (void)removeTableNamed:(NSString *)tableName
{
    if(![_dataBase goodConnection])
        [_dataBase open];
    [_dataBase executeUpdate:[NSString stringWithFormat:@"DROP TABLE IF EXISTS %@",tableName] withArgumentsInArray:nil];
}

#warning 通过用户的id，取出talkarr和dialogs

- (NSMutableArray *)readMoreDataForCurrentDialogFromUid:(NSString *)_uid :(NSInteger)readNum
{
    NSInteger fromIndex = AllData;
    /******************************************/
    //    [_dialogs removeAllObjects];
    /****************************************/
    
    if(![_dataBase goodConnection])
    {
        if(![_dataBase open])
            return NO;
    }
    
    NSString *tableName = [self getTableNameForUid:_uid];
    
    if(![_dataBase tableExists:tableName])
    {
        [_dataBase close];
        return NO;
    }
    if(readNum == AllData)
    {
        NSString *query = [NSString stringWithFormat:@"SELECT * FROM %@",tableName];
        FMResultSet *rs = [_dataBase executeQuery:query];
        
        NSMutableArray *newMsgs = [NSMutableArray arrayWithCapacity:1];
        while ([rs next]) {
            NSDictionary *amsg = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [NSNumber numberWithInteger:[rs intForColumn:KeyID]],     KeyID,
                                  [MyAppDataManager IsInternationalLanguage:[rs stringForColumn:KeyContent]],                          KeyContent,
                                  [NSNumber numberWithBool:[rs boolForColumn:KeyMe]],       KeyMe,
                                  [NSNumber numberWithInteger:[rs intForColumn:KeyStatus]], KeyStatus,
                                  [NSNumber numberWithInteger:[rs intForColumn:KeyType]],   KeyType,
                                  [NSNumber numberWithInteger:[rs intForColumn:KeyHeight]], KeyHeight,
                                  [rs stringForColumn:KeyStime],                            KeyStime,
                                  [NSNumber numberWithBool:[rs boolForColumn:KeyShowtime]], KeyShowtime,
                                  [rs stringForColumn:KeyUface],                            KeyUface,
                                  [NSNumber numberWithInteger:[rs intForColumn:KeyMediaStatus]],KeyMediaStatus,
                                  [rs stringForColumn:KeyShowFrom],                         KeyShowFrom,
                                  nil];
            [newMsgs addObject:amsg];
            
        }
        return newMsgs;
    }
    else
    {
        NSLog(@"************************************************************%@",tableName);
        NSString *query = [NSString stringWithFormat:@"SELECT ID FROM %@ WHERE ID=(SELECT MAX(ID) FROM %@)",tableName,tableName];
        fromIndex =[_dataBase intForQuery:query];
        
        NSInteger toIndex = (fromIndex>19)?(fromIndex-readNum):0;
        NSLog(@"%d",toIndex);
        query = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE ID BETWEEN ? AND ?",tableName];
        
        FMResultSet *rs = [_dataBase executeQuery:query,[NSNumber numberWithInteger:toIndex],[NSNumber numberWithInteger:fromIndex]];
        NSMutableArray *newMsgs = [NSMutableArray arrayWithCapacity:1];
        while ([rs next]) {
            NSDictionary *amsg = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [NSNumber numberWithInteger:[rs intForColumn:KeyID]],     KeyID,
                                  [MyAppDataManager IsInternationalLanguage:[rs stringForColumn:KeyContent]],                          KeyContent,
                                  [NSNumber numberWithBool:[rs boolForColumn:KeyMe]],       KeyMe,
                                  [NSNumber numberWithInteger:[rs intForColumn:KeyStatus]], KeyStatus,
                                  [NSNumber numberWithInteger:[rs intForColumn:KeyType]],   KeyType,
                                  [NSNumber numberWithInteger:[rs intForColumn:KeyHeight]], KeyHeight,
                                  [rs stringForColumn:KeyStime],                            KeyStime,
                                  [NSNumber numberWithBool:[rs boolForColumn:KeyShowtime]], KeyShowtime,
                                  [rs stringForColumn:KeyUface],                            KeyUface,
                                  [NSNumber numberWithInteger:[rs intForColumn:KeyMediaStatus]],KeyMediaStatus,
                                  
                                  [rs stringForColumn:KeyShowFrom],                        KeyShowFrom,
                                  
                                  nil];
            [newMsgs addObject:amsg];
        }
        //        [newMsgs addObjectsFromArray:_dialogs];
        return newMsgs;
        //        self.dialogs = [NSMutableArray arrayWithArray:newMsgs];
        
    }
    return nil;
    
}


 
-(BOOL)readMoreTwentyMessage;
{
    
    if(![_dataBase goodConnection])
        [_dataBase open];
    
    NSString *tableName = [self getTableNameForUid:self.chatuid];
    int number=[_dialogs count];
    if(number == 0)
        return NO;
    
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM %@ ORDER BY chatid DESC limit 0,%d;",tableName,number+20];
    FMResultSet *rs = [_dataBase executeQuery:query];
    NSMutableArray *orialArr = [NSMutableArray array];
    while ([rs next]) {
        NSDictionary *amsg = [NSDictionary dictionaryWithObjectsAndKeys:
                              
                              [rs stringForColumn:KeyChatid],                                   KeyChatid,
                              [MyAppDataManager IsInternationalLanguage:[rs stringForColumn:KeyContent]],                   KeyContent,
                              [NSNumber numberWithBool:[rs boolForColumn:KeyMe]],               KeyMe,
                              [NSNumber numberWithInteger:[rs intForColumn:KeyStatus]],        KeyStatus,
                              [NSNumber numberWithInteger:[rs intForColumn:KeyType]],          KeyType,
                              
                              [NSNumber numberWithInteger:[rs intForColumn:KeyHeight]],        KeyHeight,
                              [MyAppDataManager currentTime:[rs stringForColumn:KeyStime]],     KeyStime,
                              [NSNumber numberWithBool:[rs boolForColumn:KeyShowtime]],         KeyShowtime,
                              [rs stringForColumn:KeyUface],                        KeyUface,
                              [NSNumber numberWithInteger:[rs intForColumn:KeyMediaStatus]],   KeyMediaStatus,
                              
                              [rs stringForColumn:KeyShowFrom],                                 KeyShowFrom,
                              nil];
        [orialArr addObject:amsg];
    }
    if(orialArr.count == number){
//        NSLog(@"%d-----%d",orialArr.count,number);
        return NO;
    }
    [_dialogs removeAllObjects];
    [_dialogs addObjectsFromArray:[[orialArr reverseObjectEnumerator] allObjects]];
    
    return YES;
}


- (void)readTalkList:(NSString *)touid WithNumber:(NSInteger)num
{
    if(![_dataBase goodConnection])
        [_dataBase open];
    if(touid){
        [self initDialogDB:touid];
        NSString *query = [NSString stringWithFormat:@"SELECT * FROM %@ ORDER BY stime DESC limit 0,%d;",[self getTableNameForUid:touid],num];
        NSLog(@"%@",query);
        FMResultSet *rs = [_dataBase executeQuery:query];
        
        [_dialogs removeAllObjects];
        NSMutableArray *orialArr = [NSMutableArray array];
        while ([rs next]) {
            NSDictionary *amsg = [NSDictionary dictionaryWithObjectsAndKeys:

                                  [rs stringForColumn:KeyChatid],                                   KeyChatid,
                                  [MyAppDataManager IsInternationalLanguage:[rs stringForColumn:KeyContent]],                   KeyContent,
                                  [NSNumber numberWithBool:[rs boolForColumn:KeyMe]],               KeyMe,
                                  [NSNumber numberWithInteger:[rs intForColumn:KeyStatus]],        KeyStatus,
                                  [NSNumber numberWithInteger:[rs intForColumn:KeyType]],          KeyType,
                                  
                                  [NSNumber numberWithInteger:[rs intForColumn:KeyHeight]],        KeyHeight,
                                  [MyAppDataManager currentTime:[rs stringForColumn:KeyStime]],     KeyStime,
                                  [NSNumber numberWithBool:[rs boolForColumn:KeyShowtime]],         KeyShowtime,
                                  [rs stringForColumn:KeyUface],                        KeyUface,
                                  [NSNumber numberWithInteger:[rs intForColumn:KeyMediaStatus]],   KeyMediaStatus,
                                  
                                  [rs stringForColumn:KeyShowFrom],                                 KeyShowFrom,
                                  nil];
            [orialArr addObject:amsg];
//            NSLog(@"%@",amsg);
        }
        [_dialogs addObjectsFromArray:[[orialArr reverseObjectEnumerator] allObjects]];
//        NSLog(@"%@",_dialogs);

    }
    else{
  
        [self initTalkPeopleDB];
        NSString *query = [NSString stringWithFormat:@"SELECT * FROM %@ ORDER BY %@ DESC",TALKPEOPLES,KeyStime];
        FMResultSet *rs = [_dataBase executeQuery:query];
        [_talkPeoples removeAllObjects];
        while ([rs next]) {

            NSInteger type = [rs intForColumn:KeyType];
            NSString *str1;
            if(type == ChatCellTypeText||type == ChatCellTypeEmi)
            {
                str1 =  [rs stringForColumn:KeyLasttalk];
            }
            else
            {
                NSArray *mapArr = [NSArray arrayWithObjects:@"text",NSLocalizedString(@"talkPicture", nil),NSLocalizedString(@"talkLocation", nil),NSLocalizedString(@"talkSound", nil),@"emi",nil];
//                NSLog(@"%d----%@",type,str1);
                if(![[rs stringForColumn:KeyLasttalk] isEqualToString:@""])
                {
                    str1 = [NSString stringWithFormat:@"%@",[mapArr objectAtIndex:type]];
                }else{
                    str1=@"";
                }
                
            }
//            NSLog(@"%d----%@",type,str1);

            NSDictionary *amsg = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [rs stringForColumn:KeyFromUid],                         KeyFromUid,
                                  [rs stringForColumn:KeyUface],                           KeyUface,
                                  [MyAppDataManager theRevisedName:[rs stringForColumn:KeyUname] andUID:[rs stringForColumn:KeyFromUid]],
                                  KeyUname,
                                  [rs stringForColumn:KeyAge],                             KeyAge,
                                  [NSNumber numberWithBool:[rs boolForColumn:KeySex]],     KeySex,
                                  
                                  [MyAppDataManager IsInternationalLanguage:str1],         KeyContent,
                                  [MyAppDataManager currentTime:[rs stringForColumn:KeyStime]],     KeyStime,
                                  [NSNumber numberWithInteger:[rs intForColumn:KeyUnreadNum]],KeyUnreadNum,
                                  [rs stringForColumn:KeyType],                            KeyType,
                                  [rs stringForColumn:KeyCompany],                         KeyCompany,
                                  
                                  [rs stringForColumn:KeyHbody],                           KeyHbody,
                                  [rs stringForColumn:KeyJobtitle],                        KeyJobtitle,
                                  [rs stringForColumn:KeyLiked],                           KeyLiked,
                                  [rs stringForColumn:KeyLovego],                          KeyLovego,
                                  [rs stringForColumn:KeySayme],                           KeySayme,
                                  
                                  [rs stringForColumn:KeySchool],                          KeySchool,
                                  [rs stringForColumn:KeySstar],                          KeySstar,
                                  [rs stringForColumn:KeyWbody],                           KeyWbody,
                                  [rs stringForColumn:KeyXblood],                          KeyXblood,
                                  [rs stringForColumn:KeyDtime],                           KeyDtime,
                                  
                                  [rs stringForColumn:KeyDmeter],                          KeyDmeter,
                                  [rs stringForColumn:KeyFacelist],                       KeyFacelist,
                                  [rs stringForColumn:KeyMe],                             KeyMe,
                                  [rs stringForColumn:KeyStatus],                         KeyStatus,
                                  nil];
            
            //            NSLog(@"%@-----%@",str1,[rs stringForColumn:KeySayme]);
            NSData *temp=[[amsg valueForKey:@"facelist"] dataUsingEncoding:NSUTF8StringEncoding];
            NSArray *arr=[[NSArray alloc]initWithArray:[[CJSONDeserializer deserializer] deserializeAsArray:temp error:nil]];
            NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithDictionary:amsg];
            [dic setValue:arr forKey:@"facelist"];
            [arr release];
            //            NSLog(@"%@-----%@",amsg,dic);
            [_talkPeoples addObject:dic];
            
        }

    }
 

    
}

-(NSDictionary *)readTalkPeopleOne:(NSString *)userid{
    
    if(![_dataBase goodConnection])
        [_dataBase open];
    
    [self initTalkPeopleDB];
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE userid=%@",TALKPEOPLES,userid];
    FMResultSet *rs = [_dataBase executeQuery:query];
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];

    while ([rs next]) {
        
        NSInteger type = [rs intForColumn:KeyType];
        NSString *str1;
        if(type == ChatCellTypeText||type == ChatCellTypeEmi)
        {
            str1 =  [rs stringForColumn:KeyLasttalk];
        }
        else
        {
            NSArray *mapArr = [NSArray arrayWithObjects:@"text",NSLocalizedString(@"talkPicture", nil),NSLocalizedString(@"talkLocation", nil),NSLocalizedString(@"talkSound", nil),@"emi",nil];
            //                NSLog(@"%d----%@",type,str1);
            if(![[rs stringForColumn:KeyLasttalk] isEqualToString:@""])
            {
                str1 = [NSString stringWithFormat:@"%@",[mapArr objectAtIndex:type]];
            }else{
                str1=@"";
            }
            
        }
        //            NSLog(@"%d----%@",type,str1);
        
        NSDictionary *amsg = [NSDictionary dictionaryWithObjectsAndKeys:
                              [rs stringForColumn:KeyFromUid],                         KeyFromUid,
                              [rs stringForColumn:KeyUface],                           KeyUface,
                              [MyAppDataManager theRevisedName:[rs stringForColumn:KeyUname] andUID:[rs stringForColumn:KeyFromUid]],
                              KeyUname,
                              [rs stringForColumn:KeyAge],                             KeyAge,
                              [NSNumber numberWithBool:[rs boolForColumn:KeySex]],     KeySex,
                              
                              [MyAppDataManager IsInternationalLanguage:str1],         KeyContent,
                              [MyAppDataManager currentTime:[rs stringForColumn:KeyStime]],     KeyStime,
                              [NSNumber numberWithInteger:[rs intForColumn:KeyUnreadNum]],KeyUnreadNum,
                              [rs stringForColumn:KeyType],                            KeyType,
                              [rs stringForColumn:KeyCompany],                         KeyCompany,
                              
                              [rs stringForColumn:KeyHbody],                           KeyHbody,
                              [rs stringForColumn:KeyJobtitle],                        KeyJobtitle,
                              [rs stringForColumn:KeyLiked],                           KeyLiked,
                              [rs stringForColumn:KeyLovego],                          KeyLovego,
                              [rs stringForColumn:KeySayme],                           KeySayme,
                              
                              [rs stringForColumn:KeySchool],                          KeySchool,
                              [rs stringForColumn:KeySstar],                          KeySstar,
                              [rs stringForColumn:KeyWbody],                           KeyWbody,
                              [rs stringForColumn:KeyXblood],                          KeyXblood,
                              [rs stringForColumn:KeyDtime],                           KeyDtime,
                              
                              [rs stringForColumn:KeyDmeter],                          KeyDmeter,
                              [rs stringForColumn:KeyFacelist],                       KeyFacelist,
                              [rs stringForColumn:KeyMe],                             KeyMe,
                              [rs stringForColumn:KeyStatus],                         KeyStatus,
                              nil];
        
        //            NSLog(@"%@-----%@",str1,[rs stringForColumn:KeySayme]);
        NSData *temp=[[amsg valueForKey:@"facelist"] dataUsingEncoding:NSUTF8StringEncoding];
        NSArray *arr=[[NSArray alloc]initWithArray:[[CJSONDeserializer deserializer] deserializeAsArray:temp error:nil]];
         [dic addEntriesFromDictionary:amsg];
        [dic setValue:arr forKey:@"facelist"];
        [arr release];
     }
    return dic;
}

- (UIImage *)imageForImageUrlStr:(NSString *)fileUrlStr
{
    NSString *filePath = [AppComManager pathForMedia:fileUrlStr];
    NSData *imageData = [NSData dataWithContentsOfFile:filePath];
    if(imageData)
        return [UIImage imageWithData:imageData];
    else
        return [UIImage imageNamed:@"defaultuser.png"];
}

-(NSData *)imageDataForImageUrlStr:(NSString *)fileUrlStr{
    NSString *filePath = [AppComManager pathForMedia:fileUrlStr];
    NSData *imageData = [NSData dataWithContentsOfFile:filePath];
    
    return imageData;
}

- (void)banbuRequestDidFinished:(NSDictionary *)resDic error:(NSError *)error
{
    //先更新数据库，再更新数据源，最后更新界面，应该都是这个套路吧
    // if([[_appChatController.profile valueForKey:KeyFromUid] isEqualToString:[resDic valueForKey:KeyUid]]) 它的作用就是：如果当前页面不是原来那个人了，就不需要更新数据源了和刷新当前界面。
    NSLog(@"%@---%@",resDic,error);
    if(error)
    {
        if(![error.domain isEqualToString:BanBuDataformatError] && [[error.userInfo valueForKey:@"fc"] isEqualToString:BanBu_SendMessage_To_Server])
        {

            //更新该条消息的状态及对话列表该人最后一条消息的状态
             NSDictionary *statuDic =  [NSDictionary dictionaryWithObjectsAndKeys:@"fail",@"status",[error.userInfo valueForKey:@"touid"],@"touid",[error.userInfo valueForKey:KeyChatid],KeyChatid,[NSNumber numberWithInteger:MediaStatusUploadFaild],KeyMediaStatus, nil];
            [self setStatusOfOne:statuDic];
 
           
            if(_appChatController &&[self.chatuid isEqualToString:[resDic valueForKey:KeyUid]])
            {

                NSInteger row = [[MyAppDataManager.cellRowMapDic valueForKey:[error.userInfo valueForKey:KeyChatid]] integerValue];
                NSMutableDictionary *amsg = [NSMutableDictionary dictionaryWithDictionary:[self.dialogs objectAtIndex:row]];
                [amsg setValue:[NSNumber numberWithInteger:ChatStatusSendFail] forKey:KeyStatus];
                [self.dialogs replaceObjectAtIndex:row withObject:amsg];
                [_appChatController.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            }
         }
        else if([[error.userInfo valueForKey:@"fc"] isEqualToString:BanBu_AllOperation_Server]){
//            [AppComManager startReceiveMsgFromUid:nil forDelegate:MyAppDataManager];

        }else if([[error.userInfo valueForKey:@"fc"] isEqualToString:BanBu_ReceiveMessage_From_Server]){
//            [AppComManager startReceiveMsgFromUid:MyAppDataManager.chatuid forDelegate:MyAppDataManager];

        }
        return;
    }

    if([[resDic valueForKey:@"ok"] boolValue])
    {
        // 接收个人 对 个人的聊天
        if([AppComManager respondsDic:resDic isFunctionData:BanBu_ReceiveMessage_From_Server])
        {
            if([[resDic valueForKey:@"statuslist"] count]){
                    //更改对话列表的已读未读的状态
                    [self setStatusOfAll:[resDic valueForKey:@"statuslist"]];
                }
    
            if([[resDic valueForKey:@"list"] count]){
                NSMutableDictionary *peopleDic = [NSMutableDictionary dictionary];
                if(_appChatController && [self.chatuid isEqualToString:[resDic valueForKey:KeyFromUidTalk]]){
                    [peopleDic addEntriesFromDictionary:_appChatController.profile];
                }else{
                    [peopleDic addEntriesFromDictionary:[self readTalkPeopleOne:[resDic valueForKey:KeyFromUidTalk]]];
                }
                [peopleDic setValue:[NSNumber numberWithBool:NO] forKey:KeyMe];
                [peopleDic setValue:[NSNumber numberWithInteger:ChatStatusNone] forKey:KeyStatus];
                [peopleDic setValue:[resDic valueForKey:@"list"] forKey:@"msglist"];
                BOOL isHavePeo = ![MyAppDataManager initTalkPeopleOne:peopleDic];
                if(isHavePeo)
                {
                    //更新对话列表该人的最后一条消息的内容、时间、状态、来源（接受的）
                    
                    
                    NSDictionary *amsgDic = [NSDictionary dictionaryWithDictionary:[[resDic valueForKey:@"list"] lastObject]];
                    
                    NSDictionary *saysDic=[AppComManager getAMsgFrom64String:[amsgDic valueForKey:KeySays]];
                    NSMutableDictionary *peoDic = [NSMutableDictionary dictionary];
                    [peoDic setValue:[saysDic valueForKey:KeyContent] forKey:KeyContent];
                    [peoDic setValue:[amsgDic valueForKey:KeyStime] forKey:KeyStime];
                    [peoDic setValue:[NSNumber numberWithInteger:ChatStatusNone] forKey:KeyStatus];
                    [peoDic setValue:[NSNumber numberWithBool:NO] forKey:KeyMe];
                    [peoDic setValue:[resDic valueForKey:KeyFromUidTalk] forKey:KeyFromUid];
                    //                        NSLog(@"%@",peoDic);
                    [self setTalkPeopleOne:peoDic];
                    
                }
                NSArray *amsgsArr = [NSArray arrayWithArray:[self writeToDialogDB:peopleDic]];
                
                if(_appChatController && [self.chatuid isEqualToString:[resDic valueForKey:KeyFromUidTalk]]){
                        
                        NSInteger rowNum = _dialogs.count;
                        [_dialogs addObjectsFromArray:amsgsArr];
                        for(int i=rowNum; i<_dialogs.count; i++){
                            [_cellRowMapDic setValue:[NSNumber numberWithInteger:i] forKey:[[amsgsArr objectAtIndex:i-rowNum] valueForKey:KeyChatid]];
                        }
                    }
               
            }

            //没找到好办法解决，把消息的状态从送到变为已读。就全部reloaddata了。
            if(_appChatController)
            {
//                NSLog(@"%@----%@",self.chatuid,)
                if([self.chatuid isEqualToString:[resDic valueForKey:KeyFromUidTalk]]){
                    //只能坑了。。。先更新数据源，在刷新
                    [self readTalkList:[_appChatController.profile valueForKey:KeyFromUid] WithNumber:_dialogs.count];
                    [_appChatController.tableView reloadData];
                    if([[resDic valueForKey:@"list"] count]){
                        [_appChatController.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dialogs.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                    }

                    //还处于点对点对话，再次请求消息
                    [AppComManager startReceiveMsgFromUid:MyAppDataManager.chatuid forDelegate:MyAppDataManager];
                }
     
            }
            else{
                //因为全局与点对点切换时，没有断掉上次的网络请求
                //可能存在信息读取错乱，所以要做异步更新
                if([[resDic valueForKey:@"list"] count]){
                    [self createMusic];
                }
                [self setUnreadNumber:[[resDic valueForKey:@"list"] count] With:[resDic valueForKey:KeyFromUidTalk]];
                BanBu_AppDelegate *appDelegate = (BanBu_AppDelegate *)[[UIApplication sharedApplication] delegate];
                [appDelegate updateBadge];
          
            }

        }
  
        // 从服务器获取全部的数据
        else if ([AppComManager respondsDic:resDic isFunctionData:BanBu_AllOperation_Server])
        {
            NSLog(@"++___++_++__++%@",resDic);

            if([[resDic valueForKey:@"resultlist"]isKindOfClass:[NSArray class]]){
                
                NSArray *resultList=[NSArray arrayWithArray:[resDic valueForKey:@"resultlist"]];
                
                for(NSDictionary *temp in resultList)
                {
                    NSString *parStr = [AppComManager getPar:BanBu_ReceiveMessage_From_All];
                    if([[temp valueForKey:@"fc"]isEqual:parStr])
                    {
                        if([[temp valueForKey:@"list"] isKindOfClass:[NSArray class]]){
                            
                            NSArray *listArray = [NSArray arrayWithArray:[temp valueForKey:@"list"]];
                            //第一次来消息是不需要更改状态的，再来的话，就可能自己送达的变已读了。
                            //全局时候时，没有新消息，只需更新状态
                            [self initTalkPeopleDB];
                            //更改对话列表的已读未读的状态
                            [self setStatusOfAll:[temp valueForKey:@"statuslist"]];
                            
                            if(listArray.count){
                                [self writeToTalkPeopleDB:listArray];

                                if(_appChatController){
                                    for(NSDictionary *people in listArray)
                                    {
                                        if([self.chatuid isEqualToString:[people valueForKey:KeyFromUid]]){
                                            //要刷新点对点页面
                                            [self setUnreadNumber:0 With:[people valueForKey:KeyFromUid]];
                                            [self readTalkList:[people valueForKey:KeyFromUid] WithNumber:20];
                                            [_appChatController.tableView reloadData];
                                            [_appChatController.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dialogs.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                                            for(int i=0;i<MyAppDataManager.dialogs.count;i++){
                                                
                                                NSDictionary *amsg = [NSDictionary dictionaryWithDictionary:[MyAppDataManager.dialogs objectAtIndex:i]];
                                                [MyAppDataManager.cellRowMapDic setValue:[NSNumber numberWithInteger:i] forKey:[amsg valueForKey:KeyChatid]];
                                            }
                                            break;
                                        }
                                        
                                    }
                                     
                                }else{
                                     
                                    [self createMusic];

                                }
                            }
                            if(!_appChatController){
                                
                                BanBu_AppDelegate *appDelegate = (BanBu_AppDelegate *)[[UIApplication sharedApplication] delegate];
                                [appDelegate updateBadge];
                            }
                            
                        
                        }
                    }
  
                }
                
                
            }
            if(!_appChatController)
            {
                [AppComManager startReceiveMsgFromUid:nil forDelegate:MyAppDataManager];

            }

        }
        else if([AppComManager respondsDic:resDic isFunctionData:BanBu_SendMessage_To_Server])
        {
            NSLog(@"zoulejic");
            NSLog(@"%@",resDic);
             NSDictionary *statuDic =  [NSDictionary dictionaryWithObjectsAndKeys:@"s",@"status",[resDic valueForKey:@"touid"],@"touid",[resDic valueForKey:KeyChatid],KeyChatid,[NSNumber numberWithInteger:MediaStatusNormal],KeyMediaStatus, nil];

            NSLog(@"%@",statuDic);
            [self setStatusOfOne:statuDic];
    
            //判断这条消息，还是这个人的嘛（self.dialogs可能已改变）
            if(_appChatController &&[self.chatuid isEqualToString:[resDic valueForKey:KeyUid]])
            {
                NSInteger row = [[MyAppDataManager.cellRowMapDic valueForKey:[resDic valueForKey:KeyChatid]] integerValue];
                NSMutableDictionary *amsg = [NSMutableDictionary dictionaryWithDictionary:[self.dialogs objectAtIndex:row]];
                [amsg setValue:[NSNumber numberWithInteger:ChatStatusSent] forKey:KeyStatus];
                [amsg setValue:[NSNumber numberWithInteger:MediaStatusNormal] forKey:KeyMediaStatus];
                [self.dialogs replaceObjectAtIndex:row withObject:amsg];
                [_appChatController.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            }

        }
 
      

        
    }
    
    
}

 
 



//{a j,b k,c l,}   like this
-(NSString *)getPar1StrFromDic:(NSDictionary *)parDic
{
    NSMutableString *str = [NSMutableString stringWithCapacity:1];
    for(NSString *key in parDic)
        [str appendFormat:@"%@ %@,",key,[parDic valueForKey:key]];
    [str deleteCharactersInRange:NSMakeRange(str.length-1, 1)];
    return str;
}

/*********聊天数据处理**********/

-(void)sendMsg:(NSDictionary *)aMsg toUid:(NSString *)uid{
    
    NSMutableDictionary *sendDic = [NSMutableDictionary dictionaryWithDictionary:aMsg];
    [sendDic setValue:uid forKey:@"touid"];
    NSLog(@"%@",sendDic);
    
    [AppComManager getBanBuData:BanBu_SendMessage_To_Server par:sendDic delegate:self];
}

// 发送聊天的信息 这一步是关键啊
- (void)sendTextMsg:(NSString *)msg forType:(ChatCellType)type toUid:(NSString *)uid From:(NSString *)from
{
    NSArray *mapArr = [NSArray arrayWithObjects:@"text",@"image",@"location",@"sound",@"emi",nil];
    NSMutableDictionary *sendDic = [NSMutableDictionary dictionary];
    [sendDic setValue:uid forKey:@"touid"];
    [sendDic setValue:[NSString stringWithFormat:@"%i",self.talkArr.count-1] forKey:@"msgid"];
    [sendDic setValue:[NSDictionary dictionaryWithObjectsAndKeys:msg,KeyContent,[mapArr objectAtIndex:type],KeyType,from,KeyShowFrom,nil] forKey:@"says"];
    
    // 这是发送的嘛啊？
    
    NSLog(@"%@",sendDic);
    
    [AppComManager getBanBuData:BanBu_SendMessage_To_Server par:sendDic delegate:self];
}

- (void)sendTextMsg:(NSString *)msg forType:(ChatCellType)type toUid:(NSString *)uid Number:(int)n From:(NSString *)from
{
    NSArray *mapArr = [NSArray arrayWithObjects:@"text",@"image",@"location",@"sound",@"emi",nil];
    NSMutableDictionary *sendDic = [NSMutableDictionary dictionary];
    [sendDic setValue:uid forKey:@"touid"];
    [sendDic setValue:[NSString stringWithFormat:@"%d",n] forKey:@"msgid"];
    [sendDic setValue:[NSDictionary dictionaryWithObjectsAndKeys:msg,KeyContent,[mapArr objectAtIndex:type],KeyType,from,KeyShowFrom,nil] forKey:@"says"];
 
//    NSLog(@"%@",sendDic);
    [AppComManager getBanBuData:BanBu_SendMessage_To_Server par:sendDic delegate:self];
}
 
- (void)banbuRequestNamed:(NSString *)requestname uploadDataProgress:(float)progress
{
    NSLog(@"%@",requestname);
//    if(self.appChatController)
//    {
//        NSInteger row = [[[requestname componentsSeparatedByString:@"-"] objectAtIndex:0] integerValue];
//        
//       
//        int rowt=MyAppDataManager.talkArr.count-row;
//        
//        int dilogsRow=MyAppDataManager.dialogs.count-rowt;
//        
//        NSLog(@"- =- =- =- =- = -= -= -= - %d",dilogsRow);
//    
//        BanBu_ChatCell *cell = (BanBu_ChatCell *)[_appChatController.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:dilogsRow inSection:0]];
//        if(cell)
//        {
//            // 判断是不是照片或者录音
//            if(![[requestname pathExtension] isEqual:@"amr"]){
//            
//                [cell.mediaView setMedia:requestname];
//                
//                cell.mediaView.progressBar.progress = progress;
//            
//            }else
//            {
//            
//                NSLog(@"ha ha ha  this is ))))((())_(_()_)_)");
//            
//            }
//                
//        }
//    }
}

- (void)banbuUploadRequest:(NSDictionary *)resDic didFinishedWithError:(NSError *)error
{
    if(error)
    {
//        NSInteger row = [[[[resDic valueForKey:@"requestname"] componentsSeparatedByString:@"-"] objectAtIndex:0] integerValue];
        NSDictionary *statuDic =  [NSDictionary dictionaryWithObjectsAndKeys:@"fail",@"status",[resDic valueForKey:@"touid"],@"touid",[resDic valueForKey:KeyChatid],KeyChatid,[NSNumber numberWithInteger:MediaStatusUploadFaild],KeyMediaStatus, nil];
        [self setStatusOfOne:statuDic];
        
        if(_appChatController &&[self.chatuid isEqualToString:[resDic valueForKey:KeyUid]])
        {
            NSInteger row = [[MyAppDataManager.cellRowMapDic valueForKey:[resDic valueForKey:KeyChatid]] integerValue];
            NSMutableDictionary *amsg = [NSMutableDictionary dictionaryWithDictionary:[self.dialogs objectAtIndex:row]];
            [amsg setValue:[NSNumber numberWithInteger:ChatStatusSendFail] forKey:KeyStatus];
            [amsg setValue:[NSNumber numberWithInteger:MediaStatusUploadFaild] forKey:KeyMediaStatus];
            [self.dialogs replaceObjectAtIndex:row withObject:amsg];
            [_appChatController.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }
        return;
    }
    NSLog(@"%@-----",resDic);

    if([[resDic valueForKey:@"ok"] boolValue])
    {

//        NSInteger row = [[[[resDic valueForKey:@"requestname"] componentsSeparatedByString:@"-"] objectAtIndex:0] integerValue];
        //上传成功后，更改自定义的文件名（chatid.jpg）为服务器返回的内容
        NSInteger row = [[MyAppDataManager.cellRowMapDic valueForKey:[resDic valueForKey:KeyChatid]] integerValue];
        NSMutableDictionary *amsg = [NSMutableDictionary dictionaryWithDictionary:[self.dialogs objectAtIndex:row]];
        [amsg setValue:[resDic valueForKey:@"fileurl"] forKey:KeyContent];
        [amsg setValue:[NSNumber numberWithInteger:MediaStatusNormal] forKey:KeyMediaStatus];
        [amsg setValue:[resDic valueForKey:KeyChatid] forKey:KeyChatid];
        
        NSMutableDictionary *peoDic = [NSMutableDictionary dictionaryWithDictionary:amsg];
        [peoDic setValue:[resDic valueForKey:KeyUid] forKey:KeyFromUid];
        [self setTalkPeopleOne:peoDic];
        [self setDialogOne:amsg andToUid:[resDic valueForKey:KeyUid]];
        
        if(_appChatController &&[self.chatuid isEqualToString:[resDic valueForKey:KeyUid]])
        {
            [self.dialogs replaceObjectAtIndex:row withObject:amsg];
            [_appChatController.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }
        NSDictionary *saysDic = [NSDictionary dictionaryWithObjectsAndKeys:VALUE(KeyContent, amsg),KeyContent,[resDic valueForKey:@"mediatype"],KeyType,[amsg valueForKey:KeyShowFrom],KeyShowFrom,nil];
        
        [self sendMsg:[NSDictionary dictionaryWithObjectsAndKeys:saysDic,KeySays,VALUE(KeyChatid, amsg),KeyChatid, nil] toUid:[resDic valueForKey:KeyUid]];
  
    }
    
}

- (void)banbuDownloadRequest:(NSDictionary *)resDic didFinishedWithError:(NSError *)error
{

    NSLog(@"%@",resDic);
    if(error)
    {
 
        
        NSDictionary *statuDic =  [NSDictionary dictionaryWithObjectsAndKeys:@"fail",@"status",[resDic valueForKey:@"touid"],@"touid",[resDic valueForKey:KeyChatid],KeyChatid,[NSNumber numberWithInteger:MediaStatusDownloadFaild],KeyMediaStatus, nil];
        [self setStatusOfOne:statuDic];
        
        if(_appChatController &&[self.chatuid isEqualToString:[resDic valueForKey:KeyUid]])
        {
            NSInteger row = [[MyAppDataManager.cellRowMapDic valueForKey:[resDic valueForKey:KeyChatid]] integerValue];
            NSMutableDictionary *amsg = [NSMutableDictionary dictionaryWithDictionary:[self.dialogs objectAtIndex:row]];
            [amsg setValue:[NSNumber numberWithInteger:ChatStatusNone] forKey:KeyStatus];
            [amsg setValue:[NSNumber numberWithInteger:MediaStatusDownloadFaild] forKey:KeyMediaStatus];
            [self.dialogs replaceObjectAtIndex:row withObject:amsg];
            [_appChatController.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }
        return;
    }

    if([[resDic valueForKey:@"ok"] boolValue])
    {
  
//        NSInteger row = [[[[resDic valueForKey:@"requestname"] componentsSeparatedByString:@"-"] objectAtIndex:0] integerValue];
        
        NSDictionary *statuDic =  [NSDictionary dictionaryWithObjectsAndKeys:@"none",@"status",[resDic valueForKey:@"touid"],@"touid",[resDic valueForKey:KeyChatid],KeyChatid,[NSNumber numberWithInteger:MediaStatusNormal],KeyMediaStatus, nil];
        [self setStatusOfOne:statuDic];
    
        NSInteger row = [[MyAppDataManager.cellRowMapDic valueForKey:[resDic valueForKey:KeyChatid]] integerValue];
        NSMutableDictionary *amsg = [NSMutableDictionary dictionaryWithDictionary:[self.dialogs objectAtIndex:row]];
        if(_appChatController &&[self.chatuid isEqualToString:[resDic valueForKey:KeyUid]])
        {
        
            [amsg setValue:[NSNumber numberWithInteger:MediaStatusNormal] forKey:KeyMediaStatus];
            [self.dialogs replaceObjectAtIndex:row withObject:amsg];
            [_appChatController.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }
        
    }
}

- (void)banbuRequestNamed:(NSString *)requestname downloadDataProgress:(float)progress
{
//    if(_appChatController)
//    {
//        NSInteger row = [[[requestname componentsSeparatedByString:@"-"] objectAtIndex:0] integerValue];
//        int rowt=MyAppDataManager.talkArr.count-row;
//        
//        int dilogsRow=MyAppDataManager.dialogs.count-rowt;
//        
//        BanBu_ChatCell *cell = (BanBu_ChatCell *)[_appChatController.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:dilogsRow inSection:0]];
//        if(cell){
//        
//            if(![[requestname pathExtension] isEqual:@"amr"]){
//                
//                cell.mediaView.progressBar.progress = progress;
//                
//            }else
//            {
//                // 这里是下载过程中的进度条
//                
//                NSLog(@"ha ha ha  this is ))))((())_(_()_)_)");
//                
//            }
//
//        
//        
//        }
//    
//    }

}

+(id)allocWithZone:(NSZone *)zone{
    @synchronized(self){
        if (sharedAppDataManager == nil) {
            sharedAppDataManager = [super allocWithZone:zone];
            return  sharedAppDataManager;
        }
    }
    return nil;
}


- (BOOL)fiveMinuteLater:(NSString *)stime beforeTime:(NSString *)ltime
{
    if(!ltime || !stime)
        return NO;
    
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *currentDate = [formatter dateFromString:stime];
    if(!currentDate)
        return NO;
    NSDate *lastDate = [formatter dateFromString:ltime];
    if(!lastDate)
        return NO;
    
    return [currentDate timeIntervalSince1970]>[lastDate timeIntervalSince1970]+180;
}

-(NSString *)currentTime:(NSString *)receiveTime
{
    
    int hostTime=[[UserDefaults valueForKey:@"hostTime"] intValue];
    
    NSTimeInterval secondsPerDay = hostTime* 60;
    
    // 获取一个时间
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *currentDate = [formatter dateFromString:receiveTime];
    // 加上我们的当前时间
    NSString *stime = [formatter stringFromDate:[NSDate dateWithTimeInterval:secondsPerDay sinceDate:currentDate]];

    //    NSLog(@"%@",stime);
    return stime;
    
}
-(NSString*)currentTimeBeforeAweek
{
    NSDateFormatter * dateFormatter = [[[NSDateFormatter alloc] init]autorelease];
    NSDate *nowDate = [NSDate date];
    NSTimeInterval  interval = 24*60*60*7; //1:天数
    NSDate *date1 = [nowDate initWithTimeIntervalSinceNow:-interval];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    return  ([NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:date1]]);
    
}

- (UIImage *)scaleImage:(UIImage *)image proportion:(float)scale {
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width/scale, image.size.height/scale));
    CGRect imageRect = CGRectMake(0.0, 0.0, image.size.width/scale, image.size.height/scale);
    [image drawInRect:imageRect];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
- (void)dealloc
{
    self.dataBase = nil;
 
    self.cellRowMapDic = nil;

    // 滞空 让object 即使在此release 也不崩溃
    [_useruid release],_useruid=nil;
    [_userAvatar release],_userAvatar=nil;
    [_loginid release],_loginid=nil;
    [_chatuid release],_chatuid=nil;
    [_regDic release],_regDic=nil;
    [_nearBuddys release];
    [_nearDos release];
    [_contentArr release];
    [_friends release];
    [_friendsDos release];
    [_dialogs release];
    [_talkPeoples release];
    [_languageDictionary release];
    [_playBall release];
    
    [_ballTalk release];
    
    [_messageRadioDictionary release],_messageRadioDictionary=nil;
    
    [_keyArr release],_keyArr=nil;
    
    [_valueArr release],_valueArr=nil;
    
    [_unLoginArr release],_unLoginArr=nil;
    
    [_emiLanguageArr release],_emiLanguageArr=nil;
    
    [_emiNameArr release],_emiNameArr=nil;
    
    [_agreeList release],_agreeList=nil;
    
    [_talkArr release],_talkArr=nil;
    
    [_boolArr release],_boolArr=nil;
    
    [player release],player=nil;
    
    [super dealloc];
}

-(NSString *)UserDefautsKey:(int )from
{
    
    NSString *fr=[NSString stringWithFormat:@"%d",from*100+from*10+123];

    return [@"amsg" stringByAppendingString:fr];

}


- (id)copyWithZone:(NSZone *)zone
{
    return self;
}
- (id)retain
{
    return self;
}
- (NSUInteger)retainCount
{
    return NSUIntegerMax;  //denotes an object that cannot be released
}
- (oneway void)release
{
    //do nothing
}
- (id)autorelease
{
    return self;
}



@end
