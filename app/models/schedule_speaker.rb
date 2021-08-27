# frozen_string_literal: true

class ScheduleSpeaker < ApplicationRecord
  belongs_to :schedule
  belongs_to :speaker
end
