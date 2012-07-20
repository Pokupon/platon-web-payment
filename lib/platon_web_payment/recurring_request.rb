module PlatonWebPayment
  class RecurringRequest
    include Utils

    attr_accessor :client_key, :client_password, :recurring_url
    attr_accessor :order, :amount
    attr_reader :description
    attr_accessor :rc_id, :rc_token
    attr_accessor :response
    attr_reader :sign

    def description=(value)
      @description = Russian::transliterate(value)[0, 30]
    end

    def execute
      validate!

      amount_str = sprintf('%.2f', amount)

      params = {}
      params[:key] = client_key
      params[:order] = order
      params[:amount] = amount_str
      params[:description] = description
      params[:rc_id] = rc_id
      params[:rc_token] = rc_token
      @sign = make_sign(client_key, amount_str, description, rc_id, rc_token, client_password)
      params[:sign] = sign

      response = HTTParty.post(recurring_url, :body => params)
      self.response = response.body
    end

    def success?
      'SUCCESS' == response
    end

    def declined?
      response =~ /^DECLINED/
    end

    def error?
      response =~ /^ERROR/
    end

    def error_message
      (error?) ? response.split(':')[1].strip : nil
    end

    private

    def validate!
      raise_required client_key, 'client key'
      raise_required client_password, 'client password'
      raise_required recurring_url, 'recurring url'
      raise_required amount, 'amount'
      raise Exception.new('amount must be numeric') unless amount.is_a? Numeric
      raise_required description, 'description'
      raise_required rc_id, 'rc id'
      raise_required rc_token, 'rc token'
    end
  end
end