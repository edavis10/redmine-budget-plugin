class FixedDeliverable < Deliverable
  unloadable
  
  # FixedDeliverables should always have a budget score of 0. This is because the budget is managed by the contractor.
  def score
    0
  end

  # Returns the amount spent.  It will always be the fixed cost because
  # that money has been allocated already and is managed by the user
  def spent
    self.fixed_cost || 0.0
  end
  
  def profit # :nodoc:
    if read_attribute(:profit_percent).nil?
      return super
    else
      return (read_attribute(:profit_percent).to_f / 100.0) * (read_attribute(:fixed_cost) + self.overhead)
    end
  end
  
  # Budget for the labor, excluding overhead, profit, and materials
  def labor_budget
    return read_attribute(:fixed_cost) || 0.0
  end

end
