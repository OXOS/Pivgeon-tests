module TestHelper
  def init_mailer(login,password)
    smtp_conn = Net::SMTP.new('smtp.gmail.com', 587)
    smtp_conn.enable_starttls           
    smtp_conn.start('smtp.gmail.com', login, password, :plain)

    Mail.defaults do
      delivery_method  :smtp_connection, { :connection => smtp_conn }  
      retriever_method :imap, 
                        :address    => 'imap.gmail.com',
                        :port       => 993,
                        :user_name  => login,
                        :password   => password,
                        :enable_ssl => true 
    end
  end

  def send_email(from,to,cc,subject,body)
    mail = Mail.new do          
      to 	to
      from    from
      cc 	cc
      subject subject
      body 	body  
    end   
    mail.deliver!
  end

  def assert_email_received(options, &block)
    start_time = Time.now
    wait_time = (ENV['EMAIL_WAIT_TIME'] || 60).to_i
    mail = nil

    begin
      mail = Mail.last
      success = true

      options.each_pair do |k,v|
        success = false if !v.blank? && v != mail.send(k)
      end

      raise "not found" unless success
    rescue
      assert(false, "Email should be received.") if (Time.now - start_time) >= wait_time
      sleep 3
      retry
    end

    if block
      block.call(mail.body)
    end
  end         

end
