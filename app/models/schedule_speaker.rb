# frozen_string_literal: true

class ScheduleSpeaker < ApplicationRecord
  include ActiveModel::Validations
  validates_with Validators::EventEqualityValidator

  belongs_to :schedule
  belongs_to :speaker
end
