module dsnake.point;

import dsnake.direction;
import std.json;
import std.algorithm;
import std.array;

class Point
{

    override bool opEquals(const Object p) const
    {
        if (auto point = cast(Point) p)
        {
            return point.x == this.x && point.y == this.y;
        }

        return false;
    }

@safe:

    public const int x;
    public const int y;

    this(int x, int y) immutable
    {
        this.x = x;
        this.y = y;
    }

    this(int x, int y)
    {
        this.x = x;
        this.y = y;
    }

    override size_t toHash() const nothrow
    {
        ulong xs = 0 | x;
        ulong ys = 0 | y;
        ys = ys << 32;
        return xs | ys;
    }

    Point move(Direction d)
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

        return new Point(nx, ny);
    }

    static Point[] fromJSONCoordinates(scope JSONValue jv) @trusted
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

        return jv.array
            .map!((p) {
                return p.type == JSONType.OBJECT
                    ? fromJSONCoordinates(p) : throw new Exception("EXPECTED OBJECT GOT " ~ p.type);
            })
            .reduce!((a, b) => a ~ b)
            .array;
    }

@disable:
    this();
}
