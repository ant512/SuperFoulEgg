#import "Settings.h"

@implementation Settings

@synthesize aiType = _aiType;
@synthesize gameType = _gameType;
@synthesize height = _height;
@synthesize speed = _speed;
@synthesize isDropManual = _isDropManual;

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
	}
	return self;
}

@end
