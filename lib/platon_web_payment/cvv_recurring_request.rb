module PlatonWebPayment
  class CvvRecurringRequest
    include Utils

    attr_accessor :client_key, :client_password, :request_url
    attr_accessor :order, :rc_id, :rc_token, :success_url, :buyer_ip
    attr_accessor :product_name, :product_amount

    def params
      validate!

      params = {}
      params[:key] = client_key
      params[:order] = order
      params[:data] = make_data
      params[:rc_id] = rc_id
      params[:rc_token] = rc_token
      params[:url] = success_url
      params[:sign] = make_sign(buyer_ip, client_key, params[:data], rc_id, rc_token, success_url, client_password)

      params
    end

    private

    def make_data
      data = {
          'amount' => sprintf('%.2f', product_amount),
          'name' => product_name
      }
      Base64.strict_encode64(PHP.serialize(data))
    end

    def validate!
      raise_required client_key, 'client key'
      raise_required client_password, 'client password'
      raise_required success_url, 'success url'
      raise_required rc_id, 'rc id'
      raise_required rc_token, 'rc token'
      raise_required product_name, 'product name'
      raise_required product_amount, 'product amount'
      raise Exception.new('product amount must be numeric') unless product_amount.is_a? Numeric
      raise_required buyer_ip, 'buyer ip'
    end
  end
end