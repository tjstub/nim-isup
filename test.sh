#!/usr/bin/env bash
# This is a terrible example of a test suit - but then, isup is a
# pretty dead simple tool so I didn't wish to over-do it. Please
# overlook my lapse, as I wouldn't ship important code like this
# :)

if ! command -v isup; then
    echo "Install isup tool!"
    echo "e.g., nimble install"
    echo "Failed!"
    exit 1
fi

if ! isup www.google.com; then
    echo "This is the happy path which failed"
    echo "Failed!"
    exit 1
fi

if isup; then
    echo "this should return with an error code."
    echo "Failed!"
    exit 1
fi

if ! isup www.google.com amazon.com; then
    echo "This case should succeed!"
    echo "Failed!"
    exit 1
fi


isup --help
isup -h


if isup --unknownflag; then
    echo "Unknown flags should cause failures!"
    echo "Failed!"
    exit 1
fi

echo "Adhoc testing complete!"
