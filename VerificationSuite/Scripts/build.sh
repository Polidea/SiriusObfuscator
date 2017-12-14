#!/bin/bash

swift build -c release

cp $(swift build -c release --show-bin-path)/VerificationSuite .

