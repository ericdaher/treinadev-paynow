class CompanyEmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if record.company.nil?

    unless value.split('@').last == record.company.email_domain
      record.errors.add attribute, (options[:message] || "deve ter o mesmo domínio do email da empresa")
    end
  end
end