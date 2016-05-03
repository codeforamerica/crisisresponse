class ResponsePlan < ActiveRecord::Base
  include PgSearch

  has_many :contacts, dependent: :destroy
  has_many :response_strategies, -> { order(:priority) }, dependent: :destroy
  has_many :safety_warnings, dependent: :destroy

  belongs_to :author, class_name: "Officer"
  belongs_to :approver, class_name: "Officer"

  RACE_CODES = {
    "AFRICAN AMERICAN/BLACK" => "B",
    "AMERICAN INDIAN/ALASKAN NATIVE" => "I",
    "ASIAN (ALL)/PACIFIC ISLANDER" => "A",
    "UNKNOWN" => "U",
    "WHITE" => "W",
  }.freeze

  SEX_CODES = {
    "Male" => "M",
    "Female" => "F",
  }.freeze

  validates :sex, inclusion: SEX_CODES.keys, allow_nil: true
  validates :race, inclusion: RACE_CODES.keys, allow_nil: true
  validate :approver_is_not_author
  validate :approved_at_is_present_if_approver_exists
  validate :approver_is_present_if_approved_at_exists

  pg_search_scope(
    :search,
    against: [:first_name, :last_name],
    using: [:tsearch, :dmetaphone, :trigram],
  )

  accepts_nested_attributes_for(
    :response_strategies,
    reject_if: :all_blank,
    allow_destroy: true,
  )

  mount_uploader :image, ImageUploader

  def approved?
    approved_at.present? && approver.present?
  end

  def approver=(value)
    super(value)

    if(value.present?)
      self.approved_at = Time.current
    else
      self.approved_at = nil
    end
  end

  def display_name
    "#{last_name}, #{first_name}"
  end

  def eye_color
    super || "Unknown"
  end

  def hair_color
    super || "Unknown"
  end

  def name=(value)
    (self.first_name, self.last_name) = value.split
  end

  def name
    "#{first_name} #{last_name}"
  end

  def shorthand_description
    [
      RACE_CODES.fetch(race) + SEX_CODES.fetch(sex),
      height_in_feet_and_inches,
      weight_in_pounds ? "#{weight_in_pounds} lb" : nil,
    ].compact.join(" – ")
  end

  private

  def approver_is_not_author
    if approver_id == author_id
      errors.add(:approver, "can not be the person who authored the plan")
    end
  end

  def approved_at_is_present_if_approver_exists
    if approver.present? && approved_at.nil?
      errors.add(
        :approved_at,
        "must be set in order to be approved",
      )
    end
  end

  def approver_is_present_if_approved_at_exists
    if approved_at.present? && approver.nil?
      errors.add(
        :approved_at,
        "cannot be set without an approver",
      )
    end
  end

  def height_in_feet_and_inches
    if height_in_inches
      "#{height_in_inches / 12}'#{height_in_inches % 12}\""
    else
      nil
    end
  end
end
