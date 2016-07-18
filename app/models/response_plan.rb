class ResponsePlan < ActiveRecord::Base
  belongs_to :person

  has_many :aliases, dependent: :destroy
  has_many :contacts, dependent: :destroy
  has_many :images, dependent: :destroy
  has_many :response_strategies, -> { order(:priority) }, dependent: :destroy
  has_many :safety_warnings, dependent: :destroy

  accepts_nested_attributes_for(:person)

  accepts_nested_attributes_for(
    :aliases,
    reject_if: :all_blank,
    allow_destroy: true,
  )
  accepts_nested_attributes_for(
    :contacts,
    reject_if: :all_blank,
    allow_destroy: true,
  )
  accepts_nested_attributes_for(
    :images,
    reject_if: :all_blank,
    allow_destroy: true,
  )
  accepts_nested_attributes_for(
    :response_strategies,
    reject_if: :all_blank,
    allow_destroy: true,
  )

  belongs_to :author, class_name: "Officer"
  belongs_to :approver, class_name: "Officer"

  validate :approver_is_not_author
  validate :approved_at_is_present_if_approver_exists
  validate :approver_is_present_if_approved_at_exists

  validates :person, presence: true
  validate :errors_from_associated_person

  accepts_nested_attributes_for(
    :response_strategies,
    reject_if: :all_blank,
    allow_destroy: true,
  )

  def alias_list=(list_of_aliases)
    alias_objects = list_of_aliases.map do |aka|
      Alias.find_or_initialize_by(name: aka, response_plan: self)
    end

    self.aliases = alias_objects
  end

  def alias_list
    aliases.pluck(:name)
  end

  def approved?
    approved_at.present? &&
      approver.present? &&
      approved_at > (updated_at - 1.second)
  end

  def approver=(value)
    super(value)

    if(value.present?)
      self.approved_at = Time.current
    else
      self.approved_at = nil
    end
  end

  def profile_image_url
    if images.any?
      images.first.source_url
    else
      "/assets/default_image.png"
    end
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

  def errors_from_associated_person
    person.validate

    person.errors.each do |attr, message|
      errors.add(attr, message)
    end
  end
end
