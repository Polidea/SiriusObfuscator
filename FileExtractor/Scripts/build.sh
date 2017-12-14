#!/bin/bash

HOMEBREW_NO_AUTO_UPDATE=1 brew install rbenv
eval "$(rbenv init -)"
rbenv install 2.2.2
gem install bundler
bundle install
bundle exec rake package:osx

