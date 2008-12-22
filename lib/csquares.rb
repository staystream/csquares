$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'csquares/core_ext'
require 'csquares/csquares'

module CSquares
  VERSION = '0.1.0'
end
