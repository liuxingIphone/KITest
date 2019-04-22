//
//  KIUncaughtExceptionHandler.h
//  Kitalker
//
//  Created by chen on 12-8-31.
//
//

#import <Foundation/Foundation.h>

@interface KIUncaughtExceptionHandler : NSObject {    
	BOOL dismissed;
}

@end

void InstallUncaughtExceptionHandler();