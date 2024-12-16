module dsnake.board;

import dsnake.point;
import dsnake.snake;

import std.json;

class Board
{

  private
  {
    int _height;
    int _width;
    Point[] hazards;
    Point[] food;
    Snake[] snakes;
  }

  public int width()
  {
    return _width;
  }

  public int height()
  {
    return _height;
  }

  public static Board fromJSON(scope JSONValue jv)
  {
    auto board = new Board;
    return board;
  }

}
