#import "AppCenterPlugin.h"
#if __has_include(<appcenter/appcenter-Swift.h>)
#import <appcenter/appcenter-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "appcenter-Swift.h"
#endif

@implementation AppCenterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftAppCenterPlugin registerWithRegistrar:registrar];
}
@end
