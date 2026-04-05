# frozen_string_literal: true

class EventTheme < ApplicationRecord
  include UuidPrimaryKey

  DEFAULT_MAP_LATITUDE = 35.681236
  DEFAULT_MAP_LONGITUDE = 139.767125
  DEFAULT_MAP_ZOOM = 13

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
end
