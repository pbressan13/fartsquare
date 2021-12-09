class EstablishmentPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end

    # Notice we have closed the definition of Scope class.
    def show?
      scope.where(id: record.id).exists?
    end

    def create?
      true
    end

    def new?
      create?
    end

    def update?
      true
    end

    def edit?
      update?
    end

    def destroy?
      true
    end
  end
end
