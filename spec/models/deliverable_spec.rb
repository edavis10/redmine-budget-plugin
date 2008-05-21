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

describe Deliverable, '.overhead' do
  before(:each) do
    @deliverable = Deliverable.new({ :subject => 'test' })
  end
  
  describe 'with a dollar amount' do
    it 'should store the dollar amount' do
      @deliverable.overhead = "$1, 000.10"
      @deliverable.overhead.should eql(1000.1)
    end
    
    it 'should clear the .overhead_percent' do
      @deliverable.overhead = "$1, 000.10"
      @deliverable.overhead_percent.should eql(nil)
    end
  end
  
  describe 'with a percentage' do
    it 'should store the % of the amount to .overhead_percent' do
      @deliverable.overhead = "100 %"
      @deliverable.overhead_percent.should eql(100)
    end

    it 'should clean the .overhead' do
      @deliverable.overhead = "100 %"
      @deliverable.overhead.should eql(nil)
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
