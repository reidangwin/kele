require 'httparty'
require 'json'

class Kele
  include HTTParty

  @bloc_api_url = 'https://www.bloc.io/api/v1'
  base_uri @bloc_api_url

  def initialize(email, password)
    @email = email
    @password = password

    @options = {body: {email: @email, password: @password}}
    @session_response = self.class.post('/sessions', @options)

    raise "Invalid email address" if @session_response.code == 404
    raise "Invalid password" if @session_response.code == 401

    @auth_token = @session_response['auth_token']

  end

  def get_me
    response = self.class.get("/users/me", headers: { "authorization" => @auth_token })
    @user = JSON.parse(response.body)
  end
end
