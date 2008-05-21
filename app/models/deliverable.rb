class Deliverable < ActiveRecord::Base
  unloadable

  belongs_to :project

  attr_accessor :overhead
  attr_accessor :materials
  attr_accessor :profit
  attr_accessor :cost_per_hour
  attr_accessor :total_hours
  
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
