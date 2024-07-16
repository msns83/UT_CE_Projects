#ifndef PROP
#define PROP

#include <string>
#include <vector>

const std::string Game_Name = "Bomber Man";
const std::string Map_Address = "./Import/map.txt";
const std::string DYING_BY_LIVES_TEXT = "Game Over !";
const std::string DYING_BY_TIME_TEXT = "Time is up !";
const std::string WINING_TEXT = "Win !";

const int Resolution = 50;
const int BOMB_LIMIT = 3;
const int BOMB_TIMER = 2;
const int ENEMY_MOVE_DURATION = 300;
const int LIVES_COUNT = 2;
const int KEYS_COUNT = 3;
const int POWERUP_TYPE_COUNT = 1;
const int FREEZE_TIME = 10;
const float FONT_SCALE = 1.8;

const std::string FontAddress = "./assets/calibri.ttf";
const std::string Player_PIC = "./assets/cat.png";
const std::string ENEMY_PIC = "./assets/dog.png";
const std::string BOMB_PIC = "./assets/cream.png";
const std::string TEMP_BLOCK_PIC = "./assets/box.png";
const std::string BLOCK_PIC = "./assets/stone.png";
const std::string KEY_PIC = "./assets/poultry.png";
const std::string DOOR_PIC = "./assets/hole.png";
const std::string POWERUP1_PIC = "./assets/heart.png";
const std::string POWERUP2_PIC = "./assets/snow.png";

const char SEPERATOR = ',';
const std::string EMPTY = "-";
const std::string BLOCK = "B";
const std::string TEMP_BLOCK = "T";
const std::string VER_ENEMY = "V";
const std::string HOR_ENEMY = "H";
const std::string DOOR = "D";

enum Direction
{
    LEFT,
    UP,
    RIGHT,
    DOWN,
    SAME
};
enum Gained
{
    KEY_OBJ,
    DOOR_OBJ,
    POWERUP_OBJ,
    NULL_OBJ
};
const std::vector<int> delta_x = {-Resolution, 0, Resolution, 0, 0};
const std::vector<int> delta_y = {0, -Resolution, 0, Resolution, 0};

#endif