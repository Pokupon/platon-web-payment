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
      'lib/platon_web_payment/callback_response.rb'
  ]
  s.test_files = [
      'test/helper.rb',
      'test/test_request.rb',
      'test/test_recurring_request.rb',
      'test/test_callback_response.rb'
  ]
  s.require_paths = ['lib']
  s.add_dependency 'php_serialize', '1.1.3'
  s.add_dependency 'httparty'
end