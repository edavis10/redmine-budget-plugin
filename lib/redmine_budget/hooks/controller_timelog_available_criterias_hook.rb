module RedmineBudget
  module Hooks
    class ControllerTimelogAvailableCriteriasHook < Redmine::Hook::ViewListener
      # Adds the Deliverable as a filter to the Timelog Report
      def controller_timelog_available_criterias(context={})
        context[:available_criterias]["deliverable_id"] = {
          :sql => "#{Issue.table_name}.deliverable_id",
          :klass => Deliverable,
          :label => :field_deliverable
        }
        return ''
      end
    end
  end
end
