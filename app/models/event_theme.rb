# frozen_string_literal: true

class EventTheme < ApplicationRecord
  include UuidPrimaryKey

  DEFAULT_MAP_LATITUDE = 35.681236
  DEFAULT_MAP_LONGITUDE = 139.767125
  DEFAULT_MAP_ZOOM = 13
  BEACON_SHARE_RADIUS_METERS = 5_000
  EARTH_RADIUS_METERS = 6_371_000

  belongs_to :event

  validates :main_color, presence: true, format: { with: /\A#[0-9A-Fa-f]{6}\z/ }
  validates :map_latitude, numericality: { greater_than_or_equal_to: -90, less_than_or_equal_to: 90 }, allow_nil: true
  validates :map_longitude, numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to: 180 }, allow_nil: true
  validates :map_zoom, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 20, only_integer: true }

  def map_latitude_value
    map_latitude&.to_f || DEFAULT_MAP_LATITUDE
  end

  def map_longitude_value
    map_longitude&.to_f || DEFAULT_MAP_LONGITUDE
  end

  def map_zoom_value
    map_zoom || DEFAULT_MAP_ZOOM
  end

  def beacon_share_radius_meters
    BEACON_SHARE_RADIUS_METERS
  end

  def beacon_share_radius_km
    beacon_share_radius_meters / 1_000
  end

  def shareable_location?(latitude:, longitude:)
    distance_to(latitude:, longitude:) <= beacon_share_radius_meters
  end

  def distance_to(latitude:, longitude:)
    latitude_radians = to_radians(latitude)
    longitude_radians = to_radians(longitude)
    center_latitude_radians = to_radians(map_latitude_value)
    center_longitude_radians = to_radians(map_longitude_value)

    latitude_delta = latitude_radians - center_latitude_radians
    longitude_delta = longitude_radians - center_longitude_radians

    a = Math.sin(latitude_delta / 2)**2 +
        Math.cos(center_latitude_radians) * Math.cos(latitude_radians) *
        Math.sin(longitude_delta / 2)**2
    a = [[a, 0.0].max, 1.0].min

    EARTH_RADIUS_METERS * 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))
  end

  private

  def to_radians(value)
    value.to_f * Math::PI / 180
  end
end
