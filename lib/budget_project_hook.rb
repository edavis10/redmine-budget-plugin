class BudgetProjectHook
  
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

  
  # TODO: Complete
  def self.member_list_header(context ={ })
    return "<th>#{GLoc.l(:label_member_rate) }</th>"
  end
  
  # TODO: Complete
  def self.member_list_column_three(context = { })
    return '<td align="center">Nothing yet</td>'
  end
end
