class Company < ApplicationRecord
  has_many :users

  def display_name
    "#{name} (@#{email_provider})"
  end

  def email_provider
    email.split('@').last
  end
end
