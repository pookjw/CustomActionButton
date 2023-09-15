//
//  init.mm
//  CustomActionButton
//
//  Created by Jinwoo Kim on 9/15/23.
//

#import <UIKit/UIKit.h>
#import <objc/message.h>
#import <objc/runtime.h>

namespace SBActionButtonMetric {
namespace handleEvent_withContext {
static void (*original)(id self, SEL _cmd, NSUInteger event, id context);
static void custom(id self, SEL _cmd, NSUInteger event, id context) {
    original(self, _cmd, event, context);
    
    /*
     context -> SBAnalyticsContextProvider
     eventPayload -> SBSAnalyticsState
     */
    
    id eventPayload = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(context, NSSelectorFromString(@"eventPayload"));
    NSString * _Nullable type = reinterpret_cast<id (*)(id, SEL, id)>(objc_msgSend)(eventPayload, @selector(objectForKeyedSubscript:), @"type");
    
    // Pressed, LongPressed, nil (released button)
    if (![type isEqualToString:@"Pressed"]) return;
    
    [NSOperationQueue.mainQueue addOperationWithBlock:^{
        reinterpret_cast<void (*)(id, SEL)>(objc_msgSend)(UIApplication.sharedApplication, NSSelectorFromString(@"takeScreenshot"));
    }];
}

static void swizzle() {
    Method method = class_getInstanceMethod(NSClassFromString(@"SBActionButtonMetric"), NSSelectorFromString(@"handleEvent:withContext:"));
    original = reinterpret_cast<void (*)(id, SEL, NSUInteger, id)>(method_getImplementation(method));
    method_setImplementation(method, reinterpret_cast<IMP>(&custom));
}
}
}

__attribute__((constructor)) static void init() {
    SBActionButtonMetric::handleEvent_withContext::swizzle();
}
