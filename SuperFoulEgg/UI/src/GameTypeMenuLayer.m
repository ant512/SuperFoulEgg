#import "GameTypeMenuLayer.h"
#import "SimpleAudioEngine.h"
#import "CDAudioManager.h"
#import "CocosDenshion.h"
#import "Pad.h"
#import "Settings.h"
#import "CCDirector.h"
#import "GameLayer.h"
#import "MenuRectLayer.h"
#import "GameOptionsMenuLayer.h"
#import "Constants.h"

@implementation GameTypeMenuLayer

@synthesize title = _title;

+ (CCScene *)scene {
	
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameTypeMenuLayer *layer = [GameTypeMenuLayer node];
	
	// add layer as a child to scene
	[scene addChild:layer];
	
	// return the scene
	return scene;
}

- (void)addOption:(NSString *)option {
	
	int width = 340;
	int height = 80;
	
	int y = self.boundingBox.size.height - 200 - (80 * _options.count);
	int x = (self.boundingBox.size.width - width) / 2;
	
	[self addCentredShadowedLabelWithString:option atY:y];
	
	if (_rectLayer.rectangleGroups.count == 0) {
		[_rectLayer.rectangleGroups addObject:[NSMutableArray array]];
	}
	
	[_rectLayer.rectangleGroups[0] addObject:[NSValue valueWithRect:NSMakeRect(x, y - 40, width, height)]];
	[_options addObject:option];
}

- (id)init {
	
	if ((self = [super init])) {
		
		_options = [[NSMutableArray array] retain];
		_title = @"Game Type";
		
		[self loadBackground];
		
		_rectLayer = [[MenuRectLayer alloc] init];
		[self addChild:_rectLayer];
		
		[self addCentredShadowedLabelWithString:_title atY:self.boundingBox.size.height - 100];
		
		[self addOption:@"Practice"];
		[self addOption:@"Easy"];
		[self addOption:@"Medium"];
		[self addOption:@"Hard"];
		[self addOption:@"Insane"];
		[self addOption:@"2 Player"];
		
		switch ([Settings sharedSettings].gameType) {
			case GamePracticeType:
				_rectLayer.selectedRectangleIndexes[0] = @0;
				break;
			case GameSinglePlayerType:
				switch ([Settings sharedSettings].aiType) {
					case AIEasyType:
						_rectLayer.selectedRectangleIndexes[0] = @1;
						break;
					case AIMediumType:
						_rectLayer.selectedRectangleIndexes[0] = @2;
						break;
					case AIHardType:
						_rectLayer.selectedRectangleIndexes[0] = @3;
						break;
					case AIInsaneType:
						_rectLayer.selectedRectangleIndexes[0] = @4;
						break;
				}
				break;
			case GameTwoPlayerType:
				_rectLayer.selectedRectangleIndexes[0] = @5;
				break;
		}
		
		self.isKeyboardEnabled = YES;
		
		if (![[SimpleAudioEngine sharedEngine] isBackgroundMusicPlaying]) {
			[[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"title.mp3"];
		}
	}
	
	return self;
}

- (void)dealloc {
	[_options release];
	[_title release];
	[_rectLayer release];
	
	_options = nil;
	_title = nil;
	_rectLayer = nil;
	
	[super dealloc];
}

- (void)addCentredShadowedLabelWithString:(NSString *)text atY:(CGFloat)y {
	CCLabelTTF *shadow = [CCLabelTTF labelWithString:text fontName:@"Lucida Grande" fontSize:50];
	CCLabelTTF *label = [CCLabelTTF labelWithString:text fontName:@"Lucida Grande" fontSize:50];

	shadow.position = CGPointMake((self.boundingBox.size.width / 2) - SZShadowOffset, y - SZShadowOffset);
	
	ccColor3B color;
	color.b = 0;
	color.g = 0;
	color.r = 0;
	
	shadow.color = color;
	shadow.opacity = 192;
	
	label.position = CGPointMake(self.boundingBox.size.width / 2, y);
	
	[self addChild:shadow];
	[self addChild:label];
}

- (void)loadBackground {
	int x = [[CCDirector sharedDirector] winSize].width / 2;
	int y = [[CCDirector sharedDirector] winSize].height / 2;
	
	CCSprite* background = [CCSprite spriteWithFile:@"menubackground.png"];
	background.position = ccp(x, y);
	[background.texture setAliasTexParameters];
	[self addChild:background z:0];
}

- (BOOL)ccKeyDown:(NSEvent*)event {
	
	NSString *character = [event characters];
    unichar keyCode = [character characterAtIndex:0];
	
	if (keyCode == [Settings sharedSettings].keyCodeTwoDown) {
		if ([_rectLayer selectBelowRectangle]) {
			[[SimpleAudioEngine sharedEngine] playEffect:@"move.wav"];
		}
	}
	
	if (keyCode == [Settings sharedSettings].keyCodeTwoRight) {
		[_rectLayer selectNextRectangle];
		[[SimpleAudioEngine sharedEngine] playEffect:@"move.wav"];
	}
	
	if (keyCode == [Settings sharedSettings].keyCodeTwoLeft) {
		[_rectLayer selectPreviousRectangle];
		[[SimpleAudioEngine sharedEngine] playEffect:@"move.wav"];
	}
	
	if (keyCode == [Settings sharedSettings].keyCodeTwoUp) {
		if ([_rectLayer selectAboveRectangle]) {
			[[SimpleAudioEngine sharedEngine] playEffect:@"move.wav"];
		}
	}
	
	if (keyCode == [Settings sharedSettings].keyCodeTwoA) {
		switch ([_rectLayer selectedIndexInGroup:0]) {
			case 0:
				[Settings sharedSettings].gameType = GamePracticeType;
				break;
			case 1:
				[Settings sharedSettings].gameType = GameSinglePlayerType;
				[Settings sharedSettings].aiType = AIEasyType;
				break;
			case 2:
				[Settings sharedSettings].gameType = GameSinglePlayerType;
				[Settings sharedSettings].aiType = AIMediumType;
				break;
			case 3:
				[Settings sharedSettings].gameType = GameSinglePlayerType;
				[Settings sharedSettings].aiType = AIHardType;
				break;
			case 4:
				[Settings sharedSettings].gameType = GameSinglePlayerType;
				[Settings sharedSettings].aiType = AIInsaneType;
				break;
			case 5:
				[Settings sharedSettings].gameType = GameTwoPlayerType;
				break;
		}
		
		[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:[GameOptionsMenuLayer scene]]];
	}
	
	return YES;
}

@end