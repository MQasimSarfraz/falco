#!/bin/bash

function error_exit_good
{
    echo "Error: '$1' did not parse" 1>&2
    exit 1
}

function error_exit_bad
{
    echo "Error: incorrect filter '$1' parsed ok" 1>&2
    exit 1
}


function good
{
    lua5.1 test.lua "a: x.y=1; b: a and z.x exists; c: b; $1" 2> /dev/null || error_exit_good "$1"
}

function bad
{
    lua5.1 test.lua "a: x.y=1; b: a and z.x exists; c: b; $1" 2> /dev/null && error_exit_bad "$1"
}

# Filters
good "  "
good "  a"
good "a and b"
good "(a)"
good "(a and b)"
good "(a.a exists and b)"
good "(a.a exists) and (b)"
good "a.a exists and b"
good "a.a=1 or b.b=2 and c"
good "not (a)"
good "not (not (a))"
good "not (a.b=1)"
good "not (a.a exists)"
good "not a"
good "a.b = 1 and not a"
good "not not a"
good "(not not a)"
good "not a.b=1"
good "not a.a exists"
good "notz: a and b; notz"
good "a.b = bla"
good "a.b = 'bla'"
good "a.b = not"
good "a.b contains bla"
good "a.b icontains 'bla'"
good "a.g in (1, 'a', b)"
good "a.g in ( 1 ,, , b)"
good "evt.dir=> and fd.name=*.log"
good "evt.dir=> and fd.name=/var/log/httpd.log"
good "a.g in (1, 'a', b.c)"
good "a.b = a.a"
good "a.b = a.a |"
good "a.b = a.a | %evt.type %fd.num blabla"

bad "a.g in ()"
bad "a.b = b = 1"
bad "(a.b = 1"
bad " | %a.b"
# Macros

good "a: a.b exists"
good "a: b and c"
good "a: b"
good "a : b"
good "a : evt.dir=>"
good "inbound: (syscall.type=listen and evt.dir='>') or (syscall.type=accept and evt.dir='<')"
bad "a:"
bad "a : b | bla"


echo
echo "All tests passed."
exit 0