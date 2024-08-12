class StayItemsController < BaseController
  before_action :get_stay
  before_action :get_stay_item, only: [:edit, :update, :destroy]
  before_action :ensure_frame_response, only: [:new, :edit]

  layout "modal"

  def new
    @stay_item = StayItem.new(item_type: params[:type])
    case @stay_item.item_type
    when "rental_item"
      @modal_title = "Ajouter une location"
    end
  end

  def create
    service = StayItems::CreateService.new(stay_id: @stay.id)
    if service.run(params)
      respond_to do |format|
        format.turbo_stream { 
          render turbo_stream: turbo_stream.append("stay-items", 
                 partial: 'stay_items/stay_item', 
                 locals: { stay_item: service.stay_item }) }
        format.html { 
          redirect_to edit_stay_path(service.stay),
                      notice: "L'élément a été ajouté au séjour."
        }
        format.json { 
          render :show, 
                 status: :created, 
                 location: service.stay_item 
        }
      end
    else
      @stay_item = service.stay_item
      set_error_flash(service.stay_item, service.error_message)
      render :new
    end
  end

  def edit
  end

  def update
  end

  def destroy
    @stay_item.soft_delete!(validate: false)
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@stay_item) }
      format.html { redirect_to edit_stay_url(@stay_item.stay), notice: "L'élément a été retiré du séjour." }
      format.json { head :no_content }
    end
  end

  private

  def ensure_frame_response
    return unless Rails.env.development?
    redirect_to root_path unless turbo_frame_request?
  end

  def get_stay
    @stay = Stay.find(params[:stay_id])
  end

  def get_stay_item
    @stay_item = StayItem.find(params[:id])
  end

  def set_presenters
    @menu_presenter = Components::MenuPresenter.new(
      active_primary: "stay_items",
      controller_name: controller_name,
      action_name: action_name,
      view_context: view_context
    )
  end
end