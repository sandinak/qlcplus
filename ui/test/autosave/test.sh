#!/bin/bash

# Test autosave functionality

TESTNAME="Autosave_Test"

# Source common test functions if available
if [ -f "../../../scripts/test_functions.sh" ]; then
    source ../../../scripts/test_functions.sh
fi

# Build and run the test
qmake
make
./autosave_test

