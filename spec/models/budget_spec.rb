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
    
    Deliverable.stub!(:find_all_by_project_id).and_return([@deliverable2, @deliverable1])
    Project.stub!(:find).with(@project.id).and_return(@project)
    
    @budget = Budget.new(@project.id)
    @budget.deliverables.should eql([@deliverable2, @deliverable1])
  end

  it 'should return an empty array if the project has no deliverables' do
    @project = mock_model(Project)
    @other_project_deliverable = mock_model(Deliverable, :project_id => 1)
    
    Deliverable.stub!(:find_all_by_project_id).and_return([])
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
    Deliverable.stub!(:find_all_by_project_id).and_return([@deliverable1, @deliverable2])
    Project.stub!(:find).with(@project.id).and_return(@project)
    
    @budget = Budget.new(@project.id)
    @budget.next_due_date.should eql(@tomorrow)
  end
  
  it 'should return nil if there are no deliverables' do
    @project = mock_model(Project)
    Deliverable.stub!(:find_all_by_project_id).and_return([])
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
    Deliverable.stub!(:find_all_by_project_id).and_return([@deliverable1, @deliverable2])
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
    Deliverable.stub!(:find_all_by_project_id).and_return([@deliverable1, @deliverable2])
    Project.stub!(:find).with(@project.id).and_return(@project)
    
    @budget = Budget.new(@project.id)
    @budget.next_due_date.should eql(@next_week)
    
  end
end

describe Budget, '.final_due_date' do
  it 'should get the latest due date from the projects Deliverables' do
    @tomorrow = Date.today + 1.days
    @next_week = Date.today + 7.days
    
    @deliverable1 = mock_model(Deliverable, :project_id => @project, :due_date => @next_week)
    @deliverable2 = mock_model(Deliverable, :project_id => @project, :due_date => @tomorrow)

    @project = mock_model(Project)
    Deliverable.stub!(:find_all_by_project_id).and_return([@deliverable1, @deliverable2])
    Project.stub!(:find).with(@project.id).and_return(@project)
    
    @budget = Budget.new(@project.id)
    @budget.final_due_date.should eql(@next_week)
  end
  
  it 'should return nil if there are no deliverables' do
    @project = mock_model(Project)
    Deliverable.stub!(:find_all_by_project_id).and_return([])
    Project.stub!(:find).with(@project.id).and_return(@project)
    
    @budget = Budget.new(@project.id)
    @budget.final_due_date.should be_nil
    
  end
  
  it 'should not count dates that are nil' do
    @tomorrow = Date.today + 1.days
    @next_week = Date.today + 7.days
    
    @deliverable1 = mock_model(Deliverable, :project_id => @project, :due_date => @next_week)
    @deliverable2 = mock_model(Deliverable, :project_id => @project, :due_date => nil)

    @project = mock_model(Project)
    Deliverable.stub!(:find_all_by_project_id).and_return([@deliverable1, @deliverable2])
    Project.stub!(:find).with(@project.id).and_return(@project)
    
    @budget = Budget.new(@project.id)
    @budget.final_due_date.should eql(@next_week)
    
  end

  it 'should not count dates that are empty' do
    @tomorrow = Date.today + 1.days
    @next_week = Date.today + 7.days
    
    @deliverable1 = mock_model(Deliverable, :project_id => @project, :due_date => @next_week)
    @deliverable2 = mock_model(Deliverable, :project_id => @project, :due_date => '')

    @project = mock_model(Project)
    Deliverable.stub!(:find_all_by_project_id).and_return([@deliverable1, @deliverable2])
    Project.stub!(:find).with(@project.id).and_return(@project)
    
    @budget = Budget.new(@project.id)
    @budget.final_due_date.should eql(@next_week)
    
  end
end

describe Budget, '.progress' do
  it 'should be the weighted average by the deliverable progress and budget' do
    @deliverable1 = mock_model(Deliverable, :project_id => @project, :budget => 2000.00, :progress => 50)
    @deliverable2 = mock_model(Deliverable, :project_id => @project, :budget => 3000.00, :progress => 75)

    @project = mock_model(Project)
    Deliverable.stub!(:find_all_by_project_id).and_return([@deliverable1, @deliverable2])
    Project.stub!(:find).with(@project.id).and_return(@project)
    
    @budget = Budget.new(@project.id)  
    @budget.progress.should eql(65)
  end
  
  it 'should return 100 if there are no deliverables' do
    @project = mock_model(Project)
    Deliverable.stub!(:find_all_by_project_id).and_return([])
    Project.stub!(:find).with(@project.id).and_return(@project)
    
    @budget = Budget.new(@project.id)  
    @budget.progress.should eql(100)
  end
end

describe Budget,'.budget' do
  it 'should be the sum of all the deliverables budget' do
    @deliverable1 = mock_model(Deliverable, :project_id => @project, :budget => 2000.00)
    @deliverable2 = mock_model(Deliverable, :project_id => @project, :budget => 3000.00)

    @project = mock_model(Project)
    Deliverable.stub!(:find_all_by_project_id).and_return([@deliverable1, @deliverable2])
    Project.stub!(:find).with(@project.id).and_return(@project)
    
    @budget = Budget.new(@project.id)  
    @budget.budget.should eql(5000.0)
  end

  it 'should be 0 if there are no deliverables' do
    Deliverable.stub!(:find_all_by_project_id).and_return([])
    
    @project = mock_model(Project)
    Project.stub!(:find).with(@project.id).and_return(@project)
    
    @budget = Budget.new(@project.id)

    @budget.budget.should eql(0.0)    
  end
