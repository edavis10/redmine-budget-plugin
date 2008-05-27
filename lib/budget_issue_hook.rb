class BudgetIssueHook
  
  # http://snippets.dzone.com/posts/show/1799
  def self.help
    Helper.instance
  end

  class Helper
    include Singleton
    include ActionView::Helpers::TagHelper
    include ActionView::Helpers::FormHelper
    include ActionView::Helpers::FormTagHelper
    include ActionView::Helpers::FormOptionsHelper
  end
  
  def self.issue_show(context = { })
    # TODO: Escape
    data = "<td><b>Deliverable :</b></td><td>#{context[:issue].deliverable.subject unless context[:issue].deliverable.nil?}</td>"
    return "<tr>#{data}<td></td></tr>"
  end
  
  def self.issue_edit(context = { })
    select = context[:form].select :deliverable_id, Deliverable.find_all_by_project_id(context[:project]).collect { |d| [d.subject, d.id] }, :include_blank => true 
    return "<p>#{select}</p>"
  end
  
  def self.issue_bulk_edit(context = { })
    select = help.select_tag('deliverable_id',
                        help.content_tag('option', GLoc.l(:label_no_change_option), :value => '') +
                                help.content_tag('option', GLoc.l(:label_none), :value => 'none') +
                                help.options_from_collection_for_select(Deliverable.find_all_by_project_id(context[:project].id, :id, :subject), :id, :subject))
    
    return help.content_tag(:p, "<label>#{GLoc.l(:field_deliverable)}: " + select + "</label>")
  end
end
