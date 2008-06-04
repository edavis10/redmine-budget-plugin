require File.dirname(__FILE__) + '/../spec_helper'

describe FixedDeliverable, '.score' do
  it 'should always be 0' do
    @deliverable = FixedDeliverable.new({ :subject => 'test' })
    @deliverable.score.should eql(0)
  end
end

describe FixedDeliverable, '.spent' do
  it 'should always equal the progress % * budget' do    
    @deliverable = FixedDeliverable.new({ :subject => 'test' })
    @deliverable.stub!(:progress).and_return(50.0)
    @deliverable.stub!(:budget).and_return(5000.0)
    @deliverable.spent.should eql(2500.0)
  end
end

describe FixedDeliverable, '.profit as a %' do
  it 'should return the % of the fixed bid amount' do    
    @deliverable = FixedDeliverable.new({ :subject => 'test', :profit_percent => 50, :fixed_cost => 1000.0 })
    @deliverable.profit.should eql(500.0)
  end
end
