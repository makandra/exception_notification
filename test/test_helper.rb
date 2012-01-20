require 'test/unit'
require 'rubygems'
require 'active_support'
require 'action_pack'

RAILS_ROOT = '.' unless defined?(RAILS_ROOT)

$:.unshift File.join(File.dirname(__FILE__), '../lib')
require 'exception_notification'
