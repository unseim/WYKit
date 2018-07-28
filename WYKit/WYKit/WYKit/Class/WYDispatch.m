//
//  WYDispatch.m
//  WYKit
//  博客地址：https://www.wncblog.top
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#import "WYDispatch.h"
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@implementation WYDispatch

/**************************************************************************/

// dispatch_async的使用

#pragma mark - GCD后台执行（同步或异步）
+ (void)dispatch_async:(BOOL)async
            Background:(void(^)(void))actionBlock
{
    // 后台执行
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    if (async)
    {
        // 异步
        dispatch_async(queue, ^{
            // something
            if (actionBlock)
            {
                actionBlock();
            }
        });
    }
    else
    {
        // 同步
        dispatch_sync(queue, ^{
            // something
            if (actionBlock)
            {
                actionBlock();
            }
        });
    }
}


#pragma mark - GCD主线程执行（同步或异步）
+ (void)dispatch_async:(BOOL)async
                  Main:(void(^)(void))actionBlock
{
    if (async)
    {
        // 主线程执行-异步
        dispatch_async(dispatch_get_main_queue(), ^{
            // something
            if (actionBlock)
            {
                actionBlock();
            }
        });
    }
    else
    {
        // 主线程执行-同步
        dispatch_async(dispatch_get_main_queue(), ^{
            // something
            if (actionBlock)
            {
                actionBlock();
            }
        });
    }
}

#pragma mark - GCD一次性执行执行（同步函数）
+ (void)dispatch_asyncOnce:(void(^)(void))actionBlock
{
    // 一次性执行
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // code to be executed once
        if (actionBlock)
        {
            actionBlock();
        }
    });
}

#pragma mark - GCD指定延迟时间执行（异步函数）
+ (void)dispatch_asyncDelay:(NSTimeInterval)time
                     action:(void(^)(void))actionBlock
{
    // 延迟执行
    NSTimeInterval delayInSeconds = time;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        if (actionBlock)
        {
            actionBlock();
        }
    });
}






/**************************************************************************/

/*
 dispatch_group_async的使用
 dispatch_group_async可以实现监听一组任务是否完成，完成后得到通知执行其他的操作。
 这个方法很有用，比如你执行三个下载任务，当三个任务都下载完成后你才通知界面说完成的了。
 */

#pragma mark - GCD并行执行开始，多个线程同时执行（异步函数）
+ (void)dispatch_asyncGroupParallelStart:(dispatch_group_t)group
                                  action:(void (^)(void))actionBlock
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_async(group, queue, ^{
        if (actionBlock)
        {
            actionBlock();
        }
    });
}

#pragma mark - GCD并行执行结束，多个线程执行都完成（异步函数）
+ (void)dispatch_asyncGroupParallelFinish:(dispatch_group_t)group
                                   action:(void (^)(void))actionBlock
{
    dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_group_notify(group, queue, ^{
        if (actionBlock)
        {
            actionBlock();
        }
    });
}






/**************************************************************************/

/*
 dispatch_barrier_async的使用
 dispatch_barrier_async是在前面的任务执行结束后它才执行，而且它后面的任务等它执行完成之后才会执行
 */

#pragma mark - GCD串行执行，逐个执行开始（asynchronous=YES时，逐个执行，否则无顺序同时执行。注：两者须一致）
+ (void)dispatch_asyncGroupSerialStart:(dispatch_queue_t)queue
                          Asynchronous:(BOOL)async
                                action:(void (^)(void))actionBlock
{
    //    dispatch_queue_t queue = dispatch_queue_create(charString, DISPATCH_QUEUE_CONCURRENT);
    
    if (async)
    {
        // 异步
        dispatch_async(queue, ^{
            if (actionBlock)
            {
                actionBlock();
            }
        });
    }
    else
    {
        // 同步
        dispatch_sync(queue, ^{
            if (actionBlock)
            {
                actionBlock();
            }
        });
    }
    
}

#pragma mark - GCD串行执行，逐个执行到最后（asynchronous=YES时，逐个执行，否则无顺序同时执行。注：两者须一致）
+ (void)dispatch_asyncGroupSerialFinish:(dispatch_queue_t)queue
                           Asynchronous:(BOOL)async
                                 action:(void (^)(void))actionBlock
{
    //    dispatch_queue_t queue = dispatch_queue_create(charString, DISPATCH_QUEUE_CONCURRENT);
    
    if (async)
    {
        // 异步
        dispatch_barrier_async(queue, ^{
            if (actionBlock)
            {
                actionBlock();
            }
        });
    }
    else
    {
        // 同步
        dispatch_barrier_sync(queue, ^{
            if (actionBlock)
            {
                actionBlock();
            }
        });
    }
}





/**************************************************************************/

/*
 dispatch_apply方法中的全部处理任务执行结束
 执行某个代码片段N次。
 
 */

#pragma mark - GCD多次执行某个指定方法（同步函数）
+ (void)dispatch_asyncApply:(NSInteger)count
                     action:(void (^)(NSInteger index))actionBlock
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_apply(count, queue, ^(size_t index){
        if (actionBlock)
        {
            actionBlock(index);
        }
    });
}



@end




