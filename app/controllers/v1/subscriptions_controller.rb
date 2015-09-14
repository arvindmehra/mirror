class V1::SubscriptionsController < V1::BaseController
  
  before_action :increment_app_opens_count, only: :status

  def increment_app_opens_count
    @current_user.increment!(:app_opens_count)
  end

  def index
    @subscriptions = @current_user.subscriptions
  end

  def show
    @subscription = @current_user.subscriptions(updated_at: desc).first
  end

  def status
      render json: @current_user.subscription_info
  end

  def create
    
    receipt_json, has_validation_errors = ReceiptValidator.validate_receipt(params[:receipt], @current_device.platform)

    if receipt_json.nil?
      return render json: {errors: ["Failed to validate receipt with apple, their server may be down"]}, status: :unprocessable_entity
    end

    if has_validation_errors
      return render json: {errors: receipt_json}
    end
    
    @receipt = Receipt.new(receipt: params[:receipt], user: @current_user, platform: @current_device.platform)
    @subscription = Subscription.new(user: @current_user)
    @subscription.generate_transactions(receipt_json, @receipt)

    #Do nothing if we have seen this receipt before (no new transactions on it)
    if @subscription.transactions.empty?
      @subscription = nil
      return render :show
    end

    @subscription.generate_start_and_end_date()
    
    begin
      Receipt.transaction do
        @receipt.save
        @subscription.save
      end
    rescue => e
      return render json: {errors: ["#{e.message}"]} , status: :unprocessable_entity
    end

    return render :show

  end

  def expire_all
    @current_user.subscriptions.each do |subscription| 
      subscription.end_date = Time.now
      subscription.save
    end

    if @current_user.save
      render json: {status: ["Succeeded"]}
    else
      render json: {status: ["Failed"]}
    end
  end
end