class Deliverable < ActiveRecord::Base
  unloadable
  validates_presence_of :subject
  
  belongs_to :project
  has_many :issues

  # TODO: mocked
  def score
    0
  end
  
  # TODO: mocked
  def spent
    0
  end
  
  # TODO: mocked
  def progress
    0
  end
  
  #
  # These attributes can take a Dollar amount or a %
  #
  def overhead=(v)
    if v.match(/%/)
      # Clear amount since this is a %
      write_attribute(:overhead, nil)
      write_attribute(:overhead_percent, v.gsub(/[% ]/,''))
    else
      # Clear % since this is a dollar amount
      write_attribute(:overhead_percent, nil)
      # Take out $, commas, and spaces
      write_attribute(:overhead, v.gsub(/[$, ]/,''))
    end
  end

  def materials=(v)
    if v.match(/%/)
      # Clear amount since this is a %
      write_attribute(:materials, nil)
      write_attribute(:materials_percent, v.gsub(/[% ]/,''))
    else
      # Clear % since this is a dollar amount
      write_attribute(:materials_percent, nil)
      # Take out $, commas, and spaces
      write_attribute(:materials, v.gsub(/[$, ]/,''))
    end
  end

  def profit=(v)
    if v.match(/%/)
      # Clear amount since this is a %
      write_attribute(:profit, nil)
      write_attribute(:profit_percent, v.gsub(/[% ]/,''))
    else
      # Clear % since this is a dollar amount
      write_attribute(:profit_percent, nil)
      # Take out $, commas, and spaces
      write_attribute(:profit, v.gsub(/[$, ]/,''))
    end
  end
end
