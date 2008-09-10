# Hooks to attach to the Redmine Projects.
class BudgetProjectHook < Redmine::Hook::ViewListener

  def protect_against_forgery?
    false
  end
  
  # Renders an additional table header to the membership setting
  #
  # Context: none
  def view_projects_settings_members_table_header(context ={ })
    if context[:project].module_enabled?('budget_module')
      return "<th>#{GLoc.l(:label_member_rate) }</th>"
    else
      return ''
    end
  end
  
  # Renders an AJAX from to update the member's billing rate
  #
  # Context:
  # * :member => Current Member record
  #
  def view_projects_settings_members_table_row(context = { })
    if context[:project].module_enabled?('budget_module')
      # Build a form_remote_tag by hand since this isn't in the scope of a controller 
      form = form_tag({:controller => 'members', :action => 'edit', :id => context[:member].id, :protocol => Setting.protocol, :host => Setting.host_name},
                           :onsubmit => remote_function(:url => {
                                                               :controller => 'members',
                                                               :action => 'edit',
                                                               :id => context[:member].id,
                                                               :protocol => Setting.protocol,
                                                               :host => Setting.host_name
                                                             },
                                                             :host => Setting.host_name,
                                                             :protocol => Setting.protocol,
                                                             :form => true,
                                                             :method => 'post',
                                                             :return => 'false' )+ '; return false;') + 
        text_field_tag('member[rate]', number_with_precision(context[:member].rate, 0), :class => "small") + 
        submit_tag(GLoc.l(:button_change), :class => "small") + "</form>"
      
      return content_tag(:td, form, :align => 'center' )
    else
      return ''
    end
  end
end
