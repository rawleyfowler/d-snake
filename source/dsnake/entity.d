module dsnake.entity;

import std.json;

abstract class Entity
{
    abstract JSONValue json();
}
