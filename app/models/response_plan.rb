# frozen_string_literal: true

class ResponsePlan < ApplicationRecord
  belongs_to :person

  has_many :contacts, dependent: :destroy
  has_many :deescalation_techniques, dependent: :destroy
  has_many :response_strategies, -> { order(:priority) }, dependent: :destroy
  has_many :safety_concerns, dependent: :destroy
  has_many :triggers, dependent: :destroy

  accepts_nested_attributes_for(:person)

  accepts_nested_attributes_for(
    :contacts,
    reject_if: :all_blank,
    allow_destroy: true,
  )
  accepts_nested_attributes_for(
    :deescalation_techniques,
    reject_if: :all_blank,
    allow_destroy: true,
  )
  accepts_nested_attributes_for(
    :response_strategies,
    reject_if: :all_blank,
    allow_destroy: true,
  )
  accepts_nested_attributes_for(
    :safety_concerns,
    reject_if: :all_blank,
    allow_destroy: true,
  )
  accepts_nested_attributes_for(
    :triggers,
    reject_if: :all_blank,
    allow_destroy: true,
  )

  belongs_to :approver, class_name: "Officer"
  belongs_to :assignee, class_name: "Officer"
  belongs_to :author, class_name: "Officer"

  validate :approved_at_is_present_if_approver_exists
  validate :approver_is_present_if_approved_at_exists

  validates :person, presence: true
  validate :errors_from_associated_person

  def self.approved
    where.not(approved_at: nil)
  end

  def self.drafts
    where(submitted_for_approval_at: nil, approved_at: nil)
  end

  def self.submitted
    where.not(submitted_for_approval_at: nil).where(approved_at: nil)
  end

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

  def draft?
    !approved? && !submitted?
  end

  def safety_concerns_by_category
    SafetyConcern::CATEGORIES.map do |category|
      concerns = safety_concerns.where(category: category)

      if concerns.any?
        [category, concerns]
      end
    end.compact.to_h
  end

  def submitted?
    submitted_for_approval_at.present? && ! approved?
  end

  def to_h
    attributes.merge(
      response_strategies: response_strategies.map(&:attributes),
      contacts: contacts.map(&:attributes),
      deescalation_techniques: deescalation_techniques.map(&:attributes),
      triggers: triggers.map(&:attributes),
    )
  end

  def to_json
    to_h.to_json
  end

  private

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
