//
//  WYLog.h
//  WYKit
//  简书地址：http://www.jianshu.com/u/8f8143fbe7e4
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#ifndef WYLog_h
#define WYLog_h

//  日志打印
#ifdef DEBUG
#define  NSLog(format,...) printf("\n[%s]  %s\n", __TIME__, [[NSString stringWithFormat:format, ## __VA_ARGS__] UTF8String]);
#else
#define NSLog(...)
#endif

#define NSLogFunc NSLog(@"%s",__func__);


#endif /* WYLog_h */
