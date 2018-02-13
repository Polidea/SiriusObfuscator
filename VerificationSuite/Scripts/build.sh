#!/bin/bash

swift build -c release -Xswiftc -static-stdlib

cp $(swift build -c release --show-bin-path)/VerificationSuite .

