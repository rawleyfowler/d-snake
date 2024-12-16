module dsnake.point;

import dsnake.direction;

struct Point {
  int x;
  int y;

  bool equals(Point p) {
    return p.x == this.x && p.y == this.y;
  }

  Point move(Direction d) {
    auto p = new Point;
    p.x = this.x;
    p.y = this.y;

    switch(d) {
    case Direction.UP:
      p.y++;
      break;
    case Direction.DOWN:
      p.y--;
      break;
    case Direction.LEFT:
      p.x--;
      break;
    case Direction.RIGHT:
      p.x++;
      break;
    };

    return p;
  }
}
