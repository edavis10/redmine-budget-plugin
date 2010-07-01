module RedmineBudget
  module Hooks
    class ControllerTimelogAvailableCriteriasHook < Redmine::Hook::ViewListener
      def controller_timelog_available_criterias(context={})
        return ''
      end
    end
  end
end
