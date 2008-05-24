require File.dirname(__FILE__) + '/../spec_helper'

describe Budget do
  it 'should not be an ActiveRecord class' do
    Budget.should_not be_a_kind_of(ActiveRecord::Base)
  end
end

describe Budget, '.new' do
  it 'should error without a project id' do
    lambda { @budget = Budget.new }.should raise_error
  end
  
  it 'should set @project to the initilized project id' do
    @project = mock_model(Project)
    Project.stub!(:find).with(@project.id).and_return(@project)
    
    @budget = Budget.new(@project.id)
    @budget.project.should eql(@project)
  end
end

describe Budget,'.deliverables' do
  it 'should return an array of the projects deliverables' do
    @project = mock_model(Project)
    @deliverable1 = mock_model(Deliverable, :project_id => @project)
    @deliverable2 = mock_model(Deliverable, :project_id => @project)
    @other_project_deliverable = mock_model(Deliverable, :project_id => 1)
    
    @project.stub!(:deliverables).and_return([@deliverable2, @deliverable1])
    Project.stub!(:find).with(@project.id).and_return(@project)
    
    @budget = Budget.new(@project.id)
    @budget.deliverables.should eql([@deliverable2, @deliverable1])
  end

  it 'should return an empty array if the project has no deliverables' do
    @project = mock_model(Project)
    @other_project_deliverable = mock_model(Deliverable, :project_id => 1)
    
    @project.stub!(:deliverables).and_return([])
    Project.stub!(:find).with(@project.id).and_return(@project)
    
    @budget = Budget.new(@project.id)
    @budget.deliverables.should eql([])
  end
  
end

describe Budget, '.next_due_date' do
  it 'should get the eariest due date from the projects Deliverables' do
    @tomorrow = Date.today + 1.days
    @next_week = Date.today + 7.days
    
    @deliverable1 = mock_model(Deliverable, :project_id => @project, :due_date => @next_week)
    @deliverable2 = mock_model(Deliverable, :project_id => @project, :due_date => @tomorrow)

    @project = mock_model(Project)
    @project.stub!(:deliverables).and_return([@deliverable1, @deliverable2])
    Project.stub!(:find).with(@project.id).and_return(@project)
    
    @budget = Budget.new(@project.id)
    @budget.next_due_date.should eql(@tomorrow)
  end
  
  it 'should return nil if there are no deliverables' do
    @project = mock_model(Project)
    @project.stub!(:deliverables).and_return([])
    Project.stub!(:find).with(@project.id).and_return(@project)
    
    @budget = Budget.new(@project.id)
    @budget.next_due_date.should be_nil
    
  end
  
  it 'should not count dates that are nil' do
    @tomorrow = Date.today + 1.days
    @next_week = Date.today + 7.days
    
    @deliverable1 = mock_model(Deliverable, :project_id => @project, :due_date => @next_week)
    @deliverable2 = mock_model(Deliverable, :project_id => @project, :due_date => nil)

    @project = mock_model(Project)
    @project.stub!(:deliverables).and_return([@deliverable1, @deliverable2])
    Project.stub!(:find).with(@project.id).and_return(@project)
    
    @budget = Budget.new(@project.id)
    @budget.next_due_date.should eql(@next_week)
    
  end

  it 'should not count dates that are empty' do
    @tomorrow = Date.today + 1.days
    @next_week = Date.today + 7.days
    
    @deliverable1 = mock_model(Deliverable, :project_id => @project, :due_date => @next_week)
    @deliverable2 = mock_model(Deliverable, :project_id => @project, :due_date => '')

    @project = mock_model(Project)
    @project.stub!(:deliverables).and_return([@deliverable1, @deliverable2])
    Project.stub!(:find).with(@project.id).and_return(@project)
    
    @budget = Budget.new(@project.id)
    @budget.next_due_date.should eql(@next_week)
    
  end
end
