require File.expand_path('../helper', __FILE__)

class RequestTest < Test::Unit::TestCase

  def test_required_client_key
    request = PlatonWebPayment::Request.new

    exc = assert_raise PlatonWebPayment::Exception do
      request.params
    end
    assert_equal 'client key is required', exc.message
  end

  def test_required_client_password
    request = PlatonWebPayment::Request.new
    request.client_key = 'test'

    exc = assert_raise PlatonWebPayment::Exception do
      request.params
    end
    assert_equal 'client password is required', exc.message
  end

  def test_required_products
    request = PlatonWebPayment::Request.new
    request.client_key = 'test'
    request.client_password = 'pass'
    request.buyer_ip = '127.0.0.1'

    exc = assert_raise PlatonWebPayment::Exception do
      request.params
    end
    assert_equal 'at least one product is required', exc.message
  end

  def test_required_success_url
    request = PlatonWebPayment::Request.new
    request.client_key = 'test'
    request.client_password = 'pass'
    request.buyer_ip = '127.0.0.1'
    request.add_product 'product-id', 'product name', 100, 'UAH', true

    exc = assert_raise PlatonWebPayment::Exception do
      request.params
    end
    assert_equal 'success url is required', exc.message
  end

  def test_required_default_product_id
    request = PlatonWebPayment::Request.new
    request.client_key = 'test'
    request.client_password = 'pass'
    request.buyer_ip = '127.0.0.1'
    request.add_product 'product-id', 'product name', 100, 'UAH', true
    request.add_product 'product-id', 'product name', 100, 'UAH', true
    request.success_url = 'http://success.url/'

    exc = assert_raise PlatonWebPayment::Exception do
      request.params
    end
    assert_equal 'default product id is required', exc.message
  end

  def test_wrong_default_product_id
    request = PlatonWebPayment::Request.new
    request.client_key = 'test'
    request.client_password = 'pass'
    request.buyer_ip = '127.0.0.1'
    request.add_product 'product-id', 'product name', 100, 'UAH', true
    request.add_product 'product-id', 'product name', 100, 'UAH', true
    request.success_url = 'http://success.url/'
    request.default_product_id = 'nonexistent-product-id'

    exc = assert_raise PlatonWebPayment::Exception do
      request.params
    end
    assert_equal 'default product id is invalid', exc.message
  end

  def test_wrong_currency
    request = PlatonWebPayment::Request.new
    request.client_key = 'test'
    request.client_password = 'pass'
    request.buyer_ip = '127.0.0.1'
    request.add_product 'product-id', 'product name', 100, 'XXX', true
    request.success_url = 'http://success.url/'

    exc = assert_raise PlatonWebPayment::Exception do
      request.params
    end
    assert_equal 'currency is invalid', exc.message
  end

  def test_amount_must_be_numeric
    request = PlatonWebPayment::Request.new
    request.client_key = 'test'
    request.client_password = 'pass'
    request.buyer_ip = '127.0.0.1'
    request.add_product 'product-id', 'product name', '10X', 'UAH', true
    request.success_url = 'http://success.url/'

    exc = assert_raise PlatonWebPayment::Exception do
      request.params
    end
    assert_equal 'amount must be numeric', exc.message
  end

  def test_valid_params
    request = PlatonWebPayment::Request.new
    request.client_key = 'test'
    request.client_password = 'pass'
    request.buyer_ip = '127.0.0.1'
    request.add_product nil, 'product name', 10.10, 'UAH', true
    request.success_url = 'http://success.url/'
    request.error_url = 'http://error.url/'
    request.order = 'order-no'

    params = request.params

    assert_equal 'test', params[:key]
    assert_equal 'order-no', params[:order]
    # calculate in php
    expected_data = 'YTo0OntzOjY6ImFtb3VudCI7czo1OiIxMC4xMCI7czo4OiJjdXJyZW5jeSI7czozOiJVQUgiO3M6NDoibmFtZSI7czoxMjoicHJvZHVjdCBuYW1lIjtzOjk6InJlY3VycmluZyI7czo0OiJpbml0Ijt9'
    assert_equal expected_data, params[:data]
    assert_equal 'http://success.url/', params[:url]
    assert_equal 'http://error.url/', params[:error_url]
    # calculated in php
    assert_equal 'ca451720133c8f955a0aca6e259e66d6', params[:sign]
  end

  def test_signature_without_buyer_ip
    request = PlatonWebPayment::Request.new
    request.client_key = 'test'
    request.client_password = 'pass'
    request.add_product nil, 'product name', 10.10, 'UAH', true
    request.success_url = 'http://success.url/'
    request.error_url = 'http://error.url/'
    request.order = 'order-no'

    params = request.params
    # calculated in php
    assert_equal 'bb10dbbf7a899c65cab8218f2a4ba920', params[:sign]
  end
end