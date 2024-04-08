# frozen_string_literal: true

class MembersController < ApplicationController
  class NoPermissionError < StandardError; end

  prepend_before_action :set_default_event
  before_action :set_team
  before_action :set_team_profile, except: :create
  before_action :define_error_variable

  rescue_from MembersController::NoPermissionError, with: :not_permitted_operation

  def create
    raise MembersController::NoPermissionError, 'Not admin' unless @team.admin?(@user)

    profile = Profile.find_by(name: params[:profile_name])

    if profile
      if @team.team_profiles.create(profile:)
        render :dialog, status: :created
      else
        render 'dialog', status: :unprocessable_entity
      end
    else
      @dialog_errors << I18n.t('errors.user_not_found', user: params[:profile_name])
      render 'dialog', status: :unprocessable_entity
    end
  end

  def update
    raise MembersController::NoPermissionError, 'Not admin' unless invitation_become_a_member? || @team.admin?(@user)

    old_role = @team_profile.role
    @team_profile.role = params[:role]

    invitation_user_check(old_role)

    if @dialog_errors.empty? && @team_profile.save
      render 'dialog'
    else
      render 'dialog', status: :unprocessable_entity
    end
  end

  def destroy
    raise MembersController::NoPermissionError, 'Not admin' unless @team.admin?(@user)

    if @team_profile.admin? && @team.team_profiles.where(role: :admin).count <= 1
      @dialog_errors << I18n.t('errors.no_admins')
    end

    if @dialog_errors.empty? && @team_profile.destroy
      render 'dialog'
    else
      render 'dialog', status: :unprocessable_entity
    end
  end

  private

  def set_team
    @team = Team.find(params[:team_id])
  end

  def set_team_profile
    @team_profile = TeamProfile.find_by!(profile_id: params[:id])
  end

  def define_error_variable
    @dialog_errors = []
  end

  def set_default_event
    @event = Event.all.order(created_at: :desc).first
    request.path_parameters[:event_name] = @event.name
  end

  def not_permitted_operation
    render template: 'errors/forbidden', status: :forbidden, layout: 'application', content_type: 'text/html'
  end

  def invitation_become_a_member?
    @team_profile.profile == @user.profile && params[:role] == 'member'
  end

  def invitation_user_check(old_role)
    return unless old_role == 'invitation' && !invitation_become_a_member?

    @dialog_errors << 'no others can not change invitation to member'
  end
end
