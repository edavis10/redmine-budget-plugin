class FixedDeliverable < Deliverable
  unloadable
  
  # Fixed rate bids should always have a budget score of 0. This is because the budget is managed by the contractor.
  def score
    0
  end
end
