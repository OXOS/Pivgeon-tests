**Dependencies:**

- Ruby 1.9.2
- gem Mail
- gem Capybara

**How to use:**

1) Install required gems: `bundle install`

2) Set required environment variables:

- **EMAIL1, PASS1:** credentials for GMail account that has been used to create Pivgeon account. This email account will be used to create new stories.
- **EMAIL2:** email address (does not have to be GMail email address) that has been used to create Pivgeon account. This address will be used for testing case when one project member creates story assigned to other project member.
- **EMAIL3, PASS3:** credentials for GMail account that has not been used to create Pivgeon account. This email account will be used to test cases when unregistered user tries to use Pivgeon application  to create new story.
- **TOKEN:** valid Pivotal Tracker token that will be used to test new user registration.

Also you may want to specify two projects that tests will use to create stories for, otherwise names 'test' and 'test project' will be used.    
    
- PROJECT1: one-word test name, by default name 'test' is used.
- PROJECT2: name that contains spaces, by default name 'test project' is used.
  
NOTICE: In case when you do not set PROJECT1 and PROJECT2 make sure that you have projects 'test' and 'test project' created. 

3) Run tests: `TOKEN=654123 EMAIL1=user1@gmail.com PASS1=qwerty EMAIL2=user2@example.com EMAIL3=user3@gmail.com PASS3=qwerty bundle exec ruby test/test.rb`


These tests send and receive emails using libraries Net::SMTP and Net::IMAP. If they seem to be unstable try to increase time of waiting for email reception. By default this is set to 60sec, you can change it by setting environment variable EMAIL_WAIT_TIME:

`EMAIL_WAIT_TIME = 100`



