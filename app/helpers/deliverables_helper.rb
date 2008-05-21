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
end
