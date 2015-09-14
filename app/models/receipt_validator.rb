class ReceiptValidator
  attr_accessor :receipt

  def ReceiptValidator.validate_receipt(receipt, platform)

    if platform.to_s == "ios"
      return ReceiptValidator.validate_with_apple(receipt)
    end
  end

  def ReceiptValidator.validate_with_apple(receipt)
    #refactor params to be a hash then call .to_json when you have time
    params_json = "{ \"receipt-data\": \"#{receipt}\"  }"
    hashed_apple_json_response = []
    
    #Use net/http to post to apple sandbox server
    uri = URI(Realifex::Application.config.apple_receipt_validation_url)

    Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
      
      response = http.post('/verifyReceipt', params_json)
      if response.code.to_i == 200 #success
        
        receipt_json = JSON.parse(response.body)
        
        if receipt_json[:exception.to_s]
          return receipt_json, true
        end
        
        return receipt_json, false
      
      else
        return nil, false
      end

    end

    return nil, false
  end
end