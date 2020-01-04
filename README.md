## Joy Todos Example

This is an example app which uses the [joy web framework](https://joyframework.com).

Check it out by following the steps below

1. Make sure [janet is installed](https://janet-lang.org/docs/index.html)
2. Run the following commands in your terminal to begin

```sh
git clone https://github.com/joy-framework/example-todos
cd example-todos
jpm deps
joy create db
joy migrate
joy server
```

That last one should start a server on `http://localhost:8000` and you can click around and create, view, update and delete todos!

Not super useful, but it shows off how a simple joy app works
