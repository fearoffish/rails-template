class ConfirmationsController < Devise::ConfirmationsController
  def new
    super
  end

  def create
    super
  end

  def show
    self.resource = resource_class.confirm_by_token(params[:confirmation_token])

    if resource.errors.empty?
      redirect_to(cas_login_url)
    else
      respond_with_navigational(resource.errors, :status => :unprocessable_entity){ render_with_scope :new }
    end
  end

  private

  def cas_login_url
    ::Devise.cas_client.add_service_to_login_url(::Devise.cas_service_url(request.url, devise_mapping))
  end
end