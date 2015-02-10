module Spree
  class Gateway::AdyenPayment < Gateway
    include AdyenCommon

    def auto_capture?
      false
    end

    def payment_profiles_supported?
      true
    end

    def authorize(amount, source, gateway_options = {})
      card = { :holder_name => "#{source.first_name} #{source.last_name}",
               :number => source.number,
               :cvc => source.verification_value,
               :expiry_month => source.month,
               :expiry_year => source.year }

      authorize_on_card amount, source, gateway_options, card
    end

    # Do a symbolic authorization, e.g. 1 dollar, so that we can grab a recurring token
    #
    # NOTE Ensure that your Adyen account Capture Delay is set to *manual* otherwise
    # this amount might be captured from customers card. See Settings > Merchant Settings
    # in Adyen dashboard
    def create_profile(payment)
      card = { :holder_name => "#{payment.source.first_name} #{payment.source.last_name}",
               :number => payment.source.number,
               :cvc => payment.source.verification_value,
               :expiry_month => payment.source.month,
               :expiry_year => payment.source.year }

      create_profile_on_card payment, card
    end
  end
end
