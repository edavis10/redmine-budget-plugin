require File.dirname(__FILE__) + '/../spec_helper'

describe Deliverable do
  it "should not be valid without subject" do
    Deliverable.new.should_not be_valid
  end

  it "should be valid" do
    Deliverable.new({ :subject => 'test' }).should be_valid
  end
end

describe Deliverable, 'associations' do
  it "should have a project association" do
    Deliverable.reflect_on_association(:project).should_not be( nil )
  end
  
  it "should have an issues association" do
    Deliverable.reflect_on_association(:issues).should_not be( nil )    
  end
end

describe Deliverable, '.overhead=' do
  before(:each) do
    @deliverable = Deliverable.new({ :subject => 'test' })
  end
  
  describe 'with a dollar amount' do
    it 'should store the dollar amount' do
      @deliverable.overhead = "$1, 000.10"
      @deliverable.read_attribute(:overhead).should eql(1000.1)
    end
    
    it 'should clear the .overhead_percent' do
      @deliverable.overhead = "$1, 000.10"
      @deliverable.read_attribute(:overhead_percent).should eql(nil)
    end
  end
  
  describe 'with a percentage' do
    it 'should store the % of the amount to .overhead_percent' do
      @deliverable.overhead = "100 %"
      @deliverable.read_attribute(:overhead_percent).should eql(100)
    end

    it 'should clean the .overhead' do
      @deliverable.overhead = "100 %"
      @deliverable.read_attribute(:overhead).should eql(nil)
    end
  end  
end

describe Deliverable, '.materials' do
  before(:each) do
    @deliverable = Deliverable.new({ :subject => 'test' })
  end
  
  describe 'with a dollar amount' do
    it 'should store the dollar amount' do
      @deliverable.materials = "$1, 000.10"
      @deliverable.materials.should eql(1000.1)
    end
    
    it 'should clear the .materials_percent' do
      @deliverable.materials = "$1, 000.10"
      @deliverable.materials_percent.should eql(nil)
    end
  end
  
  describe 'with a percentage' do
    it 'should store the % of the amount to .materials_percent' do
      @deliverable.materials = "100 %"
      @deliverable.materials_percent.should eql(100)
    end

    it 'should clean the .materials' do
      @deliverable.materials = "100 %"
      @deliverable.materials.should eql(nil)
    end
  end  
end

describe Deliverable, '.profit' do
  before(:each) do
    @deliverable = Deliverable.new({ :subject => 'test' })
  end
  
  describe 'with a dollar amount' do
    it 'should store the dollar amount' do
      @deliverable.profit = "$1, 000.10"
      @deliverable.profit.should eql(1000.1)
    end
    
    it 'should clear the .profit_percent' do
      @deliverable.profit = "$1, 000.10"
      @deliverable.profit_percent.should eql(nil)
    end
  end
  
  describe 'with a percentage' do
    it 'should store the % of the amount to .profit_percent' do
      @deliverable.profit = "100 %"
      @deliverable.profit_percent.should eql(100)
    end

    it 'should clean the .profit' do
      @deliverable.profit = "100 %"
      @deliverable.profit.should eql(nil)
    end
  end  
end

describe Deliverable, '.budget_ratio' do
  it 'should be the whole number of the budget spent' do
    @deliverable = Deliverable.new({ :subject => 'test' })
    @deliverable.should_receive(:budget).exactly(3).times.and_return(3000.00)
    @deliverable.should_receive(:spent).and_return(1000.00)
    
    @deliverable.budget_ratio.should eql(33)
  end
end

describe Deliverable, '.budget' do
  it 'should return 0 if the budget is nil' do
    @deliverable = Deliverable.new({ :subject => 'test' })
    
    @deliverable.budget.should eql(0)
    @deliverable.read_attribute(:budget).should eql(nil)
  end
end

