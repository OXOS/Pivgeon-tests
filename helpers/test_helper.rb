require 'minitest/autorun'
require 'capybara/dsl'

Capybara.current_driver = :selenium
Capybara.default_wait_time = 20

require File.expand_path(File.dirname(__FILE__)) + "/assertions.rb"
MiniTest::Unit::TestCase.send(:include,Assertions::Base)
MiniTest::Unit::TestCase.send(:include,Assertions::Gmail)
MiniTest::Unit::TestCase.send(:include,Capybara::DSL)
