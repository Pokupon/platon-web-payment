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
  s.homepage = 'https://github.com/organizations/Pokupon'

  s.files = [
      'lib/platon_web_payment.rb',
      'lib/platon_web_payment/version.rb',
      'lib/platon_web_payment/exception.rb',
      'lib/platon_web_payment/request.rb'
  ]
  s.test_files = [
      'test/test_request.rb'
  ]
  s.require_paths = ['lib']
  s.add_dependency 'php_serialize', '1.1.3'
end