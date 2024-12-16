module dsnake.snake;

import dsnake.point;

class Snake {

  private {
    Point[] _body;
    Point _head;
    bool _me;
    string _name;
  }

  public string name() {
    return _name;
  }

  public Point[] body() {
    return _body;
  }

  public Point head() {
    return _head;
  }

  public bool isMe() {
    return _me;
  }
}
