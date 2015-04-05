class User < ActiveRecord::Base

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # virtual attribute for the strip_token (CC processing) so we can keep PCI compliance
  attr_accessor :stripe_token

  validates_presence_of :name
  validates_presence_of :email
  validates_uniqueness_of :email

  # has_many :projects
  has_many :members

  before_update :update_plan_on_stripe
  before_destroy :cancel_subscription
  before_create :set_initial_plan
  after_create :notify_hq_of_new_user
  after_destroy :notify_hq_of_deleted_user
  after_update :notify_hq_of_updated_user


  def notify_hq_of_new_user
    UserMailer.new_user(self).deliver
  end


  def notify_hq_of_deleted_user
    UserMailer.deleted_user(self).deliver
  end


  def notify_hq_of_updated_user
    return if self.plan_was == plan
    return if stripe_customer_id.nil?
    UserMailer.updated_user(self).deliver
  end


  def set_initial_plan
    self.plan = 'free'
  end


  def update_card_on_stripe

    if stripe_customer_id.nil?
      if !stripe_token.present?
        # raise "Stripe token not present. Can't update account. Card not approved."
        self.errors.add(:base, "Stripe token not present. Can't update account. Card not approved.")
      end
      customer = Stripe::Customer.create( :email => email,
                                          :description => name,
                                          :card => stripe_token,
                                          :plan => plan )
    else
      customer = Stripe::Customer.retrieve(stripe_customer_id)
      if stripe_token.present?
          customer.card = stripe_token
      end
      customer.email = email
      customer.description = name
      customer.save
    end

    self.stripe_customer_id = customer.id
    self.stripe_token = nil
    self.save!

    rescue Stripe::StripeError => e
      logger.error "Stripe Error: " + e.message
      errors.add :base, "#{e.message}."
      self.stripe_token = nil
      false
    end


    def update_plan_on_stripe

      return if self.plan_was == plan
      return if stripe_customer_id.nil?

      unless stripe_customer_id.nil?
        customer = Stripe::Customer.retrieve(stripe_customer_id)
        customer.update_subscription(:plan => plan)
      end
      true
    rescue Stripe::StripeError => e
      logger.error "Stripe Error: " + e.message
      errors.add :base, "Unable to update your subscription. #{e.message}."
      false
    end


    def cancel_subscription
      unless stripe_customer_id.nil?
        customer = Stripe::Customer.retrieve(stripe_customer_id)
        unless customer.nil? # or customer.respond_to?('deleted')
          customer.cancel_subscription
        end
      end
    rescue Stripe::StripeError => e
      logger.error "Stripe Error: " + e.message
      puts "Stripe Error: " + e.message
      errors.add :base, "Unable to cancel your subscription. #{e.message}."
      false
    end


    def expire
      UserMailer.expire_email(self).deliver
      destroy
    end

end
