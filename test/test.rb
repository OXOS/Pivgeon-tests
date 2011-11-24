require File.expand_path(File.dirname(__FILE__)) + "/../helpers/test_helper.rb"

describe 'A user' do
  
  PIVGEON_APP_URL = "http://pivgeon.com/"
  PIVGEON_DOMAIN  = "pivgeon.com" 
  
  before do
    # Use email that you created Pivgeon account for
    @email = ""
    @password = ""    
    
    # Use email that no Pivgeon account is created for
    @email2 = ""
    @password2 = ""
  end

  describe "An unregistered user" do
   	   
    before do
      init_mailer(@email2,@password2) 
    end

    after do
    end
      
    it "is not able to crate new story" do
      send_email(@email2,@email2,"BidSystem-Development@#{PIVGEON_DOMAIN}","Unregistered user creates new story 1","Body")
      assert_email_received( :from => ["pivgeon@pivgeon.com"], :to => [@email2], :subject => "Re: Unregistered user creates new story 1" ) do |body_text|
        assert body_text =~ /You tried to create new story. Unfortunatelly the story hasn't been created due to following errors/
        assert body_text =~ /Unauthorized access/
      end
    end
      
  end

  describe "A registered user" do
  
    before do
      init_mailer(@email,@password) 
    end
    
    after do
    end

    it "creates new story" do
      send_email(@email,@email,"test@#{PIVGEON_DOMAIN}","Add new feature","Some more detailed explanation")
      assert_email_received( :from => ["pivgeon@pivgeon.com"], :to => [@email], :subject => "Re: Add new feature") do |body_text|
        assert body_text =~ /You have created new story .+Add new feature.+/
      end
    end

    it "creates new story for project with two-part name" do
      send_email(@email,@email,"test2@#{PIVGEON_DOMAIN}","Fix the bug","Some more detailed explanation")
      assert_email_received(:from => ["pivgeon@pivgeon.com"], :to => [@email], :subject => "Re: Fix the bug") do |body_text|
        assert body_text =~ /You have created new story .+Fix the bug+/
      end
    end

    describe "is not able to create new story" do
      
      it "due to not existing member" do
        send_email(@email,@email2,"test@#{PIVGEON_DOMAIN}","Add second feature","Some more detailed explanation")
        assert_email_received(:from => ["pivgeon@pivgeon.com"], :to => [@email], :subject => "Re: Add second feature") do |body_text|
          assert body_text =~ /A person that you try to assign to the story is not a project member/
        end
      end
      
      it "due to not existing project" do
        send_email(@email,@email,"ertyuasdafa@#{PIVGEON_DOMAIN}","Add third feature","Some more detailed explanation")
        assert_email_received(:from => ["pivgeon@pivgeon.com"], :to => [@email], :subject => "Re: Add third feature") do |body_text|
          assert body_text =~ /Project 'ertyuasdafa' that you try to create this story for does not exist/
        end
      end
      
    end

  end
 
  
end
