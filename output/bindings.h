#include "embeddinator.h"
#import <Foundation/Foundation.h>


#if !__has_feature(objc_arc)
#error Embeddinator code must be built with ARC.
#endif

#ifdef __cplusplus
extern "C" {
#endif
// forward declarations
@class MyClass;


NS_ASSUME_NONNULL_BEGIN


/** Class MyClass
 *  Corresponding .NET Qualified Name: `MyClass, PCLTest, Version=1.0.7114.27516, Culture=neutral, PublicKeyToken=null`
 */
@interface MyClass : NSObject {
	// This field is not meant to be accessed from user code
	@public MonoEmbedObject* _object;
}

- (nullable instancetype)init;


- (void)get;
/** This selector is not meant to be called from user code
 *  It exists solely to allow the correct subclassing of managed (.net) types
 */
- (nullable instancetype)initForSuper;

@end

NS_ASSUME_NONNULL_END

#ifdef __cplusplus
} /* extern "C" */
#endif