end

describe Budget,'.budget_ratio' do
  it 'should be the whole number of the budget spent (out of 100)' do

    @project = mock_model(Project)
    Project.stub!(:find).with(@project.id).and_return(@project)
    
    @budget = Budget.new(@project.id)  
    @budget.should_receive(:budget).and_return(5000.00)
    @budget.should_receive(:spent).and_return(2000.00)
    @budget.budget_ratio.should eql(40)
  end
  
  it 'should return progress if the budget is < 0' do
    @project = mock_model(Project)
    Project.stub!(:find).with(@project.id).and_return(@project)
    
    @budget = Budget.new(@project.id)  
    @budget.should_receive(:budget).and_return(0.0)
    @budget.should_receive(:progress).and_return(50)
    @budget.budget_ratio.should eql(50)
  end

end


describe Budget, '.score' do
  it 'should be calculated by the progress and budget for the deliverables' do
    @project = mock_model(Project)
    Project.stub!(:find).with(@project.id).and_return(@project)
    
    @budget = Budget.new(@project.id)  
    @budget.should_receive(:progress).and_return(65)
    @budget.should_receive(:budget_ratio).and_return(40)

    @budget.score.should eql(25)
  end
end

describe Budget, '.left' do
  it 'should be calculated by the total budget and total spent of the deliverables' do
    @project = mock_model(Project)
    Project.stub!(:find).with(@project.id).and_return(@project)
    
    @budget = Budget.new(@project.id)  
    @budget.should_receive(:budget).and_return(6000.0)
    @budget.should_receive(:spent).and_return(4500.0)

    @budget.left.should eql(1500.0)
  end
end

describe Budget, '.overruns' do
  it 'should be 0 if there is still unspent budget' do
    @project = mock_model(Project)
    Project.stub!(:find).with(@project.id).and_return(@project)
    
    @budget = Budget.new(@project.id)  
    @budget.should_receive(:left).and_return(1500.0)

    @budget.overruns.should eql(0)
  end

  it 'should be calculated by the total budget and total spent of the deliverables' do
    @project = mock_model(Project)
    Project.stub!(:find).with(@project.id).and_return(@project)
    
    @budget = Budget.new(@project.id)  
    @budget.should_receive(:left).twice.and_return(-1500.0)

    @budget.overruns.should eql(1500.0)
  end
end

describe Budget, '.spent' do
  it 'should be calculated by the total spent of the deliverables' do
    @deliverable1 = mock_model(HourlyDeliverable, :project_id => @project, :spent => 1000.00)
    @deliverable2 = mock_model(HourlyDeliverable, :project_id => @project, :spent => 500.00)
    Deliverable.stub!(:find_all_by_project_id).and_return([@deliverable1, @deliverable2])
    
    @project = mock_model(Project)
    Project.stub!(:find).with(@project.id).and_return(@project)
    
    @budget = Budget.new(@project.id)

    @budget.spent.should eql(1500.0)
  end
  
  it 'should be 0 if there are no deliverables' do
    Deliverable.stub!(:find_all_by_project_id).and_return([])
    
    @project = mock_model(Project)
    Project.stub!(:find).with(@project.id).and_return(@project)
    
    @budget = Budget.new(@project.id)

    @budget.spent.should eql(0.0)    
  end
end
  
describe Budget, '.profit' do
  it 'should be calculated by the total profit of the deliverables' do
    @project = mock_model(Project)
    @deliverable1 = mock_model(HourlyDeliverable, :project_id => @project, :profit => 2000.00, :profit_percent => nil)
    @deliverable2 = mock_model(HourlyDeliverable, :project_id => @project, :profit => 3000.00, :profit_percent => nil)

    Deliverable.stub!(:find_all_by_project_id).and_return([@deliverable1, @deliverable2])
    Project.stub!(:find).with(@project.id).and_return(@project)
    
    @budget = Budget.new(@project.id)

    @budget.profit.should eql(5000.0)
  end

  it 'should be calculated by the total profit of the deliverables with % amounts' do
    @project = mock_model(Project)
    @deliverable1 = mock_model(HourlyDeliverable, :project_id => @project, :profit_percent => 10, :budget => 2000.0, :profit => nil)
    @deliverable2 = mock_model(HourlyDeliverable, :project_id => @project, :profit_percent => 10, :budget => 1000.0, :profit => nil)

    Deliverable.stub!(:find_all_by_project_id).and_return([@deliverable1, @deliverable2])
    Project.stub!(:find).with(@project.id).and_return(@project)
    
    @budget = Budget.new(@project.id)

    @budget.profit.should eql(300.0)
  end

  it 'should be 0 if there are no deliverables' do
    Deliverable.stub!(:find_all_by_project_id).and_return([])
    
    @project = mock_model(Project)
    Project.stub!(:find).with(@project.id).and_return(@project)
    
    @budget = Budget.new(@project.id)

    @budget.profit.should eql(0.0)    
  end
end
