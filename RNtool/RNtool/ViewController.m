//
//  ViewController.m
//  RNtool
//
//  Created by 余浩 on 2018/1/15.
//  Copyright © 2018年 余浩. All rights reserved.
//

#import "ViewController.h"
#import <DiffMatchPatch.h>
#import "NSString+WZXSSLTool.h"
#import "WHCFileManager.h"
#define rnold @"18010801"
#define rnNew @"18010802"
//#define zip @"18010800"
#define zip @"18010802all"
@interface ViewController ()
@property(nonatomic, strong)NSMutableDictionary *dict;
@property(nonatomic, strong)NSMutableArray *imageoldArr;
@property(nonatomic, strong)NSMutableArray *imagenewArr;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //比较bundle差异，输出md5
    [self compareBundle];
    //比较图片资源差异
    [self comparePic];
    
    // Do any additional setup after loading the view, typically from a nib.
}
-(NSString*)getCurrentTimes{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    
    //现在时间,你可以输出来看下是什么格式
    
    NSDate *datenow = [NSDate date];
    
    //----------将nsdate按formatter格式转成nsstring
    
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    
    NSLog(@"currentTimeString =  %@",currentTimeString);
    
    return currentTimeString;
    
}
-(void)compareBundle
{
    //将要比较的文件拷贝到沙盒中去
    NSLog(@"%@",NSHomeDirectory());
        NSString *jsversionCachePath = [NSString stringWithFormat:@"%@/\%@",NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0],@"1"];
    BOOL jsversionExist = [[NSFileManager defaultManager] fileExistsAtPath:jsversionCachePath];
    //如果已存在
    if(jsversionExist){
        [[NSFileManager defaultManager] removeItemAtPath:jsversionCachePath error:nil];
        NSString *jsversionBundlePath = [[NSBundle mainBundle] pathForResource:rnold ofType:nil];
        [[NSFileManager defaultManager] copyItemAtPath:jsversionBundlePath toPath:jsversionCachePath error:nil];
        NSLog(@"jsversion已拷贝至Document: %@",jsversionCachePath);
        //如果不存在
    }else{
        NSString *jsversionBundlePath = [[NSBundle mainBundle] pathForResource:rnold ofType:nil];
        [[NSFileManager defaultManager] copyItemAtPath:jsversionBundlePath toPath:jsversionCachePath error:nil];
        NSLog(@"jsversion已拷贝至Document: %@",jsversionCachePath);
        
        
    }
    NSLog(@"%@",NSHomeDirectory());
    NSString *jsversionCachePath2 = [NSString stringWithFormat:@"%@/\%@",NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0],@"2"];
    BOOL jsversionExist2 = [[NSFileManager defaultManager] fileExistsAtPath:jsversionCachePath2];
    //如果已存在
    if(jsversionExist2){
        NSLog(@"jsversion已存在: %@",jsversionCachePath2);
        [[NSFileManager defaultManager] removeItemAtPath:jsversionCachePath2 error:nil];
        NSString *jsversionBundlePath2 = [[NSBundle mainBundle] pathForResource:rnNew ofType:nil];
        [[NSFileManager defaultManager] copyItemAtPath:jsversionBundlePath2 toPath:jsversionCachePath2 error:nil];
        NSLog(@"jsversion已拷贝至Document: %@",jsversionCachePath2);
    }else{
        NSString *jsversionBundlePath2 = [[NSBundle mainBundle] pathForResource:rnNew ofType:nil];
        [[NSFileManager defaultManager] copyItemAtPath:jsversionBundlePath2 toPath:jsversionCachePath2 error:nil];
        NSLog(@"jsversion已拷贝至Document: %@",jsversionCachePath2);
        
        
    }
    
    //将要比较的文件拷贝到沙盒中去
    NSLog(@"%@",NSHomeDirectory());
    NSString *docPathzip = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
   NSString *txtPathzip = [docPathzip stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.zip",zip]];
    BOOL txtPathzipExist2 = [[NSFileManager defaultManager] fileExistsAtPath:txtPathzip];
    //如果已存在
    if(txtPathzipExist2){
        NSLog(@"txtPathzipExist2已存在: %@",txtPathzip);
        //如果不存在
    }else{
//        NSString *jsversionBundlePath3 = [[NSBundle mainBundle] pathForResource:zip ofType:@"zip"];
//        [[NSFileManager defaultManager] copyItemAtPath:jsversionBundlePath3 toPath:txtPathzip error:nil];
//        NSLog(@"jsversion已拷贝至Document: %@",txtPathzip);
    }

    NSString *txtPath = [jsversionCachePath stringByAppendingPathComponent:@"main.jsbundle"]; // 此时仅存在路径，文件并没有真实存在
     NSString *txtPathrnold = [jsversionCachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@all.zip",rnold]]; // 此时仅存在路径，文件并没有真实存在
    
    
    NSString *txtPath2 = [jsversionCachePath2 stringByAppendingPathComponent:@"main.jsbundle"]; // 此时仅存在路径，文件并没有真实存在
    NSString *txtPathrnNew = [jsversionCachePath2 stringByAppendingPathComponent:[NSString stringWithFormat:@"%@all.zip",rnNew]]; // 此时仅存在路径，文件并没有真实存在
    NSString *patchzip = [jsversionCachePath2 stringByAppendingPathComponent:@"patch.zip"];

    DiffMatchPatch *dmp = [DiffMatchPatch new];


    // 字符串写入沙盒
    // 在Documents下面创建一个文本路径，假设文本名称为objc.txt
    // 获取Documents目录

    // 数组写入文件
    // 创建一个存储数组的文件路径
    NSString *docPath = [NSString stringWithFormat:@"%@%@ %@",@"/Users/yuhao/Desktop/js版本/",rnNew,[self getCurrentTimes]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:docPath]) {
        
    }else{
        [[NSFileManager defaultManager] createDirectoryAtPath:docPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString *filePath = [docPath stringByAppendingPathComponent:@"patch.txt"];
    NSString *text1 = [NSString stringWithContentsOfFile:txtPath encoding:NSUTF8StringEncoding error:nil];
    NSString *text2 = [NSString stringWithContentsOfFile:txtPath2 encoding:NSUTF8StringEncoding error:nil];
    NSMutableArray *array =  [dmp diff_mainOfOldString:text1 andNewString:text2];
    //   [dmp patch_apply:<#(NSArray *)#> toString:<#(NSString *)#>]

    // 数组写入文件执行的方法

   
    // NSArray *arrdiff = [array arr] [dmp patch_makeFromDiffs:array];
    NSString *patchtxt =  [dmp patch_toText:[dmp patch_makeFromDiffs:array]];

    //将差异写到文件
    [patchtxt writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    //输出差异文件地址

    NSString *resultStr = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];

    // 读取差异文件
    NSMutableArray *patchDataArr =[dmp patch_fromText:resultStr error:nil];
    // 差异文件和原始文件合并生成新的文件
    NSArray *ResultData= [dmp patch_apply:patchDataArr toString:text1];
    NSString *txtPath3 = [docPath stringByAppendingPathComponent:@"main.jsbundle"]; // 此时仅存在路径，文件并没有真实存在
    for (int i =0; i < ResultData.count; i ++) {
        if (i ==0) {
            [ResultData[i] writeToFile:txtPath3 atomically:YES encoding:NSUTF8StringEncoding error:nil];
        }
       
    }
    // 数组写入文件执行的方法
    [array writeToFile:txtPath atomically:YES];
   

    NSLog(@"All zip old %@", [txtPathrnold getFileMD5WithPath:txtPathrnold]);
    NSLog(@"All zip new %@", [txtPathrnNew getFileMD5WithPath:txtPathrnNew]);
    NSLog(@"bundle old %@", [txtPath getFileMD5WithPath:txtPath]);
    NSLog(@"bundle new%@",[txtPath2 getFileMD5WithPath:txtPath]);
    NSLog(@"bundle patch%@",[txtPath3 getFileMD5WithPath:txtPath3]);
    NSLog(@"bundle patch zip md5%@",[patchzip getFileMD5WithPath:patchzip]);
    
//    self.dict =[NSMutableDictionary dictionaryWithDictionary: @{rnNew : [txtPath3 getFileMD5WithPath:txtPath3]}] ;
    self.dict = [NSMutableDictionary dictionary];
     [self.dict setValue:[txtPath3 getFileMD5WithPath:txtPath3] forKey:@"bundleMd5"];
    [self.dict setValue:[txtPathrnNew getFileMD5WithPath:txtPathrnNew]  forKey:@"zipMd5"];
    
    NSMutableDictionary *dicOld = [NSMutableDictionary dictionary];
    [dicOld setValue:[txtPathrnold getFileMD5WithPath:txtPathrnold] forKey:@"zip old"];
    NSMutableDictionary *dicNew = [NSMutableDictionary dictionary];
    [dicNew setValue:[txtPathrnNew getFileMD5WithPath:txtPathrnNew] forKey:@"zip new"];
      [dicNew setValue:[patchzip getFileMD5WithPath:patchzip] forKey:@"patch zip"];
    [self writrDataWithDic:dicOld parm:rnold];
    [self writrDataWithDic:dicNew parm:rnNew];
    
}
-(void)writrDataWithDic:(NSMutableDictionary *)dic parm:(NSString *)str
{
    BOOL isYes = [NSJSONSerialization isValidJSONObject:dic];
    
    if (isYes) {
        NSLog(@"可以转换");
        
        /* JSON data for obj, or nil if an internal error occurs. The resulting data is a encoded in UTF-8.
         */
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:NULL];
        
        /*
         Writes the bytes in the receiver to the file specified by a given path.
         YES if the operation succeeds, otherwise NO
         */
        // 将JSON数据写成文件
        // 文件添加后缀名: 告诉别人当前文件的类型.
        // 注意: AFN是通过文件类型来确定数据类型的!如果不添加类型,有可能识别不了! 自己最好添加文件类型.
//             [jsonData writeToFile:[NSString stringWithFormat:@"%@%@%@%@",@"/Users/yuhao/Desktop/js版本/",zip,[self getCurrentTimes],@"/Detailed.json"] atomically:YES];
//
        NSString *txtpath =[NSString stringWithFormat:@"/%@.json",str];
        NSString *jsonstr =[NSString stringWithFormat:@"%@%@ %@%@",@"/Users/yuhao/Desktop/js版本/",rnNew,[self getCurrentTimes],txtpath];
        
        
        [jsonData writeToFile:jsonstr atomically:YES];
        
        NSLog(@"%@", [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);
        
    } else {
        
        NSLog(@"JSON数据生成失败，请检查数据格式");
        
    }
}
-(void)comparePic{
    
    //便利文件夹
    //jsversion文件夹地址
    self.imageoldArr = [NSMutableArray array];
    self.imagenewArr = [NSMutableArray array];
    NSString *jsversionCachePath = [NSString stringWithFormat:@"%@/\%@",NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0],@"1"];
     NSString *jsversionCachePath2 = [NSString stringWithFormat:@"%@/\%@",NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0],@"2"];
    NSFileManager *manager =[NSFileManager defaultManager];
    NSString *txtPath = [jsversionCachePath stringByAppendingPathComponent:@"assets"]; // 此时仅存在路径，文件并没有真实存在
    NSString *txtPath2 = [jsversionCachePath2 stringByAppendingPathComponent:@"assets"]; // 此时仅存在路径，文件并没有真实存在

    
    BOOL jsversionExist = [manager fileExistsAtPath:txtPath];
    if (jsversionExist) {
        //js文件存在
        self.imageoldArr =[manager subpathsOfDirectoryAtPath:txtPath error:nil];
       
        
    }else{
        
        
    }
    
    BOOL jsversionExist2 = [manager fileExistsAtPath:txtPath2];
    if (jsversionExist2) {
        //js文件存在
        self.imagenewArr =[manager subpathsOfDirectoryAtPath:txtPath2 error:nil];
        
        
    }else{
        
        
    }
   
    NSMutableArray *listArr = [NSMutableArray array];
    BOOL IsSame = NO;
    for (int i=0; i < self.imagenewArr.count; i++) {
        for (int j = 0; j < self.imageoldArr.count; j++) {
            if ([[NSString stringWithFormat:@"%@",[self.imagenewArr objectAtIndex:i]] isEqualToString:[NSString stringWithFormat:@"%@",[self.imageoldArr objectAtIndex:j]]]  ) {
                [self.imagenewArr removeObject:[self.imageoldArr objectAtIndex:j]];
              
            }else{
                
            }
          
        }
    }

//
    NSLog(@"图片差异%@",self.imagenewArr);
    
    //将图片拷贝到生成的目录下
    NSString *docPath = [NSString stringWithFormat:@"%@%@ %@%@",@"/Users/yuhao/Desktop/js版本/",rnNew,[self getCurrentTimes],@"/images"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:docPath]) {
        
    }else{
        [[NSFileManager defaultManager] createDirectoryAtPath:docPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    for (int i = 0; i < self.imagenewArr.count; i++) {
        NSString *oriImage=@"";
        NSString *destinImage = @"";
        if (![[self.imagenewArr objectAtIndex:i] isEqualToString:@".DS_Store"]) {
            oriImage = [txtPath2 stringByAppendingPathComponent:[self.imagenewArr objectAtIndex:i]];
            destinImage = [docPath stringByAppendingPathComponent: [[self.imagenewArr objectAtIndex:i] substringFromIndex:11]];
            [[NSFileManager defaultManager] moveItemAtPath:oriImage toPath:destinImage error:nil];
        }
    }
    
    
    
    [self.dict setValue:@"assets/res/images/tab1ybj.png" forKey:@"tab1ybj.png"];
    [self.dict setValue:@"assets/res/images/tab2znq.png" forKey:@"tab2znq.png"];
    [self.dict setValue:@"assets/res/images/tab3znq.png" forKey:@"tab3znq.png"];
    [self.dict setValue:@"assets/res/images/tab4znq.png" forKey:@"tab4znq.png"];
    
    [self writrDataWithDic:self.dict parm:@"Detailed"];
   
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
