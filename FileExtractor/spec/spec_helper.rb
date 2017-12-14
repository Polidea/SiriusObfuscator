require 'rubygems'
require 'bacon'
require 'mocha-on-bacon'
require 'pretty_bacon'

lib = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(lib)

require 'file-extractor'
