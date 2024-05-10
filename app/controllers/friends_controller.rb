# frozen_string_literal: true

class FriendsController < ApplicationController
  include QRcode

  before_action :make_sure_user_logged_in

  def new
    @trigger = Trigger.find_by(description: trigger_description)

    if @trigger
      @trigger.key = SecureRandom.uuid
      @trigger.expires_at = Time.zone.now + 30.seconds
      @trigger.amount = 1
    else
      @trigger = new_trigger
    end

    raise unless @trigger.save

    @qrcode = url_to_svg_qrcode(url: trigger_url(@trigger, key: @trigger.key))
  end

  private

  def trigger_description
    "friends:#{@user.profile.uid}"
  end

  def new_trigger
    Trigger.build(
      description: trigger_description,
      key: SecureRandom.uuid,
      action: [
        {
          model: 'Friend',
          target: 'Profile',
          props: {
            from: @user.profile.id,
            to: :target
          },
          action: :craete
        },
        {
          model: 'Friend',
          target: 'Profile',
          props: {
            from: :target,
            to: @user.profile.id
          },
          action: :craete
        }
      ],
      expires_at: Time.zone.now + 30.seconds,
      amount: 1
    )
  end
end
