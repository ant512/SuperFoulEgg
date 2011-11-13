#import "MainMenuLayer.h"
#import "SimpleAudioEngine.h"
#import "CDAudioManager.h"
#import "CocosDenshion.h"
#import "Pad.h"
#import "Settings.h"
#import "CCDirector.h"
#import "GameLayer.h"

@implementation MainMenuLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	MainMenuLayer *layer = [MainMenuLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id) init
{
	if ((self = [super init])) {
		
		sranddev();
		
		self.isKeyboardEnabled = YES;
		
		[self loadBackground];
	}
	return self;
}

- (void)loadBackground {
	int x = [[CCDirector sharedDirector] winSize].width / 2;
	int y = [[CCDirector sharedDirector] winSize].height / 2;
	
	CCSprite* title = [CCSprite spriteWithFile:@"menubackground.png"];
	title.position = ccp(x, y);
	[title.texture setAliasTexParameters];
	[self addChild:title z:0];
}

- (BOOL)ccKeyUp:(NSEvent*)event {
	
	[[SimpleAudioEngine sharedEngine] stopBackgroundMusic]; 
	[[CCDirector sharedDirector] replaceScene: [GameLayer scene]];
	
	return YES;
}

@end
