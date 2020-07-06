//
//  CJLocks.m
//  CJXTimer
//
//  Created by Jayxiang on 2020/5/12.
//  Copyright © 2020 cjxjay. All rights reserved.
//

#import "CJLocks.h"
#import <libkern/OSAtomic.h>
#import <os/lock.h>
#import <pthread.h>

@implementation CJLocks
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"

// OSSpinLock：”自旋锁”，等待锁的线程会处于忙等（busy-wait）状态，一直占用着CPU资源
// 目前已经不再安全，可能会出现优先级反转问题
- (void)osSpinLock {
    // 初始化
    OSSpinLock spinLock = OS_SPINLOCK_INIT;
    // 加锁
    OSSpinLockLock(&spinLock);
    // 解锁
    OSSpinLockUnlock(&spinLock);
}

#pragma clang diagnostic pop

// os_unfair_lock用于取代不安全的OSSpinLock ，从iOS10开始才支持
- (void)osUnfairLock {
    // 初始化
    os_unfair_lock unfairLock = OS_UNFAIR_LOCK_INIT;
    // 加锁
    os_unfair_lock_lock(&unfairLock);
    // 解锁
    os_unfair_lock_unlock(&unfairLock);
}

// mutex叫做”互斥锁”，等待锁的线程会处于休眠状态
- (void)pthreadNormal {
    // 初始化属性
    pthread_mutexattr_t attr;
    pthread_mutexattr_init(&attr);
    // PTHREAD_MUTEX_NORMAL 普通锁
    pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_NORMAL);
    // 初始化
    pthread_mutex_t mutex;
    pthread_mutex_init(&mutex, &attr);
    // 加锁
    pthread_mutex_lock(&mutex);
    // 解锁
    pthread_mutex_unlock(&mutex);
    //销毁
    pthread_mutexattr_destroy(&attr);
    pthread_mutex_destroy(&mutex);
}
// 递归锁
- (void)pthreadRecursive {
    // 初始化属性
    pthread_mutexattr_t attr;
    pthread_mutexattr_init(&attr);
    // PTHREAD_MUTEX_RECURSIVE 递归锁
    pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE);
    // 初始化
    pthread_mutex_t mutex;
    pthread_mutex_init(&mutex, &attr);
}
// 条件锁
- (void)pthreadCond {
    // 初始化
    pthread_mutex_t mutex;
    pthread_mutex_init(&mutex, NULL);
    // 初始化条件
    pthread_cond_t condition;
    pthread_cond_init(&condition, NULL);
    // 等待条件（进入休眠，放开 mutex 锁，被唤醒后再次加锁）
    pthread_cond_wait(&condition, &mutex);
    // 激活一个等待该条件的线程
    pthread_cond_signal(&condition);
    // 激活所有等待该条件的线程
    pthread_cond_broadcast(&condition);
    //销毁
    pthread_mutex_destroy(&mutex);
    pthread_cond_destroy(&condition);
}
// NSLock 是对 pthread_mutex 普通锁的封装,使用简单
// NSRecursiveLock 是对 pthread_mutex 递归锁的封装
// NSCondition 是对 pthread_mutex 和 cond 的封装
// NSConditionLock 是对 NSCondition 的进一步封装，可以设置具体的条件值
- (void)nsLock {
    NSLock *lock = [[NSLock alloc] init];
    [lock lock];
    [lock unlock];
    
    NSRecursiveLock *recursiveLock = [[NSRecursiveLock alloc] init];
    [recursiveLock lock];
    [recursiveLock unlock];
}
// dispatch_semaphore 叫做”信号量”
// 信号量的初始值，可以用来控制线程并发访问的最大数量
// 信号量的初始值为1，代表同时只允许1条线程访问资源，保证线程同步
- (void)semaphoreLock {
    // 初始化信号量
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
    // 如果信号量的值<=0，当前线程就会进入休眠等待（直到信号量的值>0）
    // 如果信号量的值大于0，就减1，然后执行后面的代码
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    // 让信号量的值加1
    dispatch_semaphore_signal(semaphore);
}
// 直接使用GCD的串行队列，也是可以实现线程同步的
- (void)serialQueue {
    dispatch_queue_t queue = dispatch_queue_create("lock_queue", DISPATCH_QUEUE_SERIAL);
    dispatch_sync(queue, ^{
        
    });
}
// @synchronized是对 pthread_mutex 递归锁的封装
- (void)synchronizedLock {
    @synchronized (self) {
        // 任务
    }
}
// 多读单写方案 pthread_rwlock 读写锁
- (void)pthreadRwLock {
    // 初始化
    pthread_rwlock_t lock;
    pthread_rwlock_init(&lock, NULL);
    // 读加锁
    pthread_rwlock_rdlock(&lock);
    // 写加锁
    pthread_rwlock_wrlock(&lock);
    // 解锁
    pthread_rwlock_unlock(&lock);
    // 销毁
    pthread_rwlock_destroy(&lock);
}
// 多读单写方案 dispatch_barrier_async 异步栅栏调用
// 这个函数传入的并发队列必须是自己通过dispatch_queue_cretate创建的
// 如果传入的是一个串行或是一个全局的并发队列，那这个函数便等同于dispatch_async函数的效果
- (void)barrierLock {
    // 初始化队列
    dispatch_queue_t queue = dispatch_queue_create("rw_queue", DISPATCH_QUEUE_CONCURRENT);
    // 读
    dispatch_async(queue, ^{
        
    });
    // 写
    dispatch_barrier_async(queue, ^{
        
    });
}
@end
