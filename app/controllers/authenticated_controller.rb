class AuthenticatedController < ApplicationController
  include Pundit
  include GDS::SSO::ControllerMethods

  protect_from_forgery

  prepend_before_action :authenticate_user!

  rescue_from Pundit::NotAuthorizedError do |e|
    # Layout and view comes from GDS::SSO::ControllerMethods
    render 'authorisations/unauthorised', layout: 'unauthorised', status: :forbidden, locals: { message: e.message }
  end

  def current_page
    Integer(params[:page] || 1)
  end
end
