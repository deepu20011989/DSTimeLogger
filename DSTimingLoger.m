

#import "DSTimingLoger.h"

#define IgnoreConstant 1

//Mili seconds
static NSTimeInterval sessionTime = 0.0;

//Text for completed session
static NSString *sessionText = @"";

//Initil date nil at initial time
static NSDate *initialDate = nil;

//Ignoring (number of times) variable reset to consider a session completed
static NSTimeInterval sessionCountToBeIgnore = 0;

@implementation DSTimingLoger

+ (void)logMessage:(NSString *)message event:(DSLoggigEvent)event eventType:(DSLoggigEventType)eventType {
    
    //fined the Event name text
    NSString *eventName = [DSTimingLoger eventNameForEvent:event];
    
    if (eventType == DSLoggigEventTypeStart) {
        
        // current date set when event starts
        initialDate = [NSDate date];
       
        // log for event started
        NSLog(@"DSTimingLoger | %@: | %@ | Start |", eventName, message);
        
    } else {
        
        // check initial date and return if it is nil, it means session not stated yet
        if(initialDate == nil) {
            NSLog(@"Event logging session not yet started...");
            return;
        }
        
        NSTimeInterval timeTaken = ([[NSDate date] timeIntervalSinceDate: initialDate] * 1000); // multiply by 1000 to convert it to miliseconds.
        
        // update initial date after calculating time difference.
        initialDate = [NSDate date];
        
        // create log message and then print Logs
        NSString *logText = [NSString stringWithFormat: @"DSTimingLoger | %@: | %@ | End | Time Taken: %f", eventName, message, timeTaken];
        NSLog(@"%@", logText);
        
        // updating session variables
        [DSTimingLoger updatedSessionWithTime: timeTaken message: logText];

    }
    
}

+ (void)resetSession {
    
    //update session ignore count
    sessionCountToBeIgnore = sessionCountToBeIgnore + 1;

    // create log message and then print Logs
    NSString *logtext = [NSString stringWithFormat: @"DSTimingLoger | Total Time (ms): %f", sessionTime];
    NSLog(@"%@", logtext);
    
    // updatng final session variable before finalizing them, no time update required so passes 0 in time
    [DSTimingLoger updatedSessionWithTime: 0.0 message: logtext];
    
    //finalizing session variables
    sessionTime = 0.0;

    if (sessionCountToBeIgnore >= IgnoreConstant) {
        //print complete session text in Logs
        NSLog(@"Session Text = %@", sessionText);
        sessionText = @"";
    }
    
}

//MARK: - Private Methods -
+ (NSString *)eventNameForEvent:(DSLoggigEvent)event {
    switch (event) {
        case LoggingEventCustom:
            return @"Custom Logging";
        default:
            return @"Common Logging";
    }
}

+ (void)updatedSessionWithTime:(NSTimeInterval)timeinterval message:(NSString *)message {
    sessionTime = sessionTime + timeinterval;
    NSMutableString *str = [NSMutableString stringWithString: sessionText];
    [str appendString:@"\n"];
    [str appendString:message];
    sessionText = str;
}

@end
