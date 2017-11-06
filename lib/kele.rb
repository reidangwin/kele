require 'httparty'
require 'json'
require './lib/roadmap'

class Kele
  include HTTParty
  include Roadmap

  @bloc_api_url = 'https://www.bloc.io/api/v1'
  base_uri @bloc_api_url

  def api_url(end_point)
    "https://www.bloc.io/api/v1/#{end_point}"
  end


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
    response = self.class.get(api_url("users/me"), headers: { "authorization" => @auth_token })
    @user = JSON.parse(response.body)
  end

  def get_mentor_availability(mentor_id)
    response = self.class.get(api_url("mentors/#{mentor_id}/student_availability"), headers: { "authorization" => @auth_token })
    @mentor_availability = JSON.parse(response.body)
  end
end
