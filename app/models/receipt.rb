class Receipt < ApplicationRecord
  belongs_to :bill

  def self.search(id)
    Receipt.find(id) if id    
  end
end
