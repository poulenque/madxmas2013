Survival guide for dumb persons
===============================

  If you are completely lost and have no idea what the hell you are doing right now,
  you can run this magical command that may solve all your problems in your life :

```
$ make run
```

  This magical command will compile everything for you and might spawn some ponies far from your computer
  to make someone happy.

  You might want to read the output because it will compile love2d that may require some
  libraries. If something is missing it will bother you and make the program unable
  to spawn ponies correctly. 

```
$ make run | grep -i error
```

  might be useful to see why love2d is whining and wasting everyone's time !
     


Quick start guide
=================

  Execute:
    $ make
  This will build madxmas2013.love. You can then run the game with LÖVE as follow:
    $ love madxmas2013.love

  If you don't have LÖVE installed or the version you have doesn't work with
  madxmas2013 then you can use the following targets to build a suitable version
  of the game engine:

  You can build LÖVE and an executable of the game with:
    $ make binary
  Then run the madxmas2013 executable:
    $ ./madxmas2013

  There's also a "run" target that takes care of everything:
    $ make run
  This will compile the game engine, pack the game, generate the executable and
  run it.

Compiling the LÖVE game engine
==============================

  Compile the LÖVE game engine with the following command (it is also compiled
  by the "binary" and "run" targets):
    $ make love
  The configure script may tell you there are missing dependencies, in which
  case you must install them and run "make love" again.

vim: set et ts=2 sts=2 sw=2 tw=80 :
