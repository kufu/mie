# frozen_string_literal: true

class EventTrophy < ApplicationRecord
  include UuidPrimaryKey

  belongs_to :event
  belongs_to :trophy
end
