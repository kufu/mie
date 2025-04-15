# frozen_string_literal: true

module Admin
  class TrophiesController < AdminController
    before_action :set_trophy, only: %i[show edit update destroy]

    def index
      @categories = Event.where(id: EventTrophy.select(:event_id).distinct(:event_id)).map(&:name)
      @trophies = if params[:event]
                    Trophy.includes(:event_trophy, :event).where(event_trophy: { events: { name: params[:event] } })
                  else
                    Trophy.includes(:event_trophy, :event).all.order(:order)
                  end
    end

    def new
      @trophy = Trophy.new
    end

    def create
      @trophy = Trophy.create(trophy_params)

      if @trophy.persisted?
        redirect_to admin_trophies_path
      else
        pp @trophy.errors
        render 'new'
      end
    end

    def show; end

    def edit; end

    def update
      if @trophy.update(trophy_params)
        redirect_to admin_trophies_path
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @trophy.destroy
    end

    private

    def set_trophy
      @trophy = Trophy.find(params[:id])
    end

    def trophy_params
      params.expect(trophy: %i[name description rarity order special icon])
    end
  end
end
