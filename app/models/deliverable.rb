class Deliverable < ActiveRecord::Base
  belongs_to :project

  attr_accessor :overhead
  attr_accessor :materials
  attr_accessor :profit
  
  # TODO: mocked
  def score
    0
  end
  
  # TODO: mocked
  def spent
    0
  end
  
  # TODO: mocked
  def progress
    0
  end
end
