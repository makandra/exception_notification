require 'test_helper'

class ExceptionNotifierTest < ActiveSupport::TestCase

  class TestException < StandardError
  end
   
  class InheritedTestException < TestException
  end

  def setup
    ExceptionNotifier::Notifier.deliveries.clear
  end

  def run_with_notifier(options = {}, &block)
    Rack::Builder.new do
      use ExceptionNotifier, EXCEPTION_NOTIFIER_OPTIONS.merge(options)
      run lambda { |env| block.call if block; [200, {'Content-Type' => 'text/plain'}, 'OK'] }
    end.call({})
  end

  def test_should_deliver_exception
    begin
      run_with_notifier do
        raise TestException.new("some error")
      end
    rescue TestException
    end

    begin
      run_with_notifier(:ignore_exceptions => %w[ExceptionNotifierTest::AnotherException]) do
        raise TestException.new("some error")
      end
    rescue TestException
    end

    assert_equal 2, ExceptionNotifier::Notifier.deliveries.size
  end

  def test_should_ignore_ignored_errors
    begin
      run_with_notifier(:ignore_exceptions => [TestException]) do
        raise TestException.new("some error")
      end
    rescue TestException
    end
    begin
      run_with_notifier(:ignore_exceptions => %w[ExceptionNotifierTest::TestException]) do
        raise TestException.new("some error")
      end
    rescue TestException
    end
    assert_equal 0, ExceptionNotifier::Notifier.deliveries.size
  end

  def test_should_ignore_inherited_ignored_errors
    begin
      run_with_notifier(:ignore_exceptions => %w[ExceptionNotifierTest::TestException]) do
        raise InheritedTestException.new("some error")
      end
    rescue TestException
    end
    assert_equal 0, ExceptionNotifier::Notifier.deliveries.size
  end

  def test_should_ignore_some_standard_errors_by_default
    begin
      run_with_notifier do
        raise ActionController::RoutingError.new('foo')
      end
    rescue ActionController::RoutingError
    end
    assert_equal 0, ExceptionNotifier::Notifier.deliveries.size
  end

end
