//
//  WYDisPatch.h
//  WYKit
//  博客地址：https://www.wncblog.top
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#import <Foundation/Foundation.h>

@interface WYDispatch : NSObject

/**************************************************************************/

/** GCD后台执行（同步或异步） */
+ (void)dispatch_async:(BOOL)async
            Background:(void(^)(void))actionBlock;


/** GCD主线程执行（同步或异步） */
+ (void)dispatch_async:(BOOL)async
                  Main:(void(^)(void))actionBlock;


/** GCD一次性执行执行（同步函数） */
+ (void)dispatch_asyncOnce:(void(^)(void))actionBlock;


/** GCD指定延迟时间执行（异步函数） */
+ (void)dispatch_asyncDelay:(NSTimeInterval)time
                     action:(void(^)(void))actionBlock;



/**************************************************************************/

/** GCD并行执行开始，多个线程同时执行（异步函数） */
+ (void)dispatch_asyncGroupParallelStart:(dispatch_group_t)group
                                  action:(void (^)(void))actionBlock;


/** GCD并行执行结束，多个线程执行都完成（异步函数） */
+ (void)dispatch_asyncGroupParallelFinish:(dispatch_group_t)group
                                   action:(void (^)(void))actionBlock;




/**************************************************************************/

/** GCD串行执行，逐个执行开始（asynchronous=YES时，逐个执行，否则无顺序同时执行。注：两者须一致） */
+ (void)dispatch_asyncGroupSerialStart:(dispatch_queue_t)queue
                          Asynchronous:(BOOL)async
                                action:(void (^)(void))actionBlock;


/** GCD串行执行，逐个执行到最后（asynchronous=YES时，逐个执行，否则无顺序同时执行。注：两者须一致） */
+ (void)dispatch_asyncGroupSerialFinish:(dispatch_queue_t)queue
                           Asynchronous:(BOOL)async
                                 action:(void (^)(void))actionBlock;




/**************************************************************************/

/** GCD多次执行某个指定方法（同步函数） */
+ (void)dispatch_asyncApply:(NSInteger)count
                     action:(void (^)(NSInteger index))actionBlock;



@end
