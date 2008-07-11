require File.dirname(__FILE__) + '/../spec_helper'

describe FixedDeliverable, '.score' do
  it 'should always be 0' do
    @deliverable = FixedDeliverable.new({ :subject => 'test' })
    @deliverable.score.should eql(0)
  end
end

describe FixedDeliverable, '.spent' do
  it 'should always equal the fixed cost if there are no hours logged' do
    @deliverable = FixedDeliverable.new({ :subject => 'test' })
    @deliverable.stub!(:fixed_cost).and_return(5000.0)
    @deliverable.spent.should eql(5000.0)
  end
  
  it 'should return 0.0 if fixed_cost is not set' do
    @deliverable = FixedDeliverable.new({ :subject => 'test' })
    @deliverable.spent.should eql(0.0)
  end
end

describe FixedDeliverable, '.profit as a %' do
  it 'should return the % of the fixed bid and overhead amount' do    
    @deliverable = FixedDeliverable.new({ :subject => 'test', :profit_percent => 50, :fixed_cost => 1000.0, :overhead => "1000.00", :overhead_percent => nil })
    @deliverable.profit.should eql(1000.0)
  end

  it 'should return the % of the fixed bid and overhead percentage' do    
    @deliverable = FixedDeliverable.new({ :subject => 'test', :profit_percent => 50, :fixed_cost => 1000.0, :overhead => nil, :overhead_percent => 100 })
    @deliverable.profit.should eql(1000.0)
  end
end
