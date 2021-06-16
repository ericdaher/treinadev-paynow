class ValidCnpjValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless CNPJ.valid?(value, strict: true)
      record.errors.add attribute, (options[:message] || "deve ser válido")
    end
  end
end