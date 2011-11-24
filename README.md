**Dependencies:**

- Ruby 1.9.2
- gem Mail

**How to use:**

1) Install required gems: `bundle install`

2) Set required variables: 

You need to specify two GMail accounts, one for email that you created Pivgeon account for and one for email that has not been used to create Pivgeon account.  

- EMAIL1, PASS1: credentials for gmail account that you created Pivgeon account for.
- EMAIL2, PASS2: credentials for gmail account that has not been used to create Pivgeon account.

Also you may want to specify two projects that tests will use to create stories for, otherwise names 'test' and 'test project' will be used.    
    
- PROJECT1: one-word test name, by default name 'test' is used.
- PROJECT2: name that contains spaces, by default name 'test project' is used.
  
NOTICE: In case when you do not set PROJECT1 and PROJECT2 make sure that you have projects 'test' and 'test project' created. 

3) Run tests: `EMAIL1=user1@gmail.com PASS1=qwerty EMAIL2=user2@gmail.com PASS2=qwerty bundle exec ruby test/test.rb`


These tests send and receive emails using libraries Net::SMTP and Net::IMAP. If they seem to be unstable try to increase time of waiting for email reception. By default this is set to 60sec, you can change it by setting environment variable EMAIL_WAIT_TIME:

`EMAIL_WAIT_TIME = 100`



