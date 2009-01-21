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
    
    @issue_1_time_entry = mock_model(TimeEntry, :issue_id => @issue1.id, :user => @user, :project => @project, :hours => 1.0, :spent_on => Date.today)
    @issue_1_time_entry.should_receive(:cost).and_return(60.0)
    @issue1.stub!(:time_entries).and_return([@issue_1_time_entry])
    
    @deliverable = HourlyDeliverable.new({ :subject => 'test' })
    @issues = [@issue1]
    @deliverable.should_receive(:issues).twice.and_return(@issues)
    
    @deliverable.spent.should eql(60.0)
  end
end

describe HourlyDeliverable, '.profit as a %' do
  it 'should return the % of the hours mutipled by the cost per hour amount plus the overhead' do    
    @deliverable = HourlyDeliverable.new({ :subject => 'test', :profit_percent => 50, :cost_per_hour => 100.0, :total_hours => 10, :overhead => '1000.00', :overhead_percent => nil })
    @deliverable.profit.should eql(1000.0)
  end

  it 'should return the % of the hours mutipled by the cost per hour amount plus the overhead percentage' do    
    @deliverable = HourlyDeliverable.new({ :subject => 'test', :profit_percent => 50, :cost_per_hour => 100.0, :total_hours => 10, :overhead => nil, :overhead_percent => 100 })
    @deliverable.profit.should eql(1000.0)
  end
end

describe HourlyDeliverable, '.profit as an dollar amount' do
  it 'should return the amount' do
    deliverable = HourlyDeliverable.new({ :subject => 'test', :profit => "$100.00", :cost_per_hour => 100.0, :total_hours => 10, :overhead => "1000.00", :overhead_percent => nil })
    deliverable.profit.should eql(100.0)
  end
end
