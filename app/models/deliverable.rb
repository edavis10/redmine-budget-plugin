class Deliverable < ActiveRecord::Base
  belongs_to :project

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
