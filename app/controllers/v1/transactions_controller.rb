class V1::TransactionsController < V1::BaseController
  
  def create
    @transaction = Transaction.new(transaction_params)
    @transaction.user = @current_user
    @transaction.platform = @current_device.platform
    if @transaction.save
      #render :show
      head :no_content
    else
      render json: {errors: @transaction.errors.full_messages}, status: :unprocessable_entity
    end
  end

  def index
    @transactions = @current_user.transactions
  end

  private

  def transaction_params
    params.require(:transaction).permit(:receipt, :kind, :currency, :price, :bundle_name)
  end

end
