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
      assert_logged_in(@email2,@password2) 
    end

    after do
      assert_logged_out
    end
      
    it "is not able to crate new story" do
      assert_email_sent("Unregistered user creates new story 1","Body",@email2,"BidSystem-Development@#{PIVGEON_DOMAIN}")
      assert_email_received("me, Pivgeon \\(\\d\\)","Unregistered user creates new story 1") do |body_text|
        assert body_text =~ /You tried to create new story. Unfortunatelly the story hasn't been created due to following errors/
        assert body_text =~ /Unauthorized access/
      end
    end
      
	end
 
  describe "A registered user" do
  
    before do
      assert_logged_in(@email,@password)    
    end
    
    after do
      assert_logged_out
    end
    
    it "creates new story" do
      assert_email_sent("Add new feature","Some more detailed explanation",@email,"test@#{PIVGEON_DOMAIN}")
      assert_email_received("me, Pivgeon \\(\\d\\)","Add new feature") do |body_text|
        assert body_text =~ /You have created new story Add new feature/
      end
    end

		it "creates new story for project with two-part name" do
    	assert_email_sent("Change new feature","Body",@email,"test2@#{PIVGEON_DOMAIN}")
  		assert_email_received("me, Pivgeon \\(\\d\\)","Change new feature") do |body_text|
        assert body_text =~ /You have created new story Change new feature/
      end
    end
    
    describe "is not able to create new story" do
      
      it "due to not existing member" do
        assert_email_sent("Add second feature","Some more detailed explanation",@email2,"test@#{PIVGEON_DOMAIN}")
      	assert_email_received("me, Pivgeon \\(\\d\\)","Add second feature") do |body_text|
        	assert body_text =~ /A person that you try to assign to the story is not a project member/
      	end
      end
      
      it "due to not existing project" do
        assert_email_sent("Add third feature","Some more detailed explanation",@email2,"ertyuasdafa@#{PIVGEON_DOMAIN}")
      	assert_email_received("me, Pivgeon \\(\\d\\)","Add third feature") do |body_text|
        	assert body_text =~ /Project 'ertyuasdafa' that you try to create this story for does not exist/
      	end
      end
      
    end
        
  end 
  
end
