require File.dirname(__FILE__) + '/../spec_helper'

include Redmine::Hook::Helper

def controller
  @controller ||= TimelogController.new
  @controller.response ||= ActionController::TestResponse.new
  @controller
end

def request
  @request ||= ActionController::TestRequest.new
end

describe TimelogController, '#controller_timelog_available_criterias_hook', :type => :controller do
  it 'should return an empty string' do
    call_hook(:controller_timelog_available_criterias, {}).should be_blank
  end
end
