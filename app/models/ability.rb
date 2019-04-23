class Ability
  include CanCan::Ability

  def initialize(user)

    user ||= AdminUser.new

    case user.role
    when "Owner"
        can :manage, ActiveAdmin
        can :manage, AdminUser
        can :manage, ActiveAdmin::Page, name: "Dashboard", namespace_name: "admin"
        can :manage, ActiveAdmin::Comment
        can :manage, Product
        can :manage, Catagory
        can :manage, Sale
        can :manage, Expense
    when "Employee"
        can :read, ActiveAdmin::Page, name: "Dashboard", namespace_name: "admin"
        can :read, Product
        cannot :destroy, Product
        can :read, Catagory
        can :manage, Sale
        can :manage, Expense
        # can :manage, ActiveAdmin::Comment, resource_type: "Vacancy"
        # can :manage, ActiveAdmin::Comment, resource_type: "Order"
        # can :manage, ActiveAdmin::Comment, resource_type: "Product"
        # can :manage, ActiveAdmin::Comment, resource_type: "Advertisement"
    end
  end
end
