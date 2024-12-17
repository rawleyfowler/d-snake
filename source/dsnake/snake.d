module dsnake.snake;

import dsnake.point;

class Snake
{
@safe:
    private immutable
    {
        Point[] _body;
        Point _head;
        int _health;
        int _length;
        bool _me;
        string _name;
    }

public:

    this(string name, bool me, immutable Point[] body, Point head, int health, int length) immutable
    {
        _name = name;
        _me = me;
        _body = body;
        _head = head;
        _health = health;
        _length = length;
    }

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

    Point head()
    {
        return _head;
    }

    bool isMe()
    {
        return _me;
    }
}
