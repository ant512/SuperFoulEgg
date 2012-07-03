#import <Foundation/Foundation.h>

#import "cocos2d.h"
#import "RectLayer.h"

@interface MainMenuLayer : CCLayer {
	RectLayer *_rectLayer;
	NSMutableArray *_options;
}

@property (readwrite, retain, nonatomic) NSString *title;

+ (CCScene*)scene;
- (id)init;
- (void)loadBackground;
- (void)addOption:(NSString *)option;

@end
