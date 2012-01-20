# Load the rails application
require File.expand_path('../application', __FILE__)

EXCEPTION_NOTIFIER_OPTIONS = {
  :email_prefix => "[Dummy ERROR] ",
  :sender_address => %{"Dummy Notifier" <dummynotifier@example.com>},
  :exception_recipients => %w{dummyexceptions@example.com},
  :sections => ['new_section', 'request', 'session', 'environment', 'backtrace']
}

Dummy::Application.config.middleware.use ExceptionNotifier, EXCEPTION_NOTIFIER_OPTIONS

# Initialize the rails application
Dummy::Application.initialize!
