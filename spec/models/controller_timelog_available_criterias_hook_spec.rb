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

def run_hook
  call_hook(:controller_timelog_available_criterias, {:available_criterias => @available_criterias})
end

describe TimelogController, '#controller_timelog_available_criterias_hook', :type => :controller do
  before(:each) do
    @available_criterias = {
      'project' => {:sql => 'project_id', :klass => Project, :label => :label_project}
    }
  end

  it "should always return an empty string" do
    run_hook.should be_blank
  end
  
  it "should add a new hash to the available_criterias" do
    run_hook

    @available_criterias.should have(2).keys
    @available_criterias.key?('deliverable_id').should be_true
  end
  
  it "should set the :sql field to use the issue's deliverable_id" do
    run_hook

    @available_criterias['deliverable_id'][:sql].should eql("issues.deliverable_id")
  end

  it "should set the :klass field to Deliverable" do
    run_hook

    @available_criterias['deliverable_id'][:klass].should eql(Deliverable)
  end
  
  it "should set the :label field to :field_deliverable" do
    run_hook

    @available_criterias['deliverable_id'][:label].should eql(:field_deliverable)
  end
  
end