describe Deliverable, '.score' do
  it 'should be calculated by the progress and the budget usage' do
    @deliverable = Deliverable.new({ :subject => 'test' })
    @deliverable.should_receive(:progress).and_return(75)
    @deliverable.should_receive(:budget_ratio).and_return(33)
    
    @deliverable.score.should eql(42)
  end
end

describe Deliverable, '.progress' do
  before(:each) do
    Setting.stub!(:issue_status_for_done_ratio?).and_return(false)
  end

  describe 'using the issue done ratio' do
    it 'should be calculated by the weighted average of the estimated hours of issues' do
      @issue1 = mock_model(Issue)
      @issue1.should_receive(:done_ratio).and_return(50)
      @issue1.should_receive(:estimated_hours).exactly(3).times.and_return(3.0)
      @issue2 = mock_model(Issue)
      @issue2.should_receive(:done_ratio).and_return(0)
      @issue2.should_receive(:estimated_hours).exactly(3).times.and_return(2.0)
      @issue3 = mock_model(Issue)
      @issue3.should_receive(:done_ratio).and_return(80)
      @issue3.should_receive(:estimated_hours).exactly(3).times.and_return(10.0)
      @issue4 = mock_model(Issue)
      @issue4.should_receive(:done_ratio).and_return(100)
      @issue4.should_receive(:estimated_hours).exactly(3).times.and_return(1.0)
      @issues = [@issue1, @issue2, @issue3, @issue4]
      @issues.stub!(:count).and_return(4)
      
      @deliverable = Deliverable.new({ :subject => 'test' })
      @deliverable.should_receive(:issues).exactly(3).times.and_return(@issues)
      
      @deliverable.progress.should eql(66)
    end
  end

  describe 'using the status done ratio patch' do
    before(:each) do
      Setting.stub!(:issue_status_for_done_ratio?).and_return(true)
      @status_in_progress = mock_model(IssueStatus)
      @status_in_progress.stub!(:default_done_ratio).and_return(50)
      @status_new = mock_model(IssueStatus)
      @status_new.stub!(:default_done_ratio).and_return(0)
      @status_pending = mock_model(IssueStatus)
      @status_pending.stub!(:default_done_ratio).and_return(80)
      @status_complete = mock_model(IssueStatus)
      @status_complete.stub!(:default_done_ratio).and_return(100)

    end
    
    it 'should be calculated by the weighted average of the estimated hours of issues' do
      @issue1 = mock_model(Issue)
      @issue1.should_receive(:status).and_return(@status_in_progress)
      @issue1.should_receive(:estimated_hours).exactly(3).times.and_return(3.0)
      @issue2 = mock_model(Issue)
      @issue2.should_receive(:status).and_return(@status_new)
      @issue2.should_receive(:estimated_hours).exactly(3).times.and_return(2.0)
      @issue3 = mock_model(Issue)
      @issue3.should_receive(:status).and_return(@status_pending)
      @issue3.should_receive(:estimated_hours).exactly(3).times.and_return(10.0)
      @issue4 = mock_model(Issue)
      @issue4.should_receive(:status).and_return(@status_complete)
      @issue4.should_receive(:estimated_hours).exactly(3).times.and_return(1.0)
      @issues = [@issue1, @issue2, @issue3, @issue4]
      @issues.stub!(:count).and_return(4)
      
      @deliverable = Deliverable.new({ :subject => 'test' })
      @deliverable.should_receive(:issues).exactly(3).times.and_return(@issues)
      
      @deliverable.progress.should eql(66)
    end
  end

  it 'should return 0 if there are no assigned issues' do
    @deliverable = Deliverable.new({ :subject => 'test' })
    @deliverable.should_receive(:issues).and_return([])
    
    @deliverable.progress.should eql(0)
  end

  it 'should not count issues with no estimated time' do
    @issue1 = mock_model(Issue)
    @issue1.should_receive(:done_ratio).and_return(50)
    @issue1.should_receive(:estimated_hours).exactly(3).times.and_return(3.0)
    @issue2 = mock_model(Issue)
    @issue2.should_receive(:estimated_hours).exactly(2).times.and_return(nil)
    @issues = [@issue1, @issue2]
    @issues.stub!(:count).and_return(2)
    
    @deliverable = Deliverable.new({ :subject => 'test' })
    @deliverable.should_receive(:issues).exactly(3).times.and_return(@issues)
    
    @deliverable.progress.should eql(50)
  end
  
  it 'should return 0 if there are no estimates on any of the assigned issues' do
    @issue1 = mock_model(Issue)
    @issue1.should_receive(:estimated_hours).and_return(nil)
    @issue2 = mock_model(Issue)
    @issue2.should_receive(:estimated_hours).and_return(nil)
    @issues = [@issue1, @issue2]
    @issues.stub!(:count).and_return(2)
    
    @deliverable = Deliverable.new({ :subject => 'test' })
    @deliverable.should_receive(:issues).exactly(2).times.and_return(@issues)
    
    @deliverable.progress.should eql(0)
    
  end
  
  it 'should not change when hours are clocked'

  it 'should change if issues are assigned'

  it 'should change if issues are unassigned'

  it 'should change when a status changes'
