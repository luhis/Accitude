class ReportsController < ApplicationController

  def index
    ren_cont 'index'
  end

  def overview
    incoming_paid = 0
    outgoing_paid = 0
    outgoing_unpaid = 0 # people who i owe cash to
    incoming_unpaid = 0 # people who owe me cash
    @current_org.invoices.each {|i| i.paid_on ? (incoming_paid += i.total_value) : (incoming_unpaid += i.total_value)}
    @current_org.liabilities.each {|l| l.paid_on ? (outgoing_paid += l.value) : (outgoing_unpaid += l.value)}


    ren_cont 'overview', {:incoming_paid => incoming_paid, :incoming_unpaid => incoming_unpaid, :outgoing_paid => outgoing_paid, :outgoing_unpaid => outgoing_unpaid}
  end

  def unpaids
    invoices = @current_org.invoices.find_all_by_paid_on nil
    liabilities = @current_org.liabilities.find_all_by_paid_on nil
    ren_cont 'unpaids', {:invoices => invoices, :liabilities => liabilities}
  end

  def contacts
    customers = {}
    suppliers = {}
    @current_org.contacts.each do |c|
      if c.customer
        customers[c.name_long] = [
          ["Total invoices", c.invoices.collect{|i| i.total_value}.sum],
          ["Unpaid invoices", c.invoices.collect{|i| i.paid_on ? 0 : i.total_value}.sum]
        ]
      end
      if c.supplier
        suppliers[c.name_long] = [
          ["Total liabilities", c.liabilities.collect{|l| l.value}.sum],
          ["Unpaid liabilities", c.liabilities.collect{|l| l.paid_on ? 0 : l.value}.sum]
        ]
      end
    end
    ren_cont 'contacts', {:customers => customers, :suppliers => suppliers}
  end

end
