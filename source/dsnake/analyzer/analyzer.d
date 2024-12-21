module dsnake.analyzer.analyzer;

import dsnake.board : Board;
import dsnake.movement : Movement;

abstract class Analyzer
{
    protected
    {
        Board _board;
    }

    this(Board board)
    {
        _board = board;
    }

    public abstract Movement analyze(Movement movement);

@disable:
    this();
}
