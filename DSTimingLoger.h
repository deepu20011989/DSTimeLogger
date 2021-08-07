
#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, DSLoggigEvent) {
    LoggingEventCommon,
    LoggingEventCustom
};

typedef NS_ENUM(NSUInteger, DSLoggigEventType) {
    DSLoggigEventTypeStart, // does not caculate time
    DSLoggigEventTypeEnd, // calculates time since last event method call start/end
    DSLoggigEventTypeTimingOnly // calculates time since last event method call start/end , use for randon time calculation from last started event.
};


@interface DSTimingLoger : NSObject

+ (void)logMessage:(NSString *)message event:(DSLoggigEvent)event eventType:(DSLoggigEventType)eventType;

///  Session will be considered started after first log message call with DSLoggigEventTypeStart, after calling resetSession it will reset the session string and total time of the running session
+ (void)resetSession;

@end

