class Export::UserCsvRow < RailsUtils::Export::CsvRowDefinition
  column :username, header: "Username", no: 1
  column :is_admin, header: "Role", no: 2 do |user|
    user.is_admin ? "Admin" : "User"
  end
end
