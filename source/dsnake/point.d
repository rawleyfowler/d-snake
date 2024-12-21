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

    override int opCmp(Object o) const
    {
        if (auto p = cast(Point) o)
            return (this.x - p.x) + (this.y - p.y);

        throw new Exception("Cant CMP non point with point");
    }

    override size_t toHash() const nothrow
    {
        return hashOf(x, y);
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
        if (jv.type != JSONType.ARRAY && jv.type != JSONType.OBJECT)
        {
            throw new Exception("EXPECTED ARRAY OR OBJECT GOT " ~ jv.type);
        }

        if (jv.type == JSONType.OBJECT)
        {
            auto p = new Point(jv["x"].get!int, jv["y"].get!int);
            return [p];
        }

        auto points = jv.array.map!(p => p.type == JSONType.OBJECT
                ? fromJSONCoordinates(p) : throw new Exception("EXPECTED OBJECT GOT " ~ p.type))
            .array;
        return reduce!((a, b) => a ~ b)(cast(Point[])[], points);
    }

@disable:
    this();
}
