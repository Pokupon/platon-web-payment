require 'platon_web_payment/version'
require 'platon_web_payment/exception'
require 'platon_web_payment/utils'
require 'platon_web_payment/request'
require 'platon_web_payment/recurring_request'
require 'platon_web_payment/callback_response'
require 'php_serialize'

module PlatonWebPayment
  CURRENCIES = ['UAH', 'USD', 'EUR']
end