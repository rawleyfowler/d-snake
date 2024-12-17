module dsnake.point;

import dsnake.direction;
import std.json;
import std.algorithm;
import std.array;

struct Point
{
@safe:
    immutable int x;
    immutable int y;

    this(int x, int y) immutable
    {
        this.x = x;
        this.y = y;
    }

    bool equals(Point p)
    {
        return p.x == this.x && p.y == this.y;
    }

    immutable(Point*) move(Direction d) immutable
    {
        int nx = this.x;
        int ny = this.y;

        final switch (d)
        {
        case Direction.UP:
            ny++;
            break;
        case Direction.DOWN:
            ny--;
            break;
        case Direction.LEFT:
            nx--;
            break;
        case Direction.RIGHT:
            nx++;
            break;
        }

        return new immutable Point(nx, ny);
    }

    static immutable(Point)*[] fromJSONCoordinates(immutable JSONValue jv) @trusted
    {
        if (jv.type != JSONType.ARRAY || jv.type != JSONType.OBJECT)
        {
            throw new Exception("EXPECTED ARRAY OR OBJECT GOT " ~ jv.type);
        }

        if (jv.type == JSONType.OBJECT)
        {
            auto p = new immutable Point(jv["x"].get!int, jv["y"].get!int);
            return [p];
        }

        return jv.array.map!(p => new immutable Point(p["x"].get!int, p["y"].get!int)).array;
    }

@disable:
    this();
}
