#import <Foundation/Foundation.h>

#define DEFAULT_KEY_CODE_LEFT 0xF702
#define DEFAULT_KEY_CODE_RIGHT 0xF703
#define DEFAULT_KEY_CODE_UP 0xF700
#define DEFAULT_KEY_CODE_DOWN 0xF701
#define DEFAULT_KEY_CODE_A 0x78
#define DEFAULT_KEY_CODE_B 0x7A
#define DEFAULT_KEY_CODE_START 0x0D

typedef enum {
	AIHardType = 0,
	AIMediumType = 3,
	AIEasyType = 6
} AIType;

typedef enum {
	GamePracticeType = 0,
	GameSinglePlayerType = 1
} GameType;

@interface Settings : NSObject {
	AIType _aiType;
	GameType _gameType;
	int _height;
	int _speed;
	BOOL _isDropManual;
	int _gamesPerMatch;
	int _blockColours;
	unichar _keyCodeLeft;
	unichar _keyCodeRight;
	unichar _keyCodeUp;
	unichar _keyCodeDown;
	unichar _keyCodeA;
	unichar _keyCodeB;
	unichar _keyCodeStart;
}

@property(readwrite) AIType aiType;
@property(readwrite) GameType gameType;
@property(readwrite) int height;
@property(readwrite) int speed;
@property(readwrite) BOOL isDropManual;
@property(readwrite) int gamesPerMatch;
@property(readwrite) int blockColours;
@property(readwrite) unichar keyCodeLeft;
@property(readwrite) unichar keyCodeRight;
@property(readwrite) unichar keyCodeUp;
@property(readwrite) unichar keyCodeDown;
@property(readwrite) unichar keyCodeA;
@property(readwrite) unichar keyCodeB;
@property(readwrite) unichar keyCodeStart;

+ (Settings*)sharedSettings;
- (id)init;

@end
