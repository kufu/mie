# frozen_string_literal: true

module BeaconAccessKey
  extend ActiveSupport::Concern

  private

  def issue_beacon_access_key(event)
    beacon_access_keys[event.id.to_s] = SecureRandom.urlsafe_base64(32)
  end

  def verify_beacon_access_key!(event)
    provided_key = request.headers['X-Beacon-Access-Key'].presence || params[:access_key].presence
    expected_key = beacon_access_keys[event.id.to_s]

    return if beacon_access_key_valid?(expected_key, provided_key)

    render json: { errors: [I18n.t('errors.invalid_beacon_access_key')] }, status: :forbidden
  end

  def beacon_access_key_valid?(expected_key, provided_key)
    return false if expected_key.blank? || provided_key.blank?
    return false if expected_key.bytesize != provided_key.bytesize

    ActiveSupport::SecurityUtils.secure_compare(expected_key, provided_key)
  end

  def beacon_access_keys
    session[:beacon_access_keys] = session[:beacon_access_keys].to_h
  end
end
