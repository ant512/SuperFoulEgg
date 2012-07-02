#import "TitleScreenLayer.h"
#import "SimpleAudioEngine.h"
#import "CDAudioManager.h"
#import "CocosDenshion.h"
#import "Pad.h"
#import "Settings.h"
#import "CCDirector.h"
#import "ZombieLayer.h"

@implementation ZombieLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	ZombieLayer *layer = [ZombieLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id) init
{
	if ((self = [super init])) {
		self.isKeyboardEnabled = YES;
		
		_frames = 0;
		
		[self loadSounds];
		[self loadBackground];
		
		[self scheduleUpdate];
	}
	return self;
}

- (void)loadSounds {
	[[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"title.mp3"];
	[[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"title.mp3"];
}

- (void)loadBackground {
	int x = [[CCDirector sharedDirector] winSize].width / 2;
	int y = [[CCDirector sharedDirector] winSize].height / 2;
	
	CCSprite* background = [CCSprite spriteWithFile:@"zombie.png"];
	background.position = ccp(x, y);
	[background.texture setAliasTexParameters];
	[self addChild:background z:0];
}

- (void)update:(ccTime)dt {
	
	++_frames;
	
	ccColor3B color;
	color.b = 255;
	color.g = 255;
	color.r = 255;
	
	if (_frames == 200) {
		[[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration:1.0f scene:[TitleScreenLayer scene] withColor:color]];
	}
}

- (BOOL)ccKeyUp:(NSEvent*)event {
	ccColor3B color;
	color.b = 255;
	color.g = 255;
	color.r = 255;
	
	[[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration:1.0f scene:[TitleScreenLayer scene] withColor:color]];
	
	return YES;
}

@end
