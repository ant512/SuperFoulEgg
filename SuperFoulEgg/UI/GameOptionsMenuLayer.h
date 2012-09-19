#import "CCLayer.h"

#import "cocos2d.h"
#import "MenuRectLayer.h"
#import "MenuControlsLayer.h"

@interface GameOptionsMenuLayer : CCLayer {
	MenuRectLayer *_rectLayer;
	MenuControlsLayer *_controlsLayer;
	NSMutableArray *_options;
}

+ (CCScene*)scene;
- (id)init;
- (void)loadBackground;

@end
