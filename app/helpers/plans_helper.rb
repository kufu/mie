# frozen_string_literal: true

module PlansHelper
  def plan_title_max_length
    Plan.validators_on(:title).detect do |v|
      v.is_a?(ActiveModel::Validations::LengthValidator)
    end.options[:maximum]
  end

  def plan_description_max_length
    Plan.validators_on(:description).detect do |v|
      v.is_a?(ActiveModel::Validations::LengthValidator)
    end.options[:maximum]
  end

  def plan_memo_max_length
    PlanSchedule.validators_on(:memo).detect do |v|
      v.is_a?(ActiveModel::Validations::LengthValidator)
    end.options[:maximum]
  end
end
