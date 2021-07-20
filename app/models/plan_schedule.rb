class PlanSchedule < ApplicationRecord
  belongs_to :plan
  belongs_to :schedule
end
