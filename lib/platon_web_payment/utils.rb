require 'digest/md5'

module PlatonWebPayment
  module Utils

    def make_sign(*args)
      Digest::MD5.hexdigest(args.reduce('') { |sum, arg| sum + (arg || '').reverse }.upcase).downcase
    end

    def raise_required(variable, name)
      raise Exception.new("#{name} is required") if variable.nil? || ( variable.respond_to?(:empty?) && variable.empty?)
    end
  end
end