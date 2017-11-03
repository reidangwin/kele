require 'httparty'

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

    @authentication_token = @session_response['auth_token']

  end
end
