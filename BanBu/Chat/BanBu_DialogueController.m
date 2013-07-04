//
//  BanBu_DialogueControllerViewController.m
//  BanBu
//
//  Created by 17xy on 12-7-30.
//
//

#import "BanBu_DialogueController.h"
#import "BanBu_DialogueCell.h"
#import "BanBu_ChatViewController.h"
#import "AppDataManager.h"
#import "AppCommunicationManager.h"
#import "TKLoadingView.h"
#import "CJSONSerializer.h"
#import "NSDictionary_JSONExtensions.h"
#import <CommonCrypto/CommonDigest.h>
#import "CJSONDeserializer.h"
@interface BanBu_DialogueController ()

@end

@implementation BanBu_DialogueController
@synthesize ProRequest=_ProRequest;

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"dialogueTitle", nil);
    
    self.tableView.backgroundColor = [UIColor colorWithRed:255.0/255 green:250.0/255 blue:240.0/255 alpha:1.0];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.allowsSelectionDuringEditing = YES;

    CGFloat btnLen = [NSLocalizedString(@"clearButton", nil) sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(150, 30)].width;
    UIButton *clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    clearButton.frame=CGRectMake(0, 0, btnLen+20, 30);
    [clearButton addTarget:self action:@selector(clearFlag) forControlEvents:UIControlEventTouchUpInside];
    [clearButton setBackgroundImage:[[UIImage imageNamed:@"app_nav_btn_bg1.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0] forState:UIControlStateNormal];
    [clearButton setBackgroundImage:[[UIImage imageNamed:@"app_nav_btn_bg2.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0] forState:UIControlStateHighlighted];
    [clearButton setTitleEdgeInsets:UIEdgeInsetsMake(3, 2, 2, 2)];
    [clearButton setTitle:NSLocalizedString(@"clearButton", nil) forState:UIControlStateNormal];
    clearButton.titleLabel.font = [UIFont systemFontOfSize:14];
    UIBarButtonItem *clearItem = [[[UIBarButtonItem alloc] initWithCustomView:clearButton] autorelease];
    self.navigationItem.leftBarButtonItem = clearItem;

    CGFloat btnLen1 = [NSLocalizedString(@"deleteButton", nil) sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(150, 30)].width;
    deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteButton.frame=CGRectMake(0, 0, btnLen1+20, 30);
    deleteButton.tag = 101;
    [deleteButton addTarget:self action:@selector(setEditing:animated:) forControlEvents:UIControlEventTouchUpInside];
    [deleteButton setBackgroundImage:[[UIImage imageNamed:@"app_nav_btn_bg1.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0] forState:UIControlStateNormal];
    [deleteButton setBackgroundImage:[[UIImage imageNamed:@"app_nav_btn_bg2.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0] forState:UIControlStateHighlighted];
    [deleteButton setTitleEdgeInsets:UIEdgeInsetsMake(3, 2, 2, 2)];
    [deleteButton setTitle:NSLocalizedString(@"deleteButton", nil) forState:UIControlStateNormal];
    deleteButton.titleLabel.font = [UIFont systemFontOfSize:14];
    UIBarButtonItem *delItem = [[[UIBarButtonItem alloc] initWithCustomView:deleteButton] autorelease];
    self.navigationItem.rightBarButtonItem = delItem;
//    NSLog(@"%@",MyAppDataManager.talkPeoples);
	deleteArr = [[NSMutableArray alloc] init];

 
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateBadgeShow];
    _isPush = YES;
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    self.navigationController.view.userInteractionEnabled = YES;
}

- (void) setEditing:(BOOL)editting animated:(BOOL)animated
{
	
	[super setEditing:!self.editing animated:YES];
    if(self.editing){
        CGFloat btnLen1 = [NSLocalizedString(@"finishButton", nil) sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(150, 30)].width;
        deleteButton.frame=CGRectMake(320-btnLen1-20-5, 7, btnLen1+20, 30);

        [deleteButton setTitle:NSLocalizedString(@"finishButton", nil) forState:UIControlStateNormal];
    }else{
        CGFloat btnLen1 = [NSLocalizedString(@"deleteButton", nil) sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(150, 30)].width;
        deleteButton.frame=CGRectMake(320-btnLen1-20-5, 7, btnLen1+20, 30);
        [deleteButton setTitle:NSLocalizedString(@"deleteButton", nil) forState:UIControlStateNormal];
    }
    
    
    
    if(deleteArr.count){
        [TKLoadingView showTkloadingAddedTo:self.navigationController.view title:NSLocalizedString(@"deleteNotice", nil) activityAnimated:YES];


        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            
            NSMutableArray *tempArr = [NSMutableArray array];
            for(NSIndexPath *indexPath in deleteArr){
                NSDictionary *aTalk = [MyAppDataManager.talkPeoples objectAtIndex:indexPath.row];
                [tempArr addObject:aTalk];
                
            }
            [MyAppDataManager deleteTalkPeople:tempArr];
        
            
#warning 提交服务器推送数目
            NSInteger total = 0;
            for(NSDictionary *aTalk in MyAppDataManager.talkPeoples)
            {
                total += [VALUE(KeyUnreadNum, aTalk) integerValue];
                
            }
            self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%i",total];
            //        NSLog(@"%d",total);
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",total],@"pushcount",nil];
            [AppComManager getBanBuData:Banbu_Set_User_Pushcount par:dic delegate:self];
            dispatch_sync(dispatch_get_main_queue(), ^{
                
                [MyAppDataManager.talkPeoples removeObjectsInArray:tempArr];
                [self.tableView deleteRowsAtIndexPaths:deleteArr withRowAnimation:UITableViewRowAnimationFade];
                [deleteArr removeAllObjects];
                [TKLoadingView dismissTkFromView:self.navigationController.view animated:NO afterShow:0.0];
            });
                
        });
   
    }
    
}

-(void)refresh:(UIButton *)button{

    [button setTitle:NSLocalizedString(@"deleteButton", nil) forState:UIControlStateNormal];
    [self.tableView setEditing:NO animated:YES];
}



- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)dealloc
{
    [deleteArr release];
    
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return MyAppDataManager.talkPeoples.count;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 84;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    BanBu_DialogueCell *cell = (BanBu_DialogueCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[[BanBu_DialogueCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
//        cell.multipleSelectionBackgroundView = [[[UIView alloc] initWithFrame:cell.bounds] autorelease];
 
    }
    NSDictionary *aTalk;
    if([MyAppDataManager.talkPeoples count]!=0)
    {
      aTalk = [MyAppDataManager.talkPeoples objectAtIndex:indexPath.row];
    }else
    {
        aTalk=nil;
    }
    [cell setAvatar:VALUE(KeyUface, aTalk)];
    [cell setName:[MyAppDataManager IsInternationalLanguage:VALUE(KeyUname, aTalk)]];
//    NSLog(@"%@-----%@",VALUE(KeyStime, aTalk),[VALUE(KeyStime, aTalk) substringFromIndex:5]);
//    NSLog(@"%@",aTalk);
    [cell setLastInfo: VALUE(KeyStime, aTalk)];
    [cell setAge:VALUE(KeyAge, aTalk) sex:[VALUE(KeySex, aTalk) boolValue]];
    [cell setDistance:[MyAppDataManager IsInternationalLanguage:VALUE(KeyDmeter, aTalk)]];
    [cell setlastDialogue:VALUE(KeyLasttalk, aTalk) andType:[VALUE(KeyType, aTalk) intValue]];
    
#warning 隐藏掉对话列表的送达和已读状态
    if(![VALUE(KeyLasttalk, aTalk) isEqualToString:@""])
    {
        if([VALUE(KeyMe, aTalk) boolValue])
        {
            if([aTalk valueForKey:@"status"]){
                [cell setReadAndSend:[VALUE(KeyStatus, aTalk) intValue]];

            }
            
        }else{
            [cell setReadAndSend:DialogueMessageStautusNoneType];
            
        }
        cell.receiveAndsend.hidden = NO;
        [cell setReceiveAndsend11:[VALUE(KeyMe, aTalk) boolValue]];
    }
    else
    {
        cell.receiveAndsend.hidden = YES;
        [cell setReadAndSend:DialogueMessageStautusNoneType];

    }

    NSInteger unReadNum = [VALUE(KeyUnreadNum, aTalk) integerValue];
    [cell setBadageValue:[NSString stringWithFormat:@"%i",unReadNum]];

    
    //多选删除
    NSMutableDictionary *talkPeopleDic = [NSMutableDictionary dictionaryWithDictionary:[MyAppDataManager.talkPeoples objectAtIndex:indexPath.row]];
    BOOL isChecked = [[talkPeopleDic valueForKey:@"isChecked"] boolValue];
    [cell setChecked:isChecked];
    
    return cell;
}

- (void)updateBadgeShow
{
    
//    NSLog(@"%@",MyAppDataManager.talkPeoples);
    [MyAppDataManager readTalkList:nil WithNumber:0];

     _totalUnreadNum = 0;
    for(NSDictionary *aTalk in MyAppDataManager.talkPeoples)
    {
        _totalUnreadNum += [VALUE(KeyUnreadNum, aTalk) integerValue];
        
        if([[aTalk valueForKey:@"userid"] intValue]<1000)
        {
             
              // 不需要了因为他们都是在一个navi
          //  [MyAppDelegate updateBadgeFriend:VALUE(KeyUnreadNum, aTalk)];
        
        }
    }
    [self.tableView reloadData];
    self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%i",_totalUnreadNum];
    
//    NSLog(@"+++++++++++%d", MyAppDataManager.talkPeoples.count );

}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return UITableViewCellEditingStyleNone;
}

#pragma mark - Table view delegate
 
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.tableView.editing){
        NSMutableDictionary *talkPeopleDic = [NSMutableDictionary dictionaryWithDictionary:[MyAppDataManager.talkPeoples objectAtIndex:indexPath.row]];
        BOOL isChecked = [[talkPeopleDic valueForKey:@"isChecked"] boolValue];
        [talkPeopleDic setValue:[NSString stringWithFormat:@"%d",!isChecked] forKey:@"isChecked"];
        [MyAppDataManager.talkPeoples replaceObjectAtIndex:indexPath.row withObject:talkPeopleDic];
        
        BanBu_DialogueCell *cell = (BanBu_DialogueCell *)[tableView cellForRowAtIndexPath:indexPath];
        [cell setChecked:!isChecked];
        if(!isChecked){
            [deleteArr addObject:indexPath];
        }else{
            [deleteArr removeObject:indexPath];
        }
    }
 
    else{

//        NSLog(@"%@********************",MyAppDataManager.talkPeoples);
        
        NSLog(@"%@",[MyAppDataManager.talkPeoples objectAtIndex:indexPath.row]);
        NSDictionary *userDic = [NSDictionary dictionaryWithDictionary:[MyAppDataManager.talkPeoples objectAtIndex:indexPath.row]];
        
        if([VALUE(KeyUnreadNum, userDic) integerValue]!=0)
        {
            NSMutableDictionary *unReadDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",0-[VALUE(KeyUnreadNum, userDic) integerValue]],@"pushcount",nil];
            //        NSLog(@"%@",[NSString stringWithFormat:@"%d",0-[VALUE(KeyUnreadNum, aTalk1) integerValue]]);
            [AppComManager getBanBuData:Banbu_Set_User_Pushcount par:unReadDic delegate:self];
            
            //更改数据库，将这个人的未读条数清零
            [MyAppDataManager setUnreadNumber:0 With:[userDic valueForKey:@"userid"]];
        }
        NSMutableArray *blackList=[[NSMutableArray alloc] initWithArray:[[[UserDefaults valueForKey:MyAppDataManager.useruid] valueForKey:@"friendlist"] valueForKey:@"flist"]];
        
        
        
        //判断此人是不是在黑名单，是就不能和他对话
        for(NSDictionary * dic in blackList)
        {
            if([VALUE(@"fuid", dic) isEqual:VALUE(KeyFromUid, userDic)]&&[VALUE(@"linkkind", dic)isEqual:@"x"])
            {
//                     [TKLoadingView showTkloadingAddedTo:self.navigationController.view title:@"你已经将他拉入黑名单,如果想和他对话请去黑名单解除" activityAnimated:NO duration:2];
                [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
                return;
            }
        }
        
        // 判断这个用户的usrid 如果小于一个确定的数  那么 跳入到对应的
        if([[userDic valueForKey:@"userid"] intValue]==200)
        {
            // 不同的数据跳转到相应的界面
        }
        else{
            if(_isPush){ //防止页面卡住时，多次点击该cell，会push多个viewcontroller
//                NSLog(@"%@",MyAppDataManager.talkPeoples);
                //判断未读消息是否超过20条，因为默认只会读取20条记录
                if([VALUE(KeyUnreadNum, userDic) integerValue]>20){
                    [MyAppDataManager readTalkList:[userDic valueForKey:@"userid"] WithNumber:[VALUE(KeyUnreadNum, userDic) integerValue]];

                }else{
                    [MyAppDataManager readTalkList:[userDic valueForKey:@"userid"] WithNumber:20];

                }
                //chatid映射cell的row
                for(int i=0;i<MyAppDataManager.dialogs.count;i++){
                    
                    NSDictionary *amsg = [NSDictionary dictionaryWithDictionary:[MyAppDataManager.dialogs objectAtIndex:i]];
                    [MyAppDataManager.cellRowMapDic setValue:[NSNumber numberWithInteger:i] forKey:[amsg valueForKey:KeyChatid]];
                }
//                NSLog(@"%@",MyAppDataManager.cellRowMapDic);
//                NSLog(@"%@",MyAppDataManager.dialogs);
                BanBu_ChatViewController *chat = [[BanBu_ChatViewController alloc] initWithPeopleProfile:userDic];
                //是否显示headerview
                if([[userDic valueForKey:@"userid"] intValue]<1000){
                    chat.listType = 1;
                }else{
                    chat.listType = 0;
                }
                chat.hidesBottomBarWhenPushed = YES;
                 _isPush = NO;
                [self.navigationController pushViewController:chat animated:YES];
                [chat release];
                
            }
        }
               
    }
 }


-(void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(cell){
        [(BanBu_ListCell*)cell cancelImageLoad];
    }
}

- (void)clearFlag
{
#warning 漏掉的推送
    //清除标记也要告知服务器。
    if(_totalUnreadNum){
        
        for(int i=0; i<MyAppDataManager.talkPeoples.count; i++)
        {
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[MyAppDataManager.talkPeoples objectAtIndex:i]];
            [dic setValue:[NSNumber numberWithInt:0] forKey:KeyUnreadNum];
            [MyAppDataManager setUnreadNumber:0 With:[dic valueForKey:KeyFromUid]];
            [MyAppDataManager.talkPeoples replaceObjectAtIndex:i withObject:dic];
        }
        _totalUnreadNum = 0;
        self.navigationController.tabBarItem.badgeValue = @"0";
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"0",@"pushcount",nil];
        [AppComManager getBanBuData:Banbu_Set_User_Pushcount par:dic delegate:self];
        
        [self.tableView reloadData];
    }
   
}

- (void)banbuRequestDidFinished:(NSDictionary *)resDic error:(NSError *)error
{
    
    
    
}

@end