end

describe Deliverable, '.spent' do
  it 'should always return 0 (abstract class)' do
    @deliverable = Deliverable.new({ :subject => 'test' })
    
    @deliverable.spent.should eql(0)
  end
end

describe Deliverable, 'fixed?' do
  it 'should be true for FixedDeliverables' do
    FixedDeliverable.new.fixed?.should be_true
  end

  it 'should be false for HourlyDeliverables' do
    HourlyDeliverable.new.fixed?.should be_false
  end

  it 'should be false for generic Deliverables' do
    Deliverable.new.fixed?.should be_false
  end
end

describe Deliverable, 'hourly?' do
  it 'should be false for FixedDeliverables' do
    FixedDeliverable.new.hourly?.should be_false
  end

  it 'should be true for HourlyDeliverables' do
    HourlyDeliverable.new.hourly?.should be_true
  end

  it 'should be false for generic Deliverables' do
    Deliverable.new.hourly?.should be_false
  end
end

describe Deliverable, 'labor_budget' do
  it 'should be 0 because the specific Deliverables will have their own logic' do
    Deliverable.new.labor_budget.should eql(0)
  end
end

describe Deliverable, 'budget_remaining' do
  it 'should calculated by the budget minus the amount spent' do
    deliverable = Deliverable.new({ :budget => 3000.00})
    deliverable.should_receive(:spent).and_return(1000.0)
    deliverable.budget_remaining.should eql(2000.0)
  end
  
  it 'should be the same as Budget#left' do
    deliverable = Deliverable.new({ :budget => 3000.00})
    deliverable.should_receive(:spent).twice.and_return(1000.0)
    deliverable.budget_remaining.should eql(deliverable.left)
  end
end

describe Deliverable, 'hours_used' do
  it 'should return 0 if there are no issues on the Deliverable' do
    deliverable = Deliverable.new
    deliverable.hours_used.should eql(0)
  end

  it 'should total up the hours on the issues assigned to the Deliverable' do
    deliverable = Deliverable.new
    time_entries = [mock_model(TimeEntry, :hours => 100)]
    issues = [mock_model(Issue, :time_entries => time_entries)]
    deliverable.should_receive(:issues).at_least(:once).and_return(issues)
    
    deliverable.hours_used.should eql(100)
  end
end

describe Deliverable, 'overruns' do
  it 'should be 0 if there still is budget left' do
    deliverable = Deliverable.new
    deliverable.should_receive(:left).and_return(100)
    deliverable.overruns.should eql(0)
  end

  it 'should be the invoice of left if left is below 0' do
    deliverable = Deliverable.new
    deliverable.should_receive(:left).at_least(:once).and_return(-100)
    deliverable.overruns.should eql(100)
  end
end
