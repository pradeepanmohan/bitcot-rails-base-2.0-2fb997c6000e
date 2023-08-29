require 'rest-client'
require 'platform/settings'
class Branch

  URL = 'https://api.branch.io'
  END_POINT = '/v1/'

  attr_accessor :data

  def initialize
    self.data = {branch_key: Rails.application.credentials[Rails.env.to_sym][:BRANCH_KEY]}
  end

  def params(branch_data_hash)
    self.data.merge! branch_data_hash
    self
  end

  def web_link(link)
    data['$desktop_url'] = link
    self
  end

  def social_media_tags(title, description, image_url)
    data.merge!({
                    '$og_title': title,
                    '$og_description': description,
                    '$og_image_url': image_url,
                    '$og_url': 'https://www.base.com',
                    '$twitter_site': 'https://www.base.com'
                })
    self
  end


  def create_deep_linking_url(params, base_params = {})
    data = {
        branch_key: Rails.application.credentials[Rails.env.to_sym][:BRANCH_KEY],
        data: params.to_json
    }
    data.merge! base_params
    resource = RestClient::Resource.new("#{URL}#{END_POINT}")
    response = resource['url'].post data.to_json, :content_type => 'application/json'
    JSON.parse(response)
  end


  def create_profile_url(user)
    data = {
        branch_key: Rails.application.credentials[Rails.env.to_sym][:BRANCH_KEY],
        alias: user.email,
        data: generate_user_share_data(user)
    }
    begin
      resource = RestClient::Resource.new("#{URL}#{END_POINT}")
      response = resource['url'].post data.to_json, :content_type => 'application/json'
      JSON.parse(response)['url']
    rescue RestClient::ExceptionWithResponse => e
      Rails.logger.error e.response
      if JSON.parse(e.response).dig('error', 'code') == 409
        update_profile_url(user)
      else
        return nil
      end
    end
  end

  def update_profile_url(user, dynamic_link = nil)
    dynamic_link = dynamic_link.nil? ? "#{BaseApp::Settings::Config.branch_link}#{user.username}" : dynamic_link
    data = {
        branch_key: Rails.application.credentials[Rails.env.to_sym][:BRANCH_KEY],
        branch_secret: Rails.application.credentials[Rails.env.to_sym][:BRANCH_SECRET],
        # alias: user.username,
        data: generate_talent_share_data(user)
    }
    begin
      response = RestClient.put "#{URL}#{END_POINT}url?url=#{dynamic_link}", data.to_json, {content_type: :json, accept: :json}
      JSON.parse(response).dig('data', 'url')
    rescue Exception => e
      Rails.logger.error e.response
      return nil
    end
  end

  def generate_user_share_data(user)
    {
        user_id: user.id,
        type: :ta,
        '$og_title': "#{user.first_name} #{user.last_name[0]}",
        # '$og_description': user.about_my_work,
        # '$og_image_url': user.profile_photo,
        '$og_url': 'https://www.basev2.com',
        '$twitter_site': 'https://www.basev2.com'
    }
  end

  def default_url
    create_deep_linking_url({type: :default})['url']
  end
  def get_link
    resource = RestClient::Resource.new("#{URL}#{END_POINT}")
    response = resource['url'].post data.to_json, content_type: 'application/json'
    JSON.parse(response)['url']
  end

end