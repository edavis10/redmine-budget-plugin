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
end
