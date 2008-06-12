module DeliverablesHelper

  # Helper to generate a form used to calculate the total budget while editing
  # a Deliverable
  def field_with_budget_observer_and_totals(form, field)
    content_tag(:tr,
                content_tag(:td, "<label for='deliverable_#{field}'>TODO</label>") +
                content_tag(:td, text_field(:deliverable, field, :size => 7)) +
                content_tag(:td,
                            content_tag(:span,
                                        0,
                                        :class => "budget-calculation",
                                        :id => field.to_s + '_subtotal'
                                        ) + observe_field('deliverable_' + field.to_s, :function => "new Budget.updateAmounts();")))
                            
  end
  
  # Helper to generate a consistant HTML format for displaying basic data
  def paragraph_with_data(label, data)
    content_tag(:p,
                content_tag(:span, label, :class => 'title') +
                content_tag(:span, h(data), :class => 'data'))
  end

  # Helper to generate a consistant HTML format for displaying basic data
  def paragraph_with_double_data(label, data1, data2)
    content_tag(:p,
                content_tag(:span, label, :class => 'title') +
                content_tag(:span,
                            content_tag(:span, h(data1), :class => 'left-data') +
                            content_tag(:span, h(data2), :class => 'right-data'),
                            :class => 'fake-table'))
                
  end

  # Check if the current user is allowed to manage the budget.  Based on Role permissions.
  def allowed_management?
    return User.current.allowed_to?(:manage_budget, @project)
  end
end
