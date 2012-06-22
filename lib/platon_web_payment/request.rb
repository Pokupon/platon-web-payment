require 'digest/md5'
require 'php_serialize'
require 'base64'

module PlatonWebPayment
  class Request

    attr_accessor :client_key, :client_password, :request_url
    attr_accessor :order, :ext1, :ext2, :ext3, :ext4, :default_product_id
    attr_accessor :success_url, :error_url
    attr_accessor :buyer_ip

    def initialize
      @products = []
    end

    def add_product(product_id, name, amount, currency, recurring)
      @products << {
          :id => product_id,
          :name => name,
          :amount => amount,
          :currency => currency,
          :recurring => recurring
      }
    end

    def params
      validate!

      data = make_data

      result = {}
      result[:key] = client_key
      result[:order] = order if order
      result[:data] = data
      result[:ext1] = ext1 if ext1
      result[:ext2] = ext2 if ext2
      result[:ext3] = ext3 if ext3
      result[:ext4] = ext4 if ext4
      result[:url] = success_url
      result[:error_url] = error_url if error_url
      if @products.length > 1
        result[:sign] = make_sign(buyer_ip, client_key, default_product_id, data, success_url, client_password)
      else
        result[:sign] = make_sign(buyer_ip, client_key, data, success_url, client_password)
      end

      result
    end

    private

    def make_data
      data = {}
      @products.each do |product|
        data[product[:id]] = {
            'amount' => sprintf('%.2f', product[:amount]),
            'currency' => product[:currency],
            'name' => product[:name],
            'recurring' => ((product[:recurring]) ? 'init' : '')
        }
      end
      data = data[data.keys.first] if data.length == 1
      Base64.strict_encode64(PHP.serialize(data))
    end

    def make_sign(*args)
      Digest::MD5.hexdigest(args.reduce('') { |sum, arg| sum + (arg || '').reverse }.upcase).downcase
    end

    def validate!
      raise Exception.new('client key is required') if client_key.nil? || client_key.empty?
      raise Exception.new('client password is required') if client_password.nil? || client_password.empty?
      raise Exception.new('buyer ip is required') if buyer_ip.nil? || buyer_ip.empty?
      raise Exception.new('at least one product is required') if @products.empty?
      raise Exception.new('success url is required') if success_url.nil? || success_url.empty?

      if @products.length > 1
        raise Exception.new('default product id is required') if default_product_id.nil? || default_product_id.empty?
        raise Exception.new('default product id is invalid') unless @products.index { |product| product[:id] == default_product_id }
      end

      @products.each do |product|
        raise Exception.new('currency is invalid') unless CURRENCIES.include?(product[:currency])
        raise Exception.new('amount must be numeric') unless product[:amount].is_a? Numeric
      end
    end
  end
end