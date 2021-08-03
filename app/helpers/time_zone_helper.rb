# frozen_string_literal: true

module TimeZoneHelper
  def grouped_timezones
    zones = ActiveSupport::TimeZone.all.map { |z| z.tzinfo.identifier }.uniq
    zones.group_by { |z| z.split('/').first }
  end
end
