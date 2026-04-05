# frozen_string_literal: true

class MapsController < ApplicationController
  include EventRouting

  before_action :make_sure_user_logged_in

  skip_before_action :set_plan
  skip_after_action :check_trophy

  def show
    @google_maps_api_key = ENV['GOOGLE_MAPS_API_KEY'].presence || Rails.application.credentials.dig(:google_maps, :api_key).presence
    @google_maps_map_id = ENV['GOOGLE_MAPS_MAP_ID'].presence || Rails.application.credentials.dig(:google_maps, :map_id).presence
    @google_maps_map_id ||= 'DEMO_MAP_ID' if Rails.env.development? || Rails.env.test?
    @friend_profile_ids = @user.profile.friend_profile_ids
    @active_beacons = Beacon.active.on_event(@event).includes(:event, profile: :user).order(updated_at: :desc)
    @current_beacon = @active_beacons.find { it.profile_id == @user.profile.id }
    @map_center = map_center
  end

  private

  def map_center
    beacon = @current_beacon || @active_beacons.first

    {
      latitude: beacon&.latitude&.to_f || @event.event_theme.map_latitude_value,
      longitude: beacon&.longitude&.to_f || @event.event_theme.map_longitude_value,
      zoom: @event.event_theme.map_zoom_value
    }
  end
end
