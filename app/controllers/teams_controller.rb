# frozen_string_literal: true

class TeamsController < ApplicationController
  class InvalidStateError < StandardError; end

  before_action :make_sure_user_logged_in
  before_action :set_team, only: %i[show update destroy]
  before_action :check_user_belongs_to_team, only: %i[show update destroy]

  rescue_from TeamsController::InvalidStateError, with: :not_permitted_operation

  def index
    @profile = @user&.profile if @user
  end

  # GET /teams/1
  def show
    @schedules = @event.schedules.includes(:speakers, :track).order(:start_at)
    @schedule_table = Schedule::Tables.new(@schedules)
    @member_schedules_map = @team.profiles.to_h do |profile|
      [profile.id, profile.user.current_plan&.plan_schedules&.map(&:schedule_id) || []]
    end
  end

  # GET /teams/new
  def new
    @team = Team.new
  end

  # POST /teams
  def create
    if @user.profile.belongs_to_any_team?
      raise TeamsController::InvalidStateError, "User #{@user} already belongs team #{@user.profile.teams}"
    end

    @team = Team.new(team_params)
    @team.team_profiles.build(profile: @user.profile, role: :admin)

    if @team.save
      redirect_to @team, notice: 'Team was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /teams/1
  def update
    raise TeamsController::InvalidStateError, 'role admin required' unless @team.admin?(@user)

    if @team.update(team_params)
      session[:breakout_turbo] = true
      redirect_to @team, notice: 'Team was successfully updated.', status: :see_other
    else
      render partial: 'rename_dialog', locals: { team: @team }, status: :unprocessable_entity
    end
  end

  # DELETE /teams/1
  def destroy
    raise TeamsController::InvalidStateError, 'role admin required' unless @team.admin?(@user)

    @team.destroy!
    redirect_to profile_path, status: :see_other
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_team
    @team = Team.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def team_params
    params.require(:team).permit(:name)
  end

  def not_permitted_operation
    render template: 'errors/forbidden', status: :forbidden, layout: 'application', content_type: 'text/html'
  end

  def check_user_belongs_to_team
    return if @user.profile.belongs_to_team?(@team)

    render template: 'errors/not_found', status: 404, layout: 'application', content_type: 'text/html'
  end
end
