module dsnake.movement;

import dsnake.board;
import dsnake.direction;
import std.typecons;
import std.json;

class Movement
{
  private
  {
    Direction direction;
    int cost;
    Nullable!string reason;
  }

  static Movement[] from(Board board)
  {
    return [];
  }
}
