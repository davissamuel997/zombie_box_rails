class RegistrationsController < Devise::RegistrationsController

  skip_before_filter :require_login, :only => [:new, :create]

  respond_to :json, :html

  layout 'login'

  def new
  	p 'hello world'
    super
  end

  def create
    # add custom create logic here
  end

  def update
    super
  end
end 