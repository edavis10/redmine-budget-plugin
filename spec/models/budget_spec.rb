require File.dirname(__FILE__) + '/../spec_helper'

describe Budget do
  it 'should not be an ActiveRecord class' do
    Budget.should_not be_a_kind_of(ActiveRecord::Base)
  end
end
