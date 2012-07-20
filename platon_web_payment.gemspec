$:.push File.expand_path('../lib', __FILE__)
require 'platon_web_payment/version'

Gem::Specification.new do |s|
  s.name = 'platon_web_payment'
  s.version = PlatonWebPayment::VERSION
  s.date = '2012-06-22'
  s.summary = 'Platon Web Payment'
  s.description = 'Platon Web Payment Client'
  s.authors = ['Alexei Curguzchin']
  s.email = 'alexei.curguzchin@pokupon.ua'
  s.homepage = 'https://github.com/Pokupon/platon-web-payment'

  s.files = [
      'lib/platon_web_payment.rb',
      'lib/platon_web_payment/version.rb',
      'lib/platon_web_payment/exception.rb',
      'lib/platon_web_payment/request.rb',
      'lib/platon_web_payment/utils.rb',
      'lib/platon_web_payment/recurring_request.rb',
      'lib/platon_web_payment/cvv_recurring_request.rb',
      'lib/platon_web_payment/callback_response.rb',
      'lib/php_serialize.rb'
  ]
  s.test_files = [
      'test/helper.rb',
      'test/request_test.rb',
      'test/recurring_request_test.rb',
      'test/cvv_recurring_request_test.rb',
      'test/callback_response_test.rb'
  ]
  s.require_paths = ['lib']
  s.add_dependency 'httparty'
  s.add_dependency 'russian'
end