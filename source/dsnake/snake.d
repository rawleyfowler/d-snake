module dsnake.snake;

import dsnake.point;

class Snake
{
    private
    {
        Point[] _body;
        Point _head;
        int _health;
        int _length;
        bool _me;
        string _name;
    }

public:

    this(string name, bool me, Point[] body, Point head, int health, int length)
    {
        _name = name;
        _me = me;
        _body = body;
        _head = head;
        _health = health;
        _length = length;
    }

@safe:
@property:
    int health()
    {
        return _health;
    }

    int length()
    {
        return _length;
    }

    string name()
    {
        return _name;
    }

    immutable(Point[])
    body()
    {
        return _body;
    }

    immutable(Point) head()
    {
        return _head;
    }

    bool isMe()
    {
        return _me;
    }
}
