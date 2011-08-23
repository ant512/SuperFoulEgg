#import "Settings.h"

@implementation Settings

@synthesize aiType = _aiType;
@synthesize gameType = _gameType;
@synthesize height = _height;
@synthesize speed = _speed;
@synthesize isDropManual = _isDropManual;
@synthesize gamesPerMatch = _gamesPerMatch;
@synthesize blockColours = _blockColours;
@synthesize keyCodeLeft = _keyCodeLeft;
@synthesize keyCodeRight = _keyCodeRight;
@synthesize keyCodeUp = _keyCodeUp;
@synthesize keyCodeDown = _keyCodeDown;
@synthesize keyCodeA = _keyCodeA;
@synthesize keyCodeB = _keyCodeB;
@synthesize keyCodeStart = _keyCodeStart;

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
		_gameType = GameSinglePlayerType;
		_height = 0;
		_speed = 0;
		_isDropManual = YES;
		_gamesPerMatch = 3;
		_blockColours = 4;

		_keyCodeLeft = DEFAULT_KEY_CODE_LEFT;
		_keyCodeRight = DEFAULT_KEY_CODE_RIGHT;
		_keyCodeUp = DEFAULT_KEY_CODE_UP;
		_keyCodeDown = DEFAULT_KEY_CODE_DOWN;
		_keyCodeA = DEFAULT_KEY_CODE_A;
		_keyCodeB = DEFAULT_KEY_CODE_B;
		_keyCodeStart = DEFAULT_KEY_CODE_START;
	}
	return self;
}

@end
