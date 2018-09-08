--[[

Guide to GS2SDK written by Mr_Iron2.

-----

Welcome to the GameStation 2 Software
Development Kit (GS2SDK)! This guide will
help you get to grips with what is possible
and will hopefully give you some ideas.

-----
APIs:
The GS2 has many flexible and powerful APIs
to ensure you can write concise code which is
readable, easy and efficient. These include a few
standard, third party APIs - which you can read into
by yourself from their official documentation - but
this also includes a selection of tailored APIs
exclusively for GS2!

EE: The GS2's "Emotion Engine" API allows you to
perform CPU functions in a concise form. The EE has
functionality for maths, bit-shifting, parallelisation,
timers and much more! It's a very robust API for general
processing. Things that can be done with it include
making a calculator, a GPS program, a URLencoder, a JSON
serializer, a clock and much more! You can read into it
yourself by editing /GS2/APIs/ee and seeing all the functions
for yourself; they are very straightforward and easy to
understand, like GS.

GS: The GS2's "Graphics Synthesizer" API is an API
designed for processing graphics and rendering tasks.
These range from simple nice-to-haves such as one-line
functions for clearing the screen to a given background,
to more complex functions like wrapping to a monitor, a ton
of paintutils commands that can be called on-the-fly and
setting up windows/displays! Some things you could make
with GS include a paint program, a psuedo-3D game, a
platformer, a high-resolution rendering demo and lots of other
things! It is a full replacement for term and paintutils while
including commands of its own and other miscellaneous
functions.

VU: The most complex API of them all, the "Vector Unit" API
is for only the most advanced CC programs. The VU allows for
parallelising programs and an array of vector-based processes.
Vectors act a lot like tables, storing coordinate data with
labels "x", "y" and "z". However, it can be worthwhile to use
vectors instead of tables in certain situations. Among other
things, vectors can be useful to aid in creating navigation
programs using GPS coordinates. By making good use of vectors,
code can be cleaner and easier to follow.
--]]


print("Edit me to read!")
