require 'test_helper'
require 'ostruct'
require 'exception_notification/notifier'
require 'exception_notification/notifiable'

class ExceptionNotifierNotifiableTest < Test::Unit::TestCase

  class IgnoredException < Exception; end

  class InheritingFromIgnoredException < IgnoredException; end

  class Controller
    include ExceptionNotification::Notifiable

    def response
      OpenStruct.new(:status => 200)
    end
  end

  def setup
    @controller = Controller.new
  end

  # No controller
  
  def test_should_allow_delivery_of_regular_exceptions
    ExceptionNotification::Notifier.ignore_exceptions = [IgnoredException]
    assert @controller.send(:deliver_exception_notification?, StandardError.new)
  end

  def test_should_not_allow_delivery_of_ignored_exceptions
    ExceptionNotification::Notifier.ignore_exceptions = [IgnoredException]
    assert !@controller.send(:deliver_exception_notification?, IgnoredException.new)

    ExceptionNotification::Notifier.ignore_exceptions = %w[ExceptionNotifierNotifiableTest::IgnoredException]
    assert !@controller.send(:deliver_exception_notification?, IgnoredException.new)
  end
  
  def test_should_not_allow_delivery_of_descendants_of_ignored_exceptions
    ExceptionNotification::Notifier.ignore_exceptions = [IgnoredException]
    assert !@controller.send(:deliver_exception_notification?, InheritingFromIgnoredException.new)

    ExceptionNotification::Notifier.ignore_exceptions = %w[ExceptionNotifierNotifiableTest::IgnoredException]
    assert !@controller.send(:deliver_exception_notification?, InheritingFromIgnoredException.new)
  end

end
