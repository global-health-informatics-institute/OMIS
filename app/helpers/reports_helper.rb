module ReportsHelper
  def select_report
    options = [['HR Report', 'HR'], ['Asset Status', 'Assets'],
               ['Monthly Individual LOE Report', 'Employee LOE'],
               ['Monthly Organization LOE Report', 'Org LOE'],
               ['Project Progress Report','Project Report']
    ]
    return options
  end
end
