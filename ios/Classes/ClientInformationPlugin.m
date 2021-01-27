#import "ClientInformationPlugin.h"
#if __has_include(<client_information/client_information-Swift.h>)
#import <client_information/client_information-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "client_information-Swift.h"
#endif

@implementation ClientInformationPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftClientInformationPlugin registerWithRegistrar:registrar];
}
@end
