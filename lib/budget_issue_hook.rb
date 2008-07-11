# Hooks to attach to the Redmine Issues.  They are attached in init.rb by the
# +add_hook+ method
class BudgetIssueHook < Redmine::Plugin::Hook::Base

  # Renders the Deliverable subject
  #
  # Context:
  # * :issue => Issue being rendered
  #
  def self.issue_show(context = { })
    if context[:project].module_enabled?('budget_module')
      data = "<td><b>Deliverable :</b></td><td>#{help.html_escape context[:issue].deliverable.subject unless context[:issue].deliverable.nil?}</td>"
      return "<tr>#{data}<td></td></tr>"
    else
      return ''
    end
  end
  
  # Renders a select tag with all the Deliverables
  #
  # Context:
  # * :form => Edit form
  # * :project => Current project
  #
  def self.issue_edit(context = { })
    if context[:project].module_enabled?('budget_module')
      select = context[:form].select :deliverable_id, Deliverable.find_all_by_project_id(context[:project], :order => 'subject ASC').collect { |d| [d.subject, d.id] }, :include_blank => true 
      return "<p>#{select}</p>"
    else
      return ''
    end
  end
  
  # Renders a select tag with all the Deliverables for the bulk edit page
  #
  # Context:
  # * :project => Current project
  #
  def self.issue_bulk_edit(context = { })
    if context[:project].module_enabled?('budget_module')
      select = help.select_tag('deliverable_id',
                               help.content_tag('option', GLoc.l(:label_no_change_option), :value => '') +
                               help.content_tag('option', GLoc.l(:label_none), :value => 'none') +
                               help.options_from_collection_for_select(Deliverable.find_all_by_project_id(context[:project].id, :order => 'subject ASC'), :id, :subject))
    
      return help.content_tag(:p, "<label>#{GLoc.l(:field_deliverable)}: " + select + "</label>")
    else
      return ''
    end
  end
  
  # Saves the Deliverable assignment to the issue
  #
  # Context:
  # * :issue => Issue being saved
  # * :params => HTML parameters
  #
  def self.issue_bulk_edit_save(context = { })
    case true

    when context[:params][:deliverable_id].blank?
      # Do nothing
    when context[:params][:deliverable_id] == 'none'
      # Unassign deliverable
      context[:issue].deliverable = nil
    else
      context[:issue].deliverable = Deliverable.find(context[:params][:deliverable_id])
    end

    return ''
  end
  
  # Deliverable changes for the journal use the Deliverable subject
  # instead of the id
  #
  # Context:
  # * :detail => Detail about the journal change
  #
  def self.issue_helper_show_details(context = { })
    # TODO Later: Overwritting the caller is bad juju
    if context[:detail].prop_key == 'deliverable_id'
      d = Deliverable.find_by_id(context[:detail].value)
      context[:detail].value = d.subject unless d.nil? || d.subject.nil?

      d = Deliverable.find_by_id(context[:detail].old_value)
      context[:detail].old_value = d.subject unless d.nil? || d.subject.nil?      
    end
    ''
  end
end
