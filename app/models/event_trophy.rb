class EventTrophy < ApplicationRecord
  belongs_to :event
  belongs_to :trophy
end
