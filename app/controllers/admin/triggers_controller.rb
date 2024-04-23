# frozen_string_literal: true

module Admin
  class TriggersController < AdminController
    include QRcode

    before_action :set_trigger, only: %i[show]

    def show
      @event = Event.order(created_at: :desc).first
      request.path_parameters[:event_name] = @event.name
      @plan = Plan.new
      @qrcode = url_to_svg_qrcode(url: "https://example.com/triggers/#{@trigger.id}?key=#{@trigger.key}")
    end

    private

    def set_trigger
      @trigger = Trigger.find(params[:id])
    end
  end
end
