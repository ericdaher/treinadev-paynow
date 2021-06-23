# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Admin.create!(email: 'admin@paynow.com.br', password: '12345678')
puts 'Admin created'

c = Company.create!(name: 'CodePlay', cnpj: CNPJ.generate, email: 'faturamento@codeplay.com.br')
puts 'Company created'

User.create!(email: 'supervisor@codeplay.com.br', password: '12345678', company: c)
User.create!(email: 'comum@codeplay.com.br', password: '12345678', company: c)
puts 'Users created'

v = PaymentMethod.create(name: 'VISA', method_type: "credit", payment_tax: 3.99, max_tax: 50, active: true)
t = PaymentMethod.create(name: 'Boleto', method_type: "ticket", payment_tax: 2.99, max_tax: 40, active: true)
p = PaymentMethod.create(name: 'PIX', method_type: "pix", payment_tax: 0.99, max_tax: 30, active: true)
v.icon.attach(io: File.open(Rails.root.join('spec/fixtures/visa_logo.gif')), filename: 'visa_logo.gif')
t.icon.attach(io: File.open(Rails.root.join('spec/fixtures/visa_logo.gif')), filename: 'visa_logo.gif')
p.icon.attach(io: File.open(Rails.root.join('spec/fixtures/visa_logo.gif')), filename: 'visa_logo.gif')
v.save!
t.save!
p.save!
puts 'Payment methods created'

a = AvailablePaymentMethod.create!(company: c, payment_method: v)
puts 'Available payment methods created'

s = Product.create!(name: 'Smartphone', price: 1000, company: c)
v = Product.create!(name: 'Videogame', price: 2000, company: c)
t = Product.create!(name: 'Televisão', price: 1500, company: c)
puts 'Products created'

b = Bill.create!(company: company, product: s, payment_method: a.payment_method, due_date: 5.days.from_now)
Bill.create!(company: company, product: v, payment_method: a.payment_method, due_date: 6.days.from_now)
Bill.create!(company: company, product: t, payment_method: a.payment_method, due_date: 7.days.from_now)
puts 'Bills created'

BillingAttempt.create!(bill: b, attempt_date: 4.days.ago, status: 'rejected_unknown')
BillingAttempt.create!(bill: b, attempt_date: 3.days.ago, status: 'rejected_credit')
BillingAttempt.create!(bill: b, attempt_date: 2.days.ago, status: 'rejected_data')
puts 'Billing attempts created'