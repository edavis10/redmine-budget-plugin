class BudgetProjectHook

  # http://snippets.dzone.com/posts/show/1799
  def self.help
    Helper.instance
  end

  class Helper
    include Singleton
    include ActionView::Helpers::TagHelper
    include ActionView::Helpers::UrlHelper
    include ActionView::Helpers::FormHelper
    include ActionView::Helpers::FormTagHelper
    include ActionView::Helpers::FormOptionsHelper
    include ActionView::Helpers::JavaScriptHelper 
    include ActionView::Helpers::PrototypeHelper
    
    include ActionController::UrlWriter 

    def protect_against_forgery?
      false
    end
  end

  def self.member_list_header(context ={ })
    return "<th>#{GLoc.l(:label_member_rate) }</th>"
  end
  
  def self.member_list_column_three(context = { })

    # Build a form_remote_tag by hand since this isn't in the scope of a controller 
    form = help.form_tag({:controller => 'members', :action => 'edit', :id => context[:member].id, :host => Setting.host_name},
                         :onsubmit => help.remote_function(:url => {
                                                             :controller => 'members',
                                                             :action => 'edit',
                                                             :id => context[:member].id,
                                                             :host => Setting.host_name
                                                           },
                                                           :host => Setting.host_name,
                                                           :form => true,
                                                           :method => 'post',
                                                           :return => 'false' )+ '; return false;') + 
      help.text_field_tag('member[rate]', context[:member].rate, :class => "small") + 
      help.submit_tag(GLoc.l(:button_change), :class => "small") + "</form>"
    
    return help.content_tag(:td, form, :align => 'center' )
    
  end
end
