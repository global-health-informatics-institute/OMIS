module RequisitionsHelper
  def select_requisition
    [
      ['Petty Cash Request', 'Petty Cash'],
      ['Asset Request', 'Asset Request'],
      ['Purchase Request', 'Purchase Request'],
      ['Travel Requisition', 'Travel Request'],
      ['Personnel Requests', 'Personnel Request'],
      ['Leave Request', 'Leave Request'],
      ['Token Request', 'Token Request']
    ]
  end

  def select_projects
    Project.all.collect { |data| [data.short_name, data.project_id] }
  end

  def select_donors
    Donor.all.collect { |data| [data.short_name, data.donor_id] }
  end

  def select_budget_lines
    BudgetLine.all.collect { |data| [data.short_name, data.budget_line_id] }
  end
end
