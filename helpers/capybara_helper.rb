require 'capybara/dsl'

Capybara.current_driver = :selenium
MiniTest::Unit::TestCase.send(:include,Capybara::DSL)