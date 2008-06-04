module DeliverablesHelper
  def field_with_budget_observer_and_totals(form, field)
    content_tag(:p,
                form.text_field(field, :size => 7) +
                content_tag(:span,
                            0,
                            :class => "budget-calculation",
                            :id => field.to_s + '_subtotal'
                            )
                ) + observe_field('deliverable_' + field.to_s, :function => "new Budget.updateAmounts();")
  end
  
  def paragraph_with_data(label, data)
    content_tag(:p,
                content_tag(:span, label) +
                h(data))
  end
  
  def allowed_management?
    return User.current.allowed_to?(:manage_budget, @project)
  end
end
