# Creating companies and storing them in a hash to avoid repeated lookups
company_names = %w[kpmg pwc]

companies = company_names.index_with do |company_name|
  Company.find_or_create_by!(name: company_name)
end

puts "✅ Seeded #{company_names.size} companies!"

# Creating quotes associated with companies
quotes = [
  { company_name: 'kpmg', name: 'First quote' },
  { company_name: 'kpmg', name: 'Second quote' },
  { company_name: 'kpmg', name: 'Third quote' }
]

quotes.each do |quote_attrs|
  Quote.find_or_create_by!(name: quote_attrs[:name], company: companies[quote_attrs[:company_name]])
end

puts "✅ Seeded #{quotes.size} quotes!"

# Creating users associated with companies
users = [
  { company_name: 'kpmg', email: 'accountant@kpmg.com', password: 'password' },
  { company_name: 'kpmg', email: 'manager@kpmg.com', password: 'password' },
  { company_name: 'pwc', email: 'eavesdropper@pwc.com', password: 'password' }
]

users.each do |user_attrs|
  User.find_or_create_by!(email: user_attrs[:email]) do |user|
    user.company = companies[user_attrs[:company_name]]
    user.password = user_attrs[:password]
  end
end

puts "✅ Seeded #{users.size} users!"

puts "✅ All seeds have been loaded successfully!"
