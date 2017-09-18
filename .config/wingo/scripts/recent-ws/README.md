Description
===========

A pair of scripts for the Wingo window manager to allow users to
switch to the most recent (and no longer visible) workspace.

The first script `recent-ws` runs continuously and watches for
workspace change events, keeping track of the most recent/last
visible workspace.  Typically, one would run this script as a
startup hook in Wingo.

The second script `recent-ws-switch` switches to the most
recent/last workspace.  Typically, one would bind this script
to a keyboard shortcut.


Example
=======

Here's how to use `recent-ws` in Wingo's `hooks.wini` configuration file:
```
  startup := Script "recent-ws/recent-ws"
```

Here's how to bind `recent-ws-switch` to a key in Wingo's `key.wini` file:

```
  Mod4-Tab := Script "recent-ws/recent-ws-switch -g"
  Mod4-Shift-Tab := Script "recent-ws/recent-ws-switch -g -c"
```

`recent-ws-switch` takes two command-line options.  The `-g` option
uses the "greedy" flavor of workspace switching commands.  The `-c` options
uses the "with client" flavor of workspace switching commands.  See the Wingo
documentation for more details.


Dependencies
============

The script requires

* pywingo (>= 0.0.11)


Details
=======

`recent-ws` uses a roundabout way of tracking the most 
recent/last workspace.  The `ChangedVisibleWorkspace`
callback is called _after_ the workspace has already
changed, but it doesn't pass in the previous workspace.
Since `recent-ws` is a long-running pywingo program, we can 
keep track with some global state.

`recent-ws-switch` needs a way to look up the most recent workspace
when the users wants to go there.  Thus, `recent-ws` stores the
most recent workspace as a property of the root window in X called
`_WINGO_TAG_recent_ws`.  The `recent-ws-switch` script retrieves that
property.

Ideally, there would be a way to call into the long-running pywingo
`recent-ws` script when a key is pressed (e.g., a "SendMessage" command
that could post an event to pywingo with an arbitrary string argument),
but that isn't available in the current version of Wingo.  Such a feature
would eliminate the need for two scripts and the need to use any X
properties.
