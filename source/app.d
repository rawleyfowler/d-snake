import archttp;
import dsnake.board;
import dsnake.movement;
import std.json;
import std.functional;
import std.stdio;

const string VERSION = "1";

void main()
{
    auto app = new Archttp;

    app.get("/", toDelegate(&index));
    app.get("/end", toDelegate(&end));
    app.get("/start", toDelegate(&start));

    app.listen(8080);
}

void index(scope HttpRequest _, scope HttpResponse res)
{
    JSONValue response = [
        "apiversion": VERSION,
        "author": "rawley fowler",
        "color": "#FF6962",
        "head": "all-seeing",
        "tail": "mystic-moon"
    ];
    res.send(response);
}

void end(scope HttpRequest _, scope HttpResponse res)
{
    writeln("DONE GAME!");
    res.send("DONE!");
}

void start(scope HttpRequest _, scope HttpResponse res)
{
    writeln("STARTING GAME!");
    res.send("STARTING!");
}

void move (scope HttpRequest req, scope HttpResponse res)
{
    auto board = Board.fromJSON(parseJSON(req.body));
    res.write(JSONValue(["foo": "bar"]));
}
