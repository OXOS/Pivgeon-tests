module Assertions
	module Base
    def assert_appears(selector,options={},&block)
      assert has_no_css?(selector, options)
      block.call
      wait_until{ has_css?(selector, options) }
    end
	end
end
