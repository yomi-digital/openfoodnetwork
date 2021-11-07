# frozen_string_literal: true

module Api
  class OrderSerializer < ActiveModel::Serializer
    attributes :number, :completed_at, :total, :state, :shipment_state, :payment_state,
               :outstanding_balance, :payments, :path, :cancel_path,
               :changes_allowed, :changes_allowed_until, :item_count,
               :shop_id

    has_many :payments, serializer: Api::PaymentSerializer

    # ========
    # Beginning of this issue related comment -> https://github.com/yomi-digital/ficosofn/issues/5

    # @YOMI_TODO: WIP - Need to configure the Model to store the payment related data that is received from the API mentioned above

    # Circumventing the "undefined method `read_attribute_for_serialization' for #<Hash:0x00007f8f2ba501b0>" issue 
    # while using this serializer in the OrdersController

    # Refer to this article to better understand why this is necessary
    # https://sergiodxa.com/articles/use-activemodel-serializer-with-non-activerecord-object
    # def read_attribute_for_serialization(attr)
    #   return object[attr.to_s]
    # end
    # End of this issue related comment
    # ========

    # This method relies on `balance_value` as a computed DB column. See `CompleteOrdersWithBalance`
    # for reference.
    def outstanding_balance
      -object.balance_value
    end

    def payments
      object.payments.joins(:payment_method).where('state IN (?)', %w(completed pending))
    end

    def shop_id
      object.distributor_id
    end

    def item_count
      object.line_items.sum(&:quantity)
    end

    def completed_at
      object.completed_at.blank? ? "" : I18n.l(object.completed_at, format: "%b %d, %Y %H:%M")
    end

    def changes_allowed_until
      return I18n.t(:not_allowed) unless object.changes_allowed?

      I18n.l(object.order_cycle&.orders_close_at, format: "%b %d, %Y %H:%M")
    end

    def shipment_state
      object.shipment_state || nil
    end

    def payment_state
      object.payment_state || nil
    end

    def state
      object.state || nil
    end

    def path
      order_path(object)
    end

    def cancel_path
      return nil unless object.changes_allowed?

      cancel_order_path(object)
    end

    def changes_allowed
      object.changes_allowed?
    end
  end
end
