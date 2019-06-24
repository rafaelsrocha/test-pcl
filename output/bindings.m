#include "bindings.h"
#include "bindings-private.h"
#include "glib.h"
#include "objc-support.h"
#include "mono_embeddinator.h"
#include "mono-support.h"

mono_embeddinator_context_t __mono_context;

MonoImage* __PCLTest_image;

static MonoClass* MyClass_class = nil;

static void __initialize_mono ()
{
	if (__mono_context.domain)
		return;
	mono_embeddinator_init (&__mono_context, "mono_embeddinator_binding");
	mono_embeddinator_install_assembly_load_hook (&mono_embeddinator_find_assembly_in_bundle);
}

void xamarin_embeddinator_initialize ()
{
	__initialize_mono ();
}

static void __lookup_assembly_PCLTest ()
{
	if (__PCLTest_image)
		return;
	__initialize_mono ();
	__PCLTest_image = mono_embeddinator_load_assembly (&__mono_context, "PCLTest.dll");
	assert (__PCLTest_image && "Could not load the assembly 'PCLTest.dll'.");
}


@implementation MyClass {
}

+ (void) initialize
{
	if (self != [MyClass class])
		return;
	__lookup_assembly_PCLTest ();
#if TOKENLOOKUP
	MyClass_class = mono_class_get (__PCLTest_image, 0x02000002);
#else
	MyClass_class = mono_class_from_name (__PCLTest_image, "", "MyClass");
#endif
}

-(void) dealloc
{
	if (_object)
		mono_embeddinator_destroy_object (_object);
}

- (nullable instancetype)init
{
	MONO_THREAD_ATTACH;
	static MonoMethod* __method = nil;
	if (!__method) {
#if TOKENLOOKUP
		__method = mono_get_method (__PCLTest_image, 0x06000001, MyClass_class);
#else
		const char __method_name [] = "MyClass:.ctor()";
		__method = mono_embeddinator_lookup_method (__method_name, MyClass_class);
#endif
	}
	if (!_object) {
		MonoObject* __instance = mono_object_new (__mono_context.domain, MyClass_class);
		MonoObject* __exception = nil;
		mono_runtime_invoke (__method, __instance, nil, &__exception);
		if (__exception) {
			NSLog (@"%@", mono_embeddinator_get_nsstring (mono_object_to_string (__exception, nil)));
			return nil;
		}
		_object = (MonoEmbedObject *)mono_embeddinator_create_object (__instance);
	}
	return self = [super init];
	MONO_THREAD_DETACH;
}

- (void)get
{
	MONO_THREAD_ATTACH;
	static MonoMethod* __method = nil;
	if (!__method) {
#if TOKENLOOKUP
		__method = mono_get_method (__PCLTest_image, 0x06000002, MyClass_class);
#else
		const char __method_name [] = "MyClass:get()";
		__method = mono_embeddinator_lookup_method (__method_name, MyClass_class);
#endif
	}
	MonoObject* __exception = nil;
	MonoObject* __instance = mono_gchandle_get_target (_object->_handle);
	mono_runtime_invoke (__method, __instance, nil, &__exception);
	if (__exception) {
		mono_embeddinator_throw_exception (__exception);
	}
	MONO_THREAD_DETACH;
}

// for internal embeddinator use only
- (int)xamarinGetGCHandle
{
	return _object->_handle;
}

// for internal embeddinator use only
- (nullable instancetype) initForSuper {
	return self = [super init];
}

@end

