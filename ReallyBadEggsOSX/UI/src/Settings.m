#import "Settings.h"

@implementation Settings

@synthesize aiType = _aiType;
@synthesize gameType = _gameType;
@synthesize height = _height;
@synthesize speed = _speed;
@synthesize isDropManual = _isDropManual;
@synthesize gamesPerMatch = _gamesPerMatch;
@synthesize blockColours = _blockColours;

+ (Settings*)sharedSettings {
	static Settings* _sharedSettings;

	@synchronized(self) {
		if (!_sharedSettings) _sharedSettings = [[Settings alloc] init];

		return _sharedSettings;
	}
}

- (id)init {
	if ((self = [super init])) {
		_aiType = AIEasyType;
		_gameType = GamePracticeType;
		_height = 0;
		_speed = 0;
		_isDropManual = YES;
		_gamesPerMatch = 3;
		_blockColours = 4;
	}
	return self;
}

@end
