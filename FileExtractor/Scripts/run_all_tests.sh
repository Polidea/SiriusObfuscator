#!/bin/bash

eval "$(rbenv init -)"
bundle exec bacon spec/*

