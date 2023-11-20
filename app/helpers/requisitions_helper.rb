module RequisitionsHelper
  def select_requisition
    options = [['Petty Cash Request','Petty Cash' ], ['Asset Request', 'Asset Request'],
               ['Purchase Request', 'Purchase Request'],
               ['Travel Requisition','Travel Request',],
               ['Personnel Requests','Personnel Request'],
               ['Leave Request', 'Leave Request']
    ]
    return options
  end


end
