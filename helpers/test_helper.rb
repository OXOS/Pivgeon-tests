require 'minitest/autorun'
require 'mail'
require File.expand_path(File.dirname(__FILE__)) + "/helper_methods.rb"
require File.expand_path(File.dirname(__FILE__)) + "/capybara_helper.rb"

MiniTest::Unit::TestCase.send(:include,TestHelper)
