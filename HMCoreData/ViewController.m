//
//  ViewController.m
//  HMCoreData
//
//  Created by humiao on 2019/7/29.
//  Copyright © 2019 humiao. All rights reserved.
//

#import "ViewController.h"
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "Person+CoreDataClass.h"

@interface ViewController () {
    NSManagedObjectContext *_context;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *dataSource;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupView];
    
    [self loadData];
}

//MARK: Private Methods
- (void)setupView {
//    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell_id"];
    self.tableView.estimatedRowHeight = 100;
}


- (void)loadData {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Person"];
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    _context = delegate.persistentContainer.viewContext;
    
    NSArray *result = [_context executeFetchRequest:request error:nil];
    self.dataSource = [NSMutableArray arrayWithArray:result];
    [self.tableView reloadData];
}

//MARK: delegate and dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_id" forIndexPath:indexPath];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_id"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell_id"];
    }
    Person *p = _dataSource[indexPath.row];
    
    cell.imageView.image = [UIImage imageNamed:[p.gander isEqualToString:@"帅哥"] == YES ? @"andy.jpeg" : @"echo.jpeg"];
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    NSLog(@"当前gander是：%@ - indexPath:%ld   %@",p.gander,indexPath.row, cell.imageView);
    cell.textLabel.text = [NSString stringWithFormat:@" age = %d \n weight = %d \n name = %@ \n gander = %@",p.age, p.weight, p.name, p.gander];
    cell.textLabel.numberOfLines = 0;
    return cell;
}

//MARK: button Target
- (IBAction)insertAction:(UIButton *)sender {
    [self insertData];
}

- (IBAction)deleteAction:(UIButton *)sender {
    [self deleteData];
}

- (IBAction)updateAction:(UIButton *)sender {
    [self updateData];
}

- (IBAction)queryAction:(UIButton *)sender {
    [self queryData];
}

- (IBAction)sortAction:(id)sender {
    [self sortData];
}

//MARK: coredata operation
- (void)insertData {
    Person *person = [NSEntityDescription
                         insertNewObjectForEntityForName:@"Person"
                         inManagedObjectContext:_context];
    person.name = [NSString stringWithFormat:@"%@%@",@[@"赵",@"钱",@"孙",@"李",@"周",@"吴",@"郑",@"王"][arc4random()%7],@[@"冯",@"陈",@"褚",@"卫",@"蒋",@"沈",@"韩",@"杨"][arc4random()%7]];
    person.age = arc4random()%20;
    person.gander = arc4random()%2 == 0 ?  @"美女" : @"帅哥" ;
    person.height = arc4random()%180;
    person.weight = arc4random()%100;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Person"];
    NSArray *result = [_context executeFetchRequest:request error:nil];
    _dataSource = [NSMutableArray arrayWithArray:result];
    [self.tableView reloadData];
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate saveContext:@"数据插入到数据库成功"];
}

- (void)deleteData {

    NSFetchRequest *deleRequest = [NSFetchRequest fetchRequestWithEntityName:@"Person"];
   
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"age < %d", 10];
    deleRequest.predicate = pre;

    NSArray *deleArray = [_context executeFetchRequest:deleRequest error:nil];
    
    for (Person *stu in deleArray) {
        [_context deleteObject:stu];
    }
    
    //没有任何条件就是读取所有的数据
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Person"];
    NSArray *result = [_context executeFetchRequest:request error:nil];
    _dataSource = [NSMutableArray arrayWithArray:result];
    [self.tableView reloadData];
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate saveContext:@"删除 age < 10 的数据"];
}

- (void)updateData {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Person"];
    
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"gander = %@", @"帅哥"];
    request.predicate = pre;
    
    //发送请求
    NSArray *result = [_context executeFetchRequest:request error:nil];
    
    //修改
    for (Person *stu in result) {
        stu.name = @"Andy-Miao";
    }
    
    _dataSource = [NSMutableArray arrayWithArray:result];
    [self.tableView reloadData];
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate saveContext:@"更新所有帅哥的的名字为“andy-Miao"];
}

- (void)queryData {
    /* 谓词的条件指令
     1.比较运算符 > 、< 、== 、>= 、<= 、!=
     例：@"number >= 99"
     
     2.范围运算符：IN 、BETWEEN
     例：@"number BETWEEN {1,5}"
     @"address IN {'shanghai','nanjing'}"
     
     3.字符串本身:SELF
     例：@"SELF == 'APPLE'"
     
     4.字符串相关：BEGINSWITH、ENDSWITH、CONTAINS
     例：  @"name CONTAIN[cd] 'ang'"  //包含某个字符串
     @"name BEGINSWITH[c] 'sh'"    //以某个字符串开头
     @"name ENDSWITH[d] 'ang'"    //以某个字符串结束
     
     5.通配符：LIKE
     例：@"name LIKE[cd] '*er*'"   //*代表通配符,Like也接受[cd].
     @"name LIKE[cd] '???er*'"
     
     *注*: 星号 "*" : 代表0个或多个字符
     问号 "?" : 代表一个字符
     
     6.正则表达式：MATCHES
     例：NSString *regex = @"^A.+e$"; //以A开头，e结尾
     @"name MATCHES %@",regex
     
     注:[c]*不区分大小写 , [d]不区分发音符号即没有重音符号, [cd]既不区分大小写，也不区分发音符号。
     
     7. 合计操作
     ANY，SOME：指定下列表达式中的任意元素。比如，ANY children.age < 18。
     ALL：指定下列表达式中的所有元素。比如，ALL children.age < 18。
     NONE：指定下列表达式中没有的元素。比如，NONE children.age < 18。它在逻辑上等于NOT (ANY ...)。
     IN：等于SQL的IN操作，左边的表达必须出现在右边指定的集合中。比如，name IN { 'Ben', 'Melissa', 'Nick' }。
     
     提示:
     1. 谓词中的匹配指令关键字通常使用大写字母
     2. 谓词中可以使用格式字符串
     3. 如果通过对象的key
     path指定匹配条件，需要使用%K
     
     */
    
    //创建查询请求
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Person"];
    
    //查询条件
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"gander = %@", @"美女"];
    request.predicate = pre;
    
    
    // 从第几页开始显示
    // 通过这个属性实现分页
    //request.fetchOffset = 0;
    
    // 每页显示多少条数据
    //request.fetchLimit = 6;
    
    
    //发送查询请求,并返回结果
    NSArray *resArray = [_context executeFetchRequest:request error:nil];
    
    _dataSource = [NSMutableArray arrayWithArray:resArray];
    [self.tableView reloadData];
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate saveContext:@"查询所有的美女"];
}

- (void)sortData {
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Person"];
    
    //实例化排序对象
    NSSortDescriptor *ageSort = [NSSortDescriptor sortDescriptorWithKey:@"age"ascending:YES];
    NSSortDescriptor *numberSort = [NSSortDescriptor sortDescriptorWithKey:@"weight"ascending:YES];
    request.sortDescriptors = @[ageSort,numberSort];
    
    //发送请求
    NSError *error = nil;
    NSArray *resArray = [_context executeFetchRequest:request error:&error];
    
    _dataSource = [NSMutableArray arrayWithArray:resArray];
    [self.tableView reloadData];
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate saveContext:@"按照age和number排序"];
}


@end

