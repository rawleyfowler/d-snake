module dsnake.strategy.flood;

import dsnake.strategy.strategy : Strategy;
import dsnake.movement : Movement;
import dsnake.board : Board;

class Flood : Strategy
{
@safe:
    override Movement[] analyze(immutable Board b) immutable
    {
        return [];
    }
}
