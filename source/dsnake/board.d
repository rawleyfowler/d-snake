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
        Point[] _hazards;
        Snake[] _snakes;
        Snake _me;
        Point[] _food;
    }

public:
    this(JSONValue jv) @trusted
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
            auto snake = new Snake(name, name == SNAKE_NAME, body, body[0],
                s["health"].get!int, s["length"].get!int);
            return snake;
        }).array;

        _me = _snakes.filter!(s => s.me()).array[0];
    }

    Snake biggestSnake()
    {
        Snake s;

        foreach (Snake ss; _snakes)
            if (s is null)
                s = ss;
            else
                s = s.length > ss.length ? s : ss;

        return s;
    }

nothrow:
    this() @disable;
@property:
    int width()
    {
        return _width;
    }

    int height()
    {
        return _height;
    }

    Snake[] snakes()
    {
        return _snakes;
    }

    Point[] food()
    {
        return _food;
    }

    Snake me()
    {
        return _me;
    }
}
