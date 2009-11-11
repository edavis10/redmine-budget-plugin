require File.dirname(__FILE__) + '/../spec_helper'

describe DeliverablesController do

  #Delete this example and add some real ones
  it "should use DeliverablesController" do
    controller.should be_an_instance_of(DeliverablesController)
  end

end

describe DeliverablesController,"#index when logged in" do
  before(:each) do
    @project = mock_model(Project)
    @deliverable = mock_model(Deliverable)
    
    Deliverable.stub!(:count).and_return(1)
    Deliverable.stub!(:find).and_return([@deliverable])
    
    Project.should_receive(:find).with(@project.to_param).and_return(@project)
    Project.should_receive(:find).with(@project.id).and_return(@project)
    controller.stub!(:authorize).and_return(true)
  end
  
  it "should be successful" do
    get :index, :id => @project.id
    response.should be_success
  end
  
  it "should set @deliverables for the view" do
    get :index, :id => @project.id
    assigns[:deliverables].should_not be_nil
  end

  it "should set @display_form to false by default" do
    get :index, :id => @project.id
    assigns[:display_form].should eql(false)
  end

  it "should set @display_form to true if there are no deliverables" do
    Deliverable.should_receive(:count).and_return(0)
    Deliverable.should_receive(:find).and_return([])

    get :index, :id => @project.id

    assigns[:display_form].should eql(true)
  end

  it "should set @display_form to true if the 'new' parameter is used" do
    get :index, :id => @project.id, :new => 'true'
    assigns[:display_form].should eql(true)
  end
  
  it "should only show the deliverables for the current project only" do
    # TODO: Get spec working for full finder
    Deliverable.should_receive(:find)
    get :index, :id => @project.id
  end
end

