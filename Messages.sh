#!/bin/bash

$XGETTEXT $(find src/ -name \*.cpp -o -name \*.h -o -name \*.qml) -o $podir/index-fm.pot
