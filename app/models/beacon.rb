# frozen_string_literal: true

class Beacon < ApplicationRecord
  include UuidPrimaryKey
  include Events

  TTL = 30.minutes

  belongs_to :event
  belongs_to :profile

  scope :active, -> { where('expires_at > ?', Time.current) }

  validates :latitude, presence: true, numericality: { greater_than_or_equal_to: -90, less_than_or_equal_to: 90 }
  validates :longitude, presence: true, numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to: 180 }
  validates :accuracy_meters, numericality: { greater_than_or_equal_to: 0, only_integer: true }, allow_nil: true
  validates :expires_at, presence: true
  validates :profile_id, uniqueness: { scope: :event_id }
  validate :location_must_be_within_event_share_radius

  def self.publish!(profile:, event:, latitude:, longitude:, accuracy_meters: nil)
    beacon = find_or_initialize_by(profile:, event:)
    beacon.assign_attributes(
      latitude:,
      longitude:,
      accuracy_meters: accuracy_meters.presence,
      expires_at: TTL.from_now
    )
    beacon.save!
    beacon
  end

  def active?
    expires_at.future?
  end

  private

  def location_must_be_within_event_share_radius
    return if latitude.blank? || longitude.blank? || event.blank? || event.event_theme.blank?
    return if event.event_theme.shareable_location?(latitude:, longitude:)

    errors.add(
      :base,
      I18n.t('errors.beacon_out_of_range', radius_km: event.event_theme.beacon_share_radius_km)
    )
  end
end
