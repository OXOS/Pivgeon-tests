require File.expand_path(File.dirname(__FILE__)) + "/../helpers/test_helper.rb"

describe 'A user' do

  # Use email that you created Pivgeon account for
  EMAIL1    = ENV['EMAIL1']
  PASSWORD1 = ENV['PASS1']

  # Use another email that you created Pivgeon account for
  EMAIL2    = ENV['EMAIL2']

  # Use email that no Pivgeon account is created for
  EMAIL3    = ENV['EMAIL3']
  PASSWORD3 = ENV['PASS3']

  PROJECT_NAME             = ENV['PROJECT1'] || "test"
  PROJECT_NAME_WITH_SPACES = ENV['PROJECT2'] || "test project"

  TOKEN = ENV['TOKEN']

  describe "An unregistered user" do

    describe "is able to" do

      before do
        init_mailer(EMAIL1,PASSWORD1)
      end

      it "create new Pivgeon account" do
        email = EMAIL1.split('@')
        email = "#{email[0]}+pivgeon_#{Time.now.hash}#{rand 10000}@#{email[1]}"

        visit "http://pivgeon.com/users/new"

        fill_in "Email", :with => email
        fill_in "Pivotal token", :with => TOKEN
        click_button "Create"

        assert has_content?("Thank you! Please confirm your email by clicking the link we've just sent you.")

        activation_url = ""
        wait_for_email( :from => ["pivgeon@pivgeon.com"], :to => [email], :subject => "Pivgeon - new account activation." ) do |body_text|
          activation_url = body_text.match(/<a.*>(http:\/\/.*)<\/a>$/)[1]
          assert body_text =~ /In order complete the registration process use link <a.*\/a>/
        end

        visit activation_url
        assert has_content?("Your account has been activated")
      end

    end

    describe "is not able to" do

      before do
        init_mailer(EMAIL3,PASSWORD3)
      end

      it "crate new story" do
				subject = "Unregistered user creates new story #{Time.now.hash}"
        send_email(EMAIL3,EMAIL3,"#{PROJECT_NAME}@pivgeon.com",subject,"Body")
        wait_for_email( :from => ["pivgeon@pivgeon.com"], :to => [EMAIL3], :subject => "Re: #{subject}" ) do |body_text|
          assert body_text =~ /You tried to create new story. Unfortunatelly the story hasn't been created due to following errors/
          assert body_text =~ /Unauthorized access/
        end
      end

    end
           
  end

  describe "A registered user" do

    before do
      init_mailer(EMAIL1,PASSWORD1)
    end

    it "creates new story owned by him" do
			subject = "Add new feature #{Time.now.hash}"
      send_email(EMAIL1,EMAIL1,"#{PROJECT_NAME}@pivgeon.com",subject,"Some more detailed explanation")
      wait_for_email( :from => ["pivgeon@pivgeon.com"], :to => [EMAIL1], :subject => "Re: #{subject}") do |body_text|
        assert body_text =~ /You have created new story .+Add new feature.+/
      end
    end

    it "creates new story owned by other user" do
			subject = "Implement new feature #{Time.now.hash}"
      send_email(EMAIL1,EMAIL2,"#{PROJECT_NAME}@pivgeon.com",subject,"Some more detailed explanation")
      wait_for_email( :from => ["pivgeon@pivgeon.com"], :to => [EMAIL1], :subject => "Re: #{subject}") do |body_text|
        assert body_text =~ /You have created new story .+Implement new feature.+/
      end
    end

    it "creates new story for project with space" do
      project_name = PROJECT_NAME_WITH_SPACES.split(' ').join
			subject = "Fix the bug #{Time.now.hash}"
      send_email(EMAIL1,EMAIL1,"#{project_name}@pivgeon.com",subject,"Some more detailed explanation")
      wait_for_email(:from => ["pivgeon@pivgeon.com"], :to => [EMAIL1], :subject => "Re: #{subject}") do |body_text|
        assert body_text =~ /You have created new story .+Fix the bug+/
      end
    end

    describe "is not able to create new story" do

      it "due to not existing member" do
				subject = "Add second feature #{Time.now.hash}"
        send_email(EMAIL1,EMAIL3,"#{PROJECT_NAME}@pivgeon.com",subject,"Some more detailed explanation")
        wait_for_email(:from => ["pivgeon@pivgeon.com"], :to => [EMAIL1], :subject => "Re: #{subject}") do |body_text|
          assert body_text =~ /A person that you try to assign to the story is not a project member/
        end
      end

      it "due to not existing project" do
				subject = "Add third feature #{Time.now.hash}"
        send_email(EMAIL1,EMAIL1,"ertyuasdafa@pivgeon.com",subject,"Some more detailed explanation")
        wait_for_email(:from => ["pivgeon@pivgeon.com"], :to => [EMAIL1], :subject => "Re: #{subject}") do |body_text|
          assert body_text =~ /Project 'ertyuasdafa' that you try to create this story for does not exist/
        end
      end

    end

  end
 
  
end
