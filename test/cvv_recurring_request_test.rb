require File.expand_path('../helper', __FILE__)

class CvvRequestTest < Test::Unit::TestCase

  def test_required_client_key
    request = PlatonWebPayment::CvvRecurringRequest.new

    exc = assert_raise PlatonWebPayment::Exception do
      request.params
    end
    assert_equal 'client key is required', exc.message
  end

  def test_required_client_password
    request = PlatonWebPayment::CvvRecurringRequest.new
    request.client_key = 'test'

    exc = assert_raise PlatonWebPayment::Exception do
      request.params
    end
    assert_equal 'client password is required', exc.message
  end

  def test_required_success_url
    request = PlatonWebPayment::CvvRecurringRequest.new
    request.client_key = 'test'
    request.client_password = 'pass'

    exc = assert_raise PlatonWebPayment::Exception do
      request.params
    end
    assert_equal 'success url is required', exc.message
  end

  def test_required_rc_id
    request = PlatonWebPayment::CvvRecurringRequest.new
    request.client_key = 'test'
    request.client_password = 'pass'
    request.success_url = 'http://success.url/'

    exc = assert_raise PlatonWebPayment::Exception do
      request.params
    end
    assert_equal 'rc id is required', exc.message
  end

  def test_required_rc_token
    request = PlatonWebPayment::CvvRecurringRequest.new
    request.client_key = 'test'
    request.client_password = 'pass'
    request.success_url = 'http://success.url/'
    request.rc_id = '11111111111'

    exc = assert_raise PlatonWebPayment::Exception do
      request.params
    end
    assert_equal 'rc token is required', exc.message
  end

  def test_required_product_name
    request = PlatonWebPayment::CvvRecurringRequest.new
    request.client_key = 'test'
    request.client_password = 'pass'
    request.success_url = 'http://success.url/'
    request.rc_id = '11111111111'
    request.rc_token = '2222222222'

    exc = assert_raise PlatonWebPayment::Exception do
      request.params
    end
    assert_equal 'product name is required', exc.message
  end

  def test_required_product_amount
    request = PlatonWebPayment::CvvRecurringRequest.new
    request.client_key = 'test'
    request.client_password = 'pass'
    request.success_url = 'http://success.url/'
    request.rc_id = '11111111111'
    request.rc_token = '2222222222'
    request.product_name = 'product'

    exc = assert_raise PlatonWebPayment::Exception do
      request.params
    end
    assert_equal 'product amount is required', exc.message
  end

  def test_amount_must_be_numeric
    request = PlatonWebPayment::CvvRecurringRequest.new
    request.client_key = 'test'
    request.client_password = 'pass'
    request.success_url = 'http://success.url/'
    request.rc_id = '11111111111'
    request.rc_token = '2222222222'
    request.product_name = 'product'
    request.product_amount = 'wrong number'

    exc = assert_raise PlatonWebPayment::Exception do
      request.params
    end
    assert_equal 'product amount must be numeric', exc.message
  end

  def test_valid_params
    request = PlatonWebPayment::CvvRecurringRequest.new
    request.client_key = 'test'
    request.client_password = 'pass'
    request.success_url = 'http://success.url/'
    request.order = 'order-no'
    request.rc_id = '11111111111'
    request.rc_token = '2222222222'
    request.product_name = 'nice product'
    request.product_amount = 100.2
    request.buyer_ip = '127.0.0.1'

    params = request.params

    assert_equal 'test', params[:key]
    assert_equal 'order-no', params[:order]
    # calculate in php
    expected_data = 'YToyOntzOjY6ImFtb3VudCI7czo2OiIxMDAuMjAiO3M6NDoibmFtZSI7czoxMjoibmljZSBwcm9kdWN0Ijt9'
    assert_equal expected_data, params[:data]
    assert_equal '11111111111', params[:rc_id]
    assert_equal '2222222222', params[:rc_token]
    assert_equal 'http://success.url/', params[:url]
    # calculated in php
    assert_equal 'e03a56897f08f91f959e79d7a26174a0', params[:sign]
  end

  def test_signature_without_buyer_ip
    request = PlatonWebPayment::CvvRecurringRequest.new
    request.client_key = 'test'
    request.client_password = 'pass'
    request.success_url = 'http://success.url/'
    request.order = 'order-no'
    request.rc_id = '11111111111'
    request.rc_token = '2222222222'
    request.product_name = 'nice product'
    request.product_amount = 100.2

    params = request.params
    # calculated in php
    assert_equal 'deb54bfaff273017f4157bb2296e5740', params[:sign]
  end
end