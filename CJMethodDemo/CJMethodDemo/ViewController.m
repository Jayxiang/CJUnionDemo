//
//  ViewController.m
//  runtimeDemo
//
//  Created by tet-cjx on 2019/4/26.
//  Copyright © 2019 hyd-cjx. All rights reserved.
//

#import "ViewController.h"
#import <objc/message.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *protocolLabel;
@property (weak, nonatomic) IBOutlet UILabel *ivarLabel;
@property (weak, nonatomic) IBOutlet UILabel *methodLabel;
@property (weak, nonatomic) IBOutlet UILabel *classMethodLabel;

/** 属性测试 */
@property (nonatomic, strong) NSString *name;

@end

@implementation ViewController {
    NSString *test;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.name = @"小明";
}
- (IBAction)getClassClick:(id)sender {
    [self getClassMethod];
}
- (void)getClassMethod {
    Class metaClass = object_getClass([self class]);
    unsigned int count;
    Method *classMethods = class_copyMethodList(metaClass, &count);
    for (int i = 0; i < count; i++) {
        Method classMethod = classMethods[i];
        SEL selector = method_getName(classMethod);
        NSString *name = NSStringFromSelector(selector);
        NSLog(@"类方法：%@",name);
        self.classMethodLabel.text = [NSString stringWithFormat:@"%@%@--",self.classMethodLabel.text,name];
        if ([name isEqualToString:@"classMethodTest"]) {
            [ViewController performSelector:selector];
        }
    }
    free(classMethods);
}
- (IBAction)methodClick:(id)sender {
    [self getMethod];
}
- (void)getMethod {
    unsigned int count;
    Method *methods = class_copyMethodList([self class], &count);
    for (int i = 0; i < count; i++) {
        Method method = methods[i];
        SEL selector = method_getName(method);
        NSString *name = NSStringFromSelector(selector);
        NSLog(@"实例方法：%@",name);
        self.methodLabel.text = [NSString stringWithFormat:@"%@%@--",self.methodLabel.text,name];
        if ([name isEqualToString:@"getIvarAndChange"]) {
//            [self performSelector:selector];
        }
    }
    free(methods);
}
- (IBAction)ivarClick:(id)sender {
    [self getIvarAndChange];
}
- (void)getIvarAndChange {
    NSLog(@"修改前:%@", self.name);
    unsigned int count = 0;
    Ivar *members = class_copyIvarList([self class], &count);
    for(int i = 0; i < count; i++) {
        Ivar ivar = members[i];
        const char *memberName = ivar_getName(ivar);
        const char *memberType = ivar_getTypeEncoding(ivar);
        //依次打印属性名称和属性类型
        NSLog(@"%s : %s", memberName, memberType);
        NSString *ivarStr = [NSString stringWithFormat:@"%@属性：%s--类型：%s\n",self.ivarLabel.text,memberName,memberType];
        self.ivarLabel.text = ivarStr;
        if(strcmp(memberName, "_name") == 0) {
            // 修改前
            NSString *name = (NSString *)object_getIvar(self, members[i]);
            NSLog(@"-name:%@", name);
            // 修改后
            object_setIvar(self, members[i], @"test");
            NSString *nameReset = (NSString *)object_getIvar(self, members[i]);
            NSLog(@"-nameReset:%@", nameReset);
            break;
        }
    }
    free(members);
    NSLog(@"修改后:%@", self.name);
}
- (IBAction)getProtocolClick:(id)sender {
    [[self methodListWithProtocol:@protocol(JXProtocol)] enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj = [NSString stringWithFormat:@"%@--%@",self.protocolLabel.text,obj];
        self.protocolLabel.text = obj;
    }];
}
//协议获取
- (NSArray<NSString *> *)methodListWithProtocol:(Protocol *)protocol {
    unsigned int count = 0;
    NSMutableArray<NSString *> *methodList = @[].mutableCopy;
    struct objc_method_description *methods = protocol_copyMethodDescriptionList(protocol, YES, YES, &count);
    for (unsigned int i = 0; i < count; i++) {
        struct objc_method_description method = methods[i];
        NSString *name = NSStringFromSelector(method.name);
        [methodList addObject:name];
    }
    free(methods);
    return methodList;
}
//方法测试
+ (void)classMethodTest {
    
}
+ (void)classMethodTestOne {
    
}
@end

