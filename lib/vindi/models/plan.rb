# frozen_string_literal: true

module Vindi
  # Plans
  #
  # @example List active plans
  #
  #   plans = Vindi::Plan.active
  #
  # @example Create a recurring plan
  #
  # plan = Vindi::Plan.new.tap do |p|
  #   p.name = "Monthly Plan"
  #   p.description = "This plan will be renewed every month in the same day"
  #   p.period = "monthly"
  #   p.recurring = true
  #   p.code = 1
  #   p.plan_items = [
  #     {
  #       cycles: nil,
  #       product_id: 1
  #     }
  #   ]
  # end
  #
  # @example Create an yearly plan with installments
  #
  # plan = Vindi::Plan.new.tap do |p|
  #   p.name = "Yearly Plan"
  #   p.description = "This plan will be paid in 12 installments"
  #   p.period = "yearly"
  #   p.billing_cycles = 1
  #   p.installments = 12
  #   p.code = 1
  #   p.plan_items = [
  #     {
  #       cycles: nil,
  #       product_id: 1
  #     }
  #   ]
  # end
  #
  class Plan < Model
    # has_many :plan_items
    # has_many :products, through: :plan_items

    scope :recurring, -> { where(billing_cycles: nil) }

    after_initialize :set_defaults

    def recurring=(value)
      self.billing_cycles = value ? nil : 0
    end

    def period=(value)
      raise "invalid period" unless %w[monthly quarterly biannually yearly].include? value.to_s

      send "set_#{value}"
    end

    private

    def set_defaults
      self.billing_trigger_type = "beginning_of_period"
      self.billing_trigger_day = 0
      self.installments = 1
      self.status = "active"
    end

    def set_monthly
      self.interval = "months"
      self.interval_count = 1
    end

    def set_quarterly
      self.interval = "months"
      self.interval_count = 3
    end

    def set_biannually
      self.interval = "months"
      self.interval_count = 6
    end

    def set_yearly
      self.interval = "months"
      self.interval_count = 12
    end
  end
end
