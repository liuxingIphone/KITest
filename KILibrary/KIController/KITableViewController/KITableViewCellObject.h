//
//  KITableViewCellObject.h
//  Kitalker
//
//  Created by chen on 12-9-4.
//
//

#import <Foundation/Foundation.h>

@interface KITableViewCellObject : NSObject {
    NSString    *_uid;
    NSString    *_title;
    NSString    *_subTitle;
}

@property (nonatomic, retain) NSString *uid;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *subTitle;

@end
