**Dependencies:**

- Ruby 1.9.2
- gem Mail

**How to use:**

1. Install required gems: `bundle install`

2. Set missing variables in file test/test.rb (lines 10..15). You need to specify two GMail accounts, one for email that you created Pivgeon account for and one for email that has not been used to create Pivgeon account.

3. Run tests: `bundle exec ruby test/test.rb`


These tests send and receive emails using libraries Net::SMTP and Net::IMAP. If they seem to be unstable try to increase time of waiting for email reception. By default this is set to 60sec, you can change it by setting environment variable EMAIL_WAIT_TIME:

`EMAIL_WAIT_TIME = 100`

