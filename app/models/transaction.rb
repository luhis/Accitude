class Transaction < ActiveRecord::Base

  attr_accessible :posted_on, :type, :desc,
                  :amount, :kind

  belongs_to :expense
  belongs_to :wage
  belongs_to :liability
  belongs_to :contact
  belongs_to :bank_account
  belongs_to :invoice

  KINDS = ['Credit', 'Debit']

end
