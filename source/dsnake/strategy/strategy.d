module dsnake.strategy.strategy;

import dsnake.movement : Movement;
import dsnake.board : Board;

abstract class Strategy
{
@safe:
public:
    abstract Movement[] analyze(immutable Board b) immutable;
}
