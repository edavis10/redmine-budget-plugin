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
