module TestHelper
  def init_mailer(login,password)
      Mail.defaults do
        delivery_method :smtp, { :address              => "smtp.gmail.com",
                                :port                 => 587,
                                :domain               => 'gmail.com',
                                :user_name            => login,
                                :password             => password,
                                :authentication       => 'plain',
                                :enable_starttls_auto => true }  
        retriever_method :imap, 
                        :address    => 'imap.gmail.com',
                        :port       => 993,
                        :user_name  => login,
                        :password   => password,
                        :enable_ssl => true 
      end
  end

  def send_email(from,to,cc,subject,body,options={})
    mail = Mail.new do          
      to 	to
      from    from
      cc 	cc
      subject subject
      body 	body
      add_file options[:attachment] if options[:attachment]
    end   
    mail.deliver!
  end

  def wait_for_email(options, &block)
    start_time = Time.now
    wait_time = (ENV['EMAIL_WAIT_TIME'] || 60).to_i
    mail = nil

    begin
      mail = find_email(options)
      raise "not found" unless mail
    rescue
      assert(false, "Email should be received.") if (Time.now - start_time) >= wait_time
      sleep 5
      retry
    end

    if block
      block.call(mail.body)
    end
  end

  protected

  def find_email(options)    
    mails = Mail.find(:what => :last, :count => 3, :order => :asc)    
    mail  = nil

    mails.each do |m|
      result = true
      options.each_pair do |k,v|
        result = false if !v.blank? && v != m.send(k)
      end
      mail = m and break if result
    end

    mail || false
  end

end
