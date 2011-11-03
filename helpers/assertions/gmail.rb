# These assertions are compatible with gmail with english language set in settings.
# They do tests using html basic view for gmail.
module Assertions
	module Gmail
    def assert_logged_in(email,password)
      visit "http://gmail.com"
      fill_in "Email", :with => email
      fill_in "Passwd", :with => password   
      assert_appears("#loading") do
        click_button "Sign in"   
      end
      wait_until { has_css?("iframe#canvas_frame") }
      assert_basic_html_view
      wait_until{ has_css?("#guser b.gb4", :text => email) }
    end

    def assert_logged_out   
      click_link "Sign out"   
      assert has_css?("#gaia_loginform")
    end

    def assert_email_sent(subject,body,to,cc)
      find("a",:text => "Compose Mail").click
      wait_until { has_css?("textarea[name='to']") }
      fill_in("to", :with => to)
      fill_in("cc", :with => cc)
      fill_in("subject", :with => subject)      
      fill_in("body", :with => body)      
      assert_appears("b", :text => "Your message has been sent.") do
        find("input[name='nvp_bu_send']").click
      end
    end

    def assert_email_received(from,subject,&block)
      start_time = Time.now
      wait_time = 50
      success = false

      begin
        visit "http://mail.google.com/?ui=html"
        within("form[name='f'] table.th tbody tr:nth-child(1)") do           
          if find("td:nth-child(2)").text =~ Regexp.new(from) && find("td:nth-child(3)").text =~ Regexp.new(subject)              
            success = true
          else
            raise "timeout"                  
          end
        end  
      rescue
        assert false if (Time.now - start_time) >= wait_time
        sleep 3
        retry
      end

      if block
        within("form[name='f'] table.th tbody tr:nth-child(1)") do      
          find("td:nth-child(3) a").click        
        end

        wait_until { find("table.h tr:first h2 b").text =~ /#{subject}/ }

        body = all("div.msg").last.text     

        block.call(body)
      end
    end        

    def assert_basic_html_view()
      visit "http://mail.google.com/?ui=html"
      find("td#bm b", :text => "basic HTML")
    end
	end
end
