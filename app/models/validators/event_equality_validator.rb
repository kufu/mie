# frozen_string_literal: true

module Validators
  class EventEqualityValidator < ActiveModel::Validator
    RELATIONS = %i[plan schedule speaker].freeze

    def validate(record)
      RELATIONS.inject(nil) do |acc, relation|
        next acc unless record.respond_to?(relation)

        event_id = find_event_id(record.send(relation))

        next acc unless event_id
        next event_id unless acc

        record.errors.add relation, 'Event id must be same in cross relations.' if acc != event_id

        acc
      end
    end

    private

    def find_event_id(relation)
      if relation.respond_to?(:event_id)
        relation.event_id
      elsif relation.respond_to?(:track)
        relation.track.event.id
      end
    end
  end
end
