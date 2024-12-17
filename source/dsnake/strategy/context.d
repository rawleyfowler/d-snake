module dsnake.strategy.context;

import dsnake.strategy.strategy : Strategy;

class StrategyContext
{
@safe:
    private static immutable Strategy[] strategies = [];
    public static immutable(Strategy[]) getStrategies()
    {
        return strategies;
    }
}
