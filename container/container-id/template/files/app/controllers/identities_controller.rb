class IdentitiesController < ApplicationController
  before_action :find_identity, only: %i[show edit update]

  def index
    @identities = ServiceId::Identity.order(verified: :desc, handle: :asc)
  end

  def show
    @links = @identity.links
  end

  def new
    @identity = ServiceId::Identity.new
  end

  def create
    @identity = ServiceId::Identity.new(identity_params)

    if @identity.save
      redirect_to identity_path(@identity), notice: "Identity created."
    else
      flash.now[:alert] = @identity.errors.full_messages.join(", ")
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @identity.update(identity_params)
      redirect_to identity_path(@identity), notice: "Identity updated."
    else
      flash.now[:alert] = @identity.errors.full_messages.join(", ")
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def find_identity
    @identity = ServiceId::Identity.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to identities_path, alert: "Identity not found."
  end

  def identity_params
    params.require(:identity).permit(:context_user_id, :handle, :display_name, :avatar_url, :bio)
  end
end
