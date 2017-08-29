class UserMailerTest < ActionMailer::TestCase
  def test_welcome_email
    user = users(:dbachinin)
 
    # Send the email, then test that it got queued
    email = UserMailer.welcome_email(user).deliver
    assert !ActionMailer::Base.deliveries.empty?
 
    # Test the body of the sent email contains what we expect it to
    assert_equal [user.email], email.to
    assert_equal "Welcome to Hotel", email.subject
    assert_match(/<h1>Welcome to example.com, #{user.name}<\/h1>/, email.encoded)
    assert_match(/Welcome to example.com, #{user.name}/, email.encoded)
  end
end