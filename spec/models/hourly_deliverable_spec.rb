require File.dirname(__FILE__) + '/../spec_helper'

describe HourlyDeliverable, '.spent' do
  it 'should equal 0 if there are no issues for the deliverable' do
    @deliverable = HourlyDeliverable.new({ :subject => 'test' })
    @deliverable.should_receive(:issues).and_return([])
    
    @deliverable.spent.should eql(0)
  end
  
  it 'should return the sum of the member timelogs' do
    @project = mock_model(Project)
    @user = mock_model(User)
    @issue1 = mock_model(Issue)
    
    @issue_1_time_entry = mock_model(TimeEntry, :issue_id => @issue1.id, :user_id => @user.id, :project_id => @project.id, :hours => 1.0)
    @issue1.stub!(:time_entries).and_return([@issue_1_time_entry])
    
    @member = mock_model(Member, :user => @user, :project => @project, :rate => 60.0)
    Member.should_receive(:find_by_user_id_and_project_id).with(@user.id, @project.id).and_return(@member)
    
    @deliverable = HourlyDeliverable.new({ :subject => 'test' })
    @issues = [@issue1]
    @deliverable.should_receive(:issues).twice.and_return(@issues)
    
    @deliverable.spent.should eql(60.0)
  end
end

describe HourlyDeliverable, '.profit as a %' do
  it 'should return the % of the hours mutipled by the cost per hour amount' do    
    @deliverable = HourlyDeliverable.new({ :subject => 'test', :profit_percent => 50, :cost_per_hour => 100.0, :total_hours => 10 })
    @deliverable.profit.should eql(500.0)
  end
end
