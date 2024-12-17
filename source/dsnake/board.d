module dsnake.board;

import dsnake.point;
import dsnake.snake;
import dsnake.constant;

import std.algorithm.iteration;
import std.json;
import std.array;

class Board
{
@safe:

    private
    {
        const uint _height;
        const uint _width;
        immutable(Point)*[] _food;
        immutable(Point)*[] _hazards;
        immutable(Snake)[] _snakes;
    }

public:
    @property int width()
    {
        return _width;
    }

    @property int height()
    {
        return _height;
    }

    this(JSONValue jv) immutable @trusted
    {
        auto board_json = jv["board"].object;
        _height = board_json["height"].get!uint;
        _width = board_json["width"].get!uint;

        _food = Point.fromJSONCoordinates(board_json["food"]);
        _hazards = Point.fromJSONCoordinates(board_json["hazards"]);

        auto snake_json = board_json["snakes"].array;
        _snakes = snake_json.map!((s) {
            auto name = s["name"].get!string;
            auto body = Point.fromJSONCoordinates(s["body"]);
            auto snake = new immutable Snake(name, name == SNAKE_NAME, body,
                body[0], s["health"].get!int, s["length"].get!int);
            return snake;
        }).array;
    }

@disable:
    this();
}
