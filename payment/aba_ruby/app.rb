require 'sinatra'
require 'faraday'

set :port, 3000

def merchant_id = 'YOUR-MERCHANT-ID-FROM-ABA'
def public_key = 'YOUR-PUBLIC-API-KEY-FROM-ABA'
def tran_id = params[:tran_id]  

get '/checkout' do
  create_transaction_params = {
    language: 'km',
    request_time: Time.now.strftime('%Y%m%d%H%M%S'),
    merchant_id: merchant_id,
    tran_id: tran_id,
    firstname: "Somba",
    lastname: "Sombit",
    email: "somba@sombit.com",
    phone: "+85512345678",
    amount: 10,
    type: 'purchase',
    payment_option: 'abapay_khqr',
    items: Base64.strict_encode64([
      {name: "Iphone 11", quantity: 1, price: 1},
      {name: "Iphone 12", quantity: 1, price: 9},
    ].to_json),
    continue_success_url: "http://localhost:3000/success?tran_id=#{tran_id}",
    view_type: "checkout",
  }

  hash_data = create_transaction_params.slice(
    :req_time,
    :merchant_id,
    :tran_id,
    :amount,
    :items,
    :firstname,
    :lastname,
    :email,
    :phone,
    :type,
    :payment_option,
    :continue_success_url
  ).values.join("")

  hash = Base64.strict_encode64(OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha512'), public_key, hash_data))
  create_transaction_params.merge!(hash: hash)

  erb :checkout, locals: { create_transaction_params: create_transaction_params }
end

get '/success' do
  check_transaction_params = {
    language: "km",
    request_time: Time.now.strftime('%Y%m%d%H%M%S'),
    merchant_id: merchant_id,
    tran_id: tran_id,
  }

  hash_data = check_transaction_params.slice(:req_time, :merchant_id, :tran_id).values.join("")
  hash = Base64.strict_encode64(OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha512'), public_key, hash_data))
  check_transaction_params.merge!(hash: hash)

  response = Faraday.post(
    "https://checkout-sandbox.payway.com.kh/api/payment-gateway/v1/payments/check-transaction",
    check_transaction_params
  )

  erb :success, locals: { json: JSON.parse(response.body) }
end
