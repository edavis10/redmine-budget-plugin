require File.dirname(__FILE__) + '/../spec_helper'

describe Deliverable do
  it "should be valid" do
    Deliverable.new.should be_valid
  end
end
