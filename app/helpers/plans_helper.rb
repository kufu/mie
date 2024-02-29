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

  def plans_table(plan)
    props = group_schedules_by_date(plan.schedules).map do |k, v|
      rows = group_schedules_by_time(v).map do |time, schedules|
        {
          time: split_time_and_zone(time),
          schedule: schedules.first,
          memo: plan.plan_schedules.find_by(schedule: schedules.first)&.memo,
          sortKey: schedules.first.start_at.to_i
        }
      end
      [k, rows.sort_by { |r| r[:sortKey] }]
    end

    props.to_h
  end
end
