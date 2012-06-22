require File.expand_path('../helper', __FILE__)

class RecurringRequestTest < Test::Unit::TestCase

  def test_required_client_key
    request = PlatonWebPayment::RecurringRequest.new

    exc = assert_raise PlatonWebPayment::Exception do
      request.execute
    end
    assert_equal 'client key is required', exc.message
  end

  def test_required_client_password
    request = PlatonWebPayment::RecurringRequest.new
    request.client_key = 'test'

    exc = assert_raise PlatonWebPayment::Exception do
      request.execute
    end
    assert_equal 'client password is required', exc.message
  end

  def test_required_recurring_url
    request = PlatonWebPayment::RecurringRequest.new
    request.client_key = 'test'
    request.client_password = 'pass'

    exc = assert_raise PlatonWebPayment::Exception do
      request.execute
    end
    assert_equal 'recurring url is required', exc.message
  end

  def test_required_amount
    request = PlatonWebPayment::RecurringRequest.new
    request.client_key = 'test'
    request.client_password = 'pass'
    request.recurring_url = 'http://recurring.url/'

    exc = assert_raise PlatonWebPayment::Exception do
      request.execute
    end
    assert_equal 'amount is required', exc.message
  end

  def test_numeric_amount
    request = PlatonWebPayment::RecurringRequest.new
    request.client_key = 'test'
    request.client_password = 'pass'
    request.recurring_url = 'http://recurring.url/'
    request.amount = '10X'

    exc = assert_raise PlatonWebPayment::Exception do
      request.execute
    end
    assert_equal 'amount must be numeric', exc.message
  end

  def test_required_description
    request = PlatonWebPayment::RecurringRequest.new
    request.client_key = 'test'
    request.client_password = 'pass'
    request.recurring_url = 'http://recurring.url/'
    request.amount = 10

    exc = assert_raise PlatonWebPayment::Exception do
      request.execute
    end
    assert_equal 'description is required', exc.message
  end

  def test_required_rc_id
    request = PlatonWebPayment::RecurringRequest.new
    request.client_key = 'test'
    request.client_password = 'pass'
    request.recurring_url = 'http://recurring.url/'
    request.amount = 10
    request.description = 'description'

    exc = assert_raise PlatonWebPayment::Exception do
      request.execute
    end
    assert_equal 'rc id is required', exc.message
  end

  def test_required_rc_token
    request = PlatonWebPayment::RecurringRequest.new
    request.client_key = 'test'
    request.client_password = 'pass'
    request.recurring_url = 'http://recurring.url/'
    request.amount = 10
    request.description = 'description'
    request.rc_id = '11111111111'

    exc = assert_raise PlatonWebPayment::Exception do
      request.execute
    end
    assert_equal 'rc token is required', exc.message
  end

  def test_success_response
    request = PlatonWebPayment::RecurringRequest.new
    request.client_key = 'test'
    request.client_password = 'pass'
    request.recurring_url = 'http://recurring.url/'
    request.amount = 10
    request.description = 'description'
    request.rc_id = '11111111111'
    request.rc_token = '22222222222'

    def request.execute
      validate!
      @response = 'SUCCESS'
    end

    request.execute
    assert request.success?
  end

  def test_declined_response
    request = PlatonWebPayment::RecurringRequest.new
    request.client_key = 'test'
    request.client_password = 'pass'
    request.recurring_url = 'http://recurring.url/'
    request.amount = 10
    request.description = 'description'
    request.rc_id = '11111111111'
    request.rc_token = '22222222222'

    def request.execute
      validate!
      @response = 'DECLINED'
    end

    request.execute
    assert request.declined?
  end

  def test_error_response
    request = PlatonWebPayment::RecurringRequest.new
    request.client_key = 'test'
    request.client_password = 'pass'
    request.recurring_url = 'http://recurring.url/'
    request.amount = 10
    request.description = 'description'
    request.rc_id = '11111111111'
    request.rc_token = '22222222222'

    def request.execute
      validate!
      @response = 'ERROR: something wrong'
    end

    request.execute
    assert request.error?
    assert_equal 'something wrong', request.error_message
  end
end