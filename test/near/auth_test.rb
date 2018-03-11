require 'test_helper'
require 'rack/test'
require 'action_controller/test_case'

class Near::AuthTest < Minitest::Test
  include Rack::Test::Methods

  def app
    @the_app ||= Rails.application
  end
  
  def account
    {account: {id: '1', role_key: 'user'}}.with_indifferent_access
  end
  
  def complete_account
    {account: {id: "1", role_key: 'user', app_ids: ['1','2','3']}}.with_indifferent_access
  end
  
  def test_authentication
    stub_request(:get, "http://apps.development:3000/apps?fields%5Bapps%5D=id").
      with(headers: {'X-Synapse-Data' => account.to_json}).
      to_return(headers: {"Content-Type" => "application/vnd.api+json"}, body: {data: [{id: "1"}, {id: "2"}, {id: "3"}]}.to_json)
      
    app.routes.draw { get '/ping', to: proc {|env| [200, {}, [env["HTTP_X_SYNAPSE_DATA"]]] } }

    header "X-Synapse-Data", account.to_json
    get '/ping'
    
    assert_equal 200, last_response.status
    assert_equal complete_account,  JSON.parse(last_response.body, symbolize_names: true).with_indifferent_access
  end
  
  def test_apps_not_called_if_app_ids_are_present      
    app.routes.draw { get '/ping', to: proc {|env| [200, {}, [env["HTTP_X_SYNAPSE_DATA"]]] } }

    header "X-Synapse-Data", complete_account.to_json
    get '/ping'
    
    assert_equal 200, last_response.status
    assert_equal complete_account,  JSON.parse(last_response.body, symbolize_names: true).with_indifferent_access
  end
  
  def test_init_current_user
    req=ActionController::TestRequest.new()
    req.headers["X-Synapse-Data"] = complete_account.to_json
    
    assert_equal complete_account[:account], Near::Auth.init_current_user(req)
    
    req.headers["X-Synapse-Data"] = nil
    
    assert_nil Near::Auth.init_current_user(req)
  end
  
  def test_get_app_ids_with_no_app_ids_in_header
    app.routes.draw { get '/ping', to: proc {|env| [200, {}, [env["HTTP_X_SYNAPSE_DATA"]]] } }
    
    stub_request(:get, "http://apps.development:3000/apps?fields%5Bapps%5D=id").
      with(headers: {'X-Synapse-Data'=>account.to_json}).
      to_return(headers: {"Content-Type" => "application/vnd.api+json"}, body: {data: [{id: "1"}, {id: "2"}, {id: "3"}]}.to_json)
    
    Near::Auth.default_headers = {
          'X-Synapse-Data' => account.to_json,
          'Accept' => "application/vnd.api+json",
          'Content-Type' => "application/vnd.api+json",
          'X-Request-Id' => "1",
        }
    
    req = account[:account]
    assert_equal complete_account[:account][:app_ids], Near::Auth.get_app_ids(req)
    assert_equal complete_account[:account], req
  end
end

