class Forecast < ActiveRecord::Base
#Defining columns (as in the migration file) but in the model 
#without having a back DB
  def self.columns() @columns ||= []; end

  def self.column(name, sql_type = nil, default = nil, null = true)
    columns << ActiveRecord::ConnectionAdapters::Column.new(name.to_s, default, sql_type.to_s, null)
  end



  column :location, :string #
  column :date, :date
  column :response
  column :daytxt, :hash
  column :daysimple, :hash
  column :hourly, :hash
  column :current, :hash
  column :hourly_data, :String
  
  after_initialize :init
  validates_presence_of :location
  /validate :not_before_today/
 / validate :valid_location/


  def init
    
  end

  def not_before_today
  	errors.add(:date, "Can't be in the past") if date < Date.today
  end

end
