# frozen_string_literal: true

module CoreExtensions
  # WARNING: monkey patch (https://github.com/remi/her/blob/master/lib/her/model/relation.rb#L34)
  module HerSaveOnlyChangedAttrs
    # Validate record before save and after the request
    # put the errors in the right places.
    #
    # @example A subscription without a customer
    #
    #   @subscription = Vindi::Subscription.new.tap do |s|
    #     s.plan_id = plan.id
    #     s.payment_method_code = "credit_card"
    #     s.save
    #   end
    #
    #   @subscription.errors.full_messages # ["Customer can't be blank"]
    #
    # @example A subscription with invalid plan
    #
    #   @subscription = Vindi::Subscription.new.tap do |s|
    #     s.customer_id = customer.id
    #     s.plan_id = 1
    #     s.payment_method_code = "credit_card"
    #     s.save
    #   end
    #
    #   @subscription.errors.full_messages # ["Plan nao encontrado"]
    #
    def save
      if new?
        super
      else
        save_current_changes
      end

      response_errors.any? && errors.clear && response_errors.each do |re|
        errors.add re[:attribute], re[:type], message: re[:message]
      end

      return false if errors.any?

      self
    end

    private

    def save_current_changes
      return self unless changed.any?

      callback = new? ? :create : :update
      method = self.class.method_for(callback)

      run_callbacks :save do
        run_callbacks callback do
          self.class.request(filtered_changed_attributes.merge(_method: method, _path: request_path)) do |parsed_data, response|
            load_from_parsed_data(parsed_data)
            return false if !response.success? || @response_errors.any?
            changes_applied
          end
        end
      end

      self
    end

    def filtered_changed_attributes
      changes.transform_values(&:last)
    end
  end
end

Her::Model::ORM.prepend CoreExtensions::HerSaveOnlyChangedAttrs
