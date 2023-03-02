# frozen_string_literal: true

module Validators
  class EventEqualityValidator < ActiveModel::Validator
    RELATIONS = %i[plan schedule speaker].freeze

    def validate(record)
      RELATIONS.inject(nil) do |acc, relation|
        next acc unless record.respond_to?(relation) && record.send(relation)&.event_id

        acc ||= record.send(relation).event_id

        if acc && acc != record.send(relation).event_id
          record.errors.add relation, 'Event id must be same in cross relations.'
        end

        acc
      end
    end
  end
end
