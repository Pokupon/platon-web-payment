module PlatonWebPayment
  class CallbackResponse

    attr_reader :transaction_id, :order, :status, :card, :pid, :description, :amount, :currency, :name, :email,
                :country, :state, :city, :address, :date, :ip, :ext1, :ext2, :ext3, :ext4, :rc_id, :rc_token, :sign

    def initialize(client_password, input_params)
      @client_password = client_password
      @transaction_id = input_params[:id]
      @order = input_params[:order]
      @status = input_params[:status]
      @card = input_params[:card]
      @pid = input_params[:pid]
      @description = input_params[:description]
      @amount = input_params[:amount]
      @currency = input_params[:currency]
      @name = input_params[:name]
      @email = input_params[:email]
      @country = input_params[:country]
      @state = input_params[:state]
      @city = input_params[:city]
      @address = input_params[:address]
      @date = input_params[:date]
      @ip = input_params[:ip]
      @ext1 = input_params[:ext1]
      @ext2 = input_params[:ext2]
      @ext3 = input_params[:ext3]
      @ext4 = input_params[:ext4]
      @rc_id = input_params[:rc_id]
      @rc_token = input_params[:rc_token]
      @sign = input_params[:sign]
    end

    def valid?
      expected_sign == sign
    end

    def sale?
      'SALE' == status
    end

    def refund?
      'REFUND' == status
    end

    def chargeback?
      'CHARGEBACK' == status
    end

    private

    def expected_sign
      sub_card = (card) ? card[0, 6] + (card[-4, 4] || '') : ''
      Digest::MD5.hexdigest(((email || '').reverse + (@client_password || '') + (order || '') + sub_card.reverse).upcase).downcase
    end
  end
end