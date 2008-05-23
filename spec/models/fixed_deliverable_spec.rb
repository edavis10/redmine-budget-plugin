require File.dirname(__FILE__) + '/../spec_helper'

describe FixedDeliverable, '.score' do
  it 'should always be 0' do
    @deliverable = FixedDeliverable.new({ :subject => 'test' })
    @deliverable.score.should eql(0)
  end
end
