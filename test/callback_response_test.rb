require File.expand_path('../helper', __FILE__)

class CallbackResponseTest < Test::Unit::TestCase

  @@default_params = {
      :transaction_id => '1111',
      :order => '1111',
      :status => 'SALE',
      :card => '123456****1234',
      :description => 'product',
      :amount => '10.10',
      :currency => 'UAH',
      :name => 'Buyer',
      :email => 'buyer@example.com',
      :country => 'UA',
      :city => 'Kiev',
      :date => '2000-01-02',
      :ip => '127.0.0.1',
      :rc_id => '22222222',
      :rc_token => '3333333',
      :sign => 'wrong'
  }

  def test_invalid_sign
    params = @@default_params.dup
    params[:sign] = 'wrong'
    response = PlatonWebPayment::CallbackResponse.new('pass', params)
    assert !response.valid?
  end

  def test_valid_sign
    # calculated in php
    params = @@default_params.dup
    params[:sign] = 'b2b21219a6ce77f8999965aa49e533fc'
    response = PlatonWebPayment::CallbackResponse.new('pass', params)
    assert response.valid?
  end

  def test_sale
    params = @@default_params.dup
    params[:status] = 'SALE'
    response = PlatonWebPayment::CallbackResponse.new('pass', params)
    assert response.sale?
  end

  def test_refund
    params = @@default_params.dup
    params[:status] = 'REFUND'
    response = PlatonWebPayment::CallbackResponse.new('pass', params)
    assert response.refund?
  end

  def test_chargeback
    params = @@default_params.dup
    params[:status] = 'CHARGEBACK'
    response = PlatonWebPayment::CallbackResponse.new('pass', params)
    assert response.chargeback?
  end
end