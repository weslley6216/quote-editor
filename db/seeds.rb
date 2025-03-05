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

# Creating line_item_dates and line_items based on the YAML file data

# Mapping of line item dates to actual date values
line_item_dates = {
  'today' => Date.today,
  'next_week' => Date.today + 7.days
}

# Creating line items with corresponding line_item_date associations
quotes.each do |quote_attrs|
  quote = Quote.find_by!(name: quote_attrs[:name], company: companies[quote_attrs[:company_name]])

  line_item_dates.each do |key, date_value|
    # Create line_item_date for each quote and each date (today/next_week)
    line_item_date = LineItemDate.find_or_create_by!(date: date_value, quote: quote)

    # Creating line items based on the fixture data for each line_item_date
    line_items_data = [
      { name: 'Meeting room', description: 'A cosy meeting room for 10 people', quantity: 1, unit_price: 1000 },
      { name: 'Meal tray', description: 'Our delicious meal tray', quantity: 10, unit_price: 25 }
    ]

    line_items_data.each do |line_item_attrs|
      LineItem.find_or_create_by!(line_item_date: line_item_date, **line_item_attrs)
    end
  end
end

puts "✅ Seeded line items and line item dates!"

puts "✅ All seeds have been loaded successfully!"
