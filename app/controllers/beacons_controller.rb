# frozen_string_literal: true

class BeaconsController < ApplicationController
  include EventRouting

  before_action :make_sure_user_logged_in

  skip_before_action :set_plan
  skip_after_action :check_trophy

  def index
    beacons = Beacon.active.on_event(@event).includes(profile: :user).order(updated_at: :desc)

    render json: {
      beacons: beacons.map { beacon_payload(it) },
      current_beacon: beacons.find { it.profile_id == @user.profile.id }&.then { beacon_payload(it) }
    }
  end

  def create
    beacon = Beacon.publish!(
      profile: @user.profile,
      event: @event,
      latitude: beacon_params[:latitude],
      longitude: beacon_params[:longitude],
      accuracy_meters: beacon_params[:accuracy_meters]
    )

    render json: { beacon: beacon_payload(beacon) }
  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
  end

  def destroy
    Beacon.on_event(@event).where(profile: @user.profile).destroy_all
    head :no_content
  end

  private

  def beacon_params
    params.require(:beacon).permit(:latitude, :longitude, :accuracy_meters)
  end

  def beacon_payload(beacon)
    {
      id: beacon.id,
      profile_id: beacon.profile_id,
      name: beacon.profile.name,
      avatar_url: beacon.profile.avatar_url,
      latitude: beacon.latitude.to_f,
      longitude: beacon.longitude.to_f,
      accuracy_meters: beacon.accuracy_meters,
      expires_at: beacon.expires_at.iso8601,
      current_user: beacon.profile_id == @user.profile.id
    }
  end
end
