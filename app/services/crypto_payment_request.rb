# frozen_string_literal: false
# Sends and receives the payment details for a crypto payment type
class CryptoPaymentRequest
  # Constructor
  #
  # @param controller [#expire_current_order, #current_order]
  # @param order [Spree::Order]
  def initialize(controller, order)
    @controller = controller
    @order = order
  end

  # Calls the external API to fetch the QR code for payment
  def send_order_details
    uri = URI("http://134.209.31.112:4000/payments/create")
    response = Net::HTTP.post_form(uri, {"order_id": @order.number, "amount": @order.amount, "hash_user": @order.email})

    JSON.parse(response.body)
  end

  private

  attr_reader :controller, :order
end
