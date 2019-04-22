/*
 #####################################################################
 # File    : GTMObjectSingleton.h
 # Project : ios_51job
 # Created : 2012-06-27
 # DevTeam : 51job Development Team
 # Author  : yuki (yukiwang313@hotmail.com)
 # Notes   : 单例实现（网上拿来用的，google的）
 #####################################################################
 ### Change Logs   ###################################################
 #####################################################################
 ---------------------------------------------------------------------
 # Date  : 2012-07-03
 # Author: solomon (xmwen@126.com)
 # Notes :
 #    1. 增加了一个用来在头文件声明的宏 GTMOBJECT_SINGLETON_DEFINE(_class_name_)
 #    2. 简化单例实现的宏，只需传一个参数进去就可以了 GTMOBJECT_SINGLETON_IMPLEMENT(_class_name)
 #    3. 为单例新增销毁的方法（一般单例一般由系统自动回收，特殊情况下可能需要手动释放）
 #
 #####################################################################
 # Date  :
 # Author:
 # Notes :
 #
 #####################################################################
 */

/* 单例模式：声明 */
#define KIOBJECT_SINGLETON_DEFINE(_class_name_) \
+ (_class_name_ *)shared##_class_name_;          \
//+ (void)destroy##_class_name_;

/* 单例模式：实现 */
#define KIOBJECT_SINGLETON_IMPLEMENT(_class_name) KIOBJECT_SINGLETON_BOILERPLATE(_class_name, shared##_class_name)

#define KIOBJECT_SINGLETON_BOILERPLATE(_object_name_, _shared_obj_name_) \
static _object_name_ *z##_shared_obj_name_ = nil;  \
+ (_object_name_ *)_shared_obj_name_ {             \
  @synchronized(self) {                            \
    if (z##_shared_obj_name_ == nil) {             \
      /* Note that 'self' may not be the same as _object_name_ */                               \
      /* first assignment done in allocWithZone but we must reassign in case init fails */      \
      z##_shared_obj_name_ = [[self alloc] init];                                               \
    }                                              \
  }                                                \
  return z##_shared_obj_name_;                     \
}                                                  \
+ (id)allocWithZone:(NSZone *)zone {               \
  @synchronized(self) {                            \
    if (z##_shared_obj_name_ == nil) {             \
      z##_shared_obj_name_ = [super allocWithZone:zone]; \
      return z##_shared_obj_name_;                 \
    }                                              \
  }                                                \
                                                   \
  return nil;                                      \
}                                                  \
/*
- (id)retain {                                     \
return self;                                     \
}                                                  \
- (NSUInteger)retainCount {                        \
return NSUIntegerMax;                            \
}                                                  \
- (oneway void)release {                           \
}                                                  \
- (id)autorelease {                                \
return self;                                     \
}                                                  \
- (id)copyWithZone:(NSZone *)zone {                \
return self;                                     \
}                                                  \
+ (void)destroy##_object_name_ {                   \
_object_name_ *tmp_var = z##_shared_obj_name_;   \
z##_shared_obj_name_ = nil;                      \
if(nil != tmp_var){                              \
[tmp_var dealloc];                             \
}                                                \
}                                                  \

*/
