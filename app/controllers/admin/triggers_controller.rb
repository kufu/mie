# frozen_string_literal: true

module Admin
  class TriggersController < AdminController
    include QRcode

    before_action :set_trigger, only: %i[show edit update]

    def index
      @triggers = Trigger.where('expires_at > ?', Time.current)
                         .or(Trigger.where(expires_at: nil))
                         .order(description: :asc)
    end

    def show
      @qrcode = url_to_svg_qrcode(url: trigger_url(@trigger, key: @trigger.key))
    end

    def edit; end

    def update
      @trigger.attributes = trigger_params
      @trigger.refresh_key if params[:trigger][:auto_regenerate_key]

      if @trigger.save
        redirect_to admin_trigger_path(@trigger)
      else
        render 'edit', status: :unprocessable_entity
      end
    end

    private

    def set_trigger
      @trigger = Trigger.find(params[:id])
    end

    def trigger_params
      params.require(:trigger).permit(:description, :action, :key, :amount, :expires_at)
    end
  end
end
