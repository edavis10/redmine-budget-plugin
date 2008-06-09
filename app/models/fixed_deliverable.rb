class FixedDeliverable < Deliverable
  unloadable
  
  # Fixed rate bids should always have a budget score of 0. This is because the budget is managed by the contractor.
  def score
    0
  end
  
  def spent
    (self.progress.to_f / 100 ) * self.budget
  end
  
  def profit
    if read_attribute(:profit_percent).nil?
      return super
    else
      return (read_attribute(:profit_percent).to_f / 100.0) * read_attribute(:fixed_cost)
    end
  end
  
  def labor_budget
    return read_attribute(:fixed_cost)
  end

end
